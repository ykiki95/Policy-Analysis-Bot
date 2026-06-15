import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { eq, desc } from "drizzle-orm";
import {
  db,
  agentsTable,
  simulationsTable,
  simulationResponsesTable,
} from "@workspace/db";
import {
  ListSimulationsResponse,
  ListSimulationsResponseItem,
  CreateSimulationBody,
  EstimateSimulationBody,
  EstimateSimulationResponse,
  GetSimulationParams,
  GetSimulationResponse,
  DeleteSimulationParams,
  RunSimulationParams,
  ListSimulationResponsesParams,
  ListSimulationResponsesResponse,
} from "@workspace/api-zod";
import {
  estimateCost,
  DEFAULT_MODEL,
  isSupportedModel,
} from "../lib/pricing";
import { runSimulation } from "../lib/simulationEngine";

const router: IRouter = Router();

function leaningBucket(leaning: number): string {
  if (leaning <= -34) return "진보";
  if (leaning >= 34) return "보수";
  return "중도";
}

async function countAgents(): Promise<number> {
  const rows = await db.select({ id: agentsTable.id }).from(agentsTable);
  return rows.length;
}

router.get("/simulations", async (_req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(simulationsTable)
    .orderBy(desc(simulationsTable.createdAt));
  res.json(ListSimulationsResponse.parse(jsonReady(rows)));
});

router.post("/simulations/estimate", async (req, res): Promise<void> => {
  const parsed = EstimateSimulationBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const totalAgents = parsed.data.totalAgents ?? (await countAgents());
  if (!Number.isFinite(totalAgents) || totalAgents < 1) {
    res.status(400).json({ error: "totalAgents must be a positive integer" });
    return;
  }
  const estimate = estimateCost(parsed.data.model, totalAgents);
  res.json(EstimateSimulationResponse.parse(estimate));
});

router.post("/simulations", async (req, res): Promise<void> => {
  const parsed = CreateSimulationBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const model =
    parsed.data.model && isSupportedModel(parsed.data.model)
      ? parsed.data.model
      : DEFAULT_MODEL;
  const totalAgents = await countAgents();
  const estimate = estimateCost(model, totalAgents);

  const [sim] = await db
    .insert(simulationsTable)
    .values({
      title: parsed.data.title,
      audience: parsed.data.audience,
      product: parsed.data.product,
      policyText: parsed.data.policyText,
      model,
      status: "pending",
      progress: 0,
      totalAgents,
      costEstimateUsd: estimate.estimatedCostUsd,
    })
    .returning();

  res.status(201).json(ListSimulationsResponseItem.parse(jsonReady(sim)));
});

router.get("/simulations/:id", async (req, res): Promise<void> => {
  const params = GetSimulationParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const [sim] = await db
    .select()
    .from(simulationsTable)
    .where(eq(simulationsTable.id, params.data.id));
  if (!sim) {
    res.status(404).json({ error: "Simulation not found" });
    return;
  }

  const rows = await db
    .select({
      stance: simulationResponsesTable.stance,
      score: simulationResponsesTable.score,
      district: simulationResponsesTable.district,
      ageBracket: simulationResponsesTable.ageBracket,
      gender: simulationResponsesTable.gender,
      politicalLeaning: agentsTable.politicalLeaning,
    })
    .from(simulationResponsesTable)
    .innerJoin(agentsTable, eq(simulationResponsesTable.agentId, agentsTable.id))
    .where(eq(simulationResponsesTable.simulationId, params.data.id));

  type Row = (typeof rows)[number];
  const group = (keyFn: (r: Row) => string) => {
    const map = new Map<
      string,
      { count: number; support: number; oppose: number; neutral: number; scoreSum: number }
    >();
    for (const r of rows) {
      const key = keyFn(r);
      const e =
        map.get(key) ?? {
          count: 0,
          support: 0,
          oppose: 0,
          neutral: 0,
          scoreSum: 0,
        };
      e.count += 1;
      e.scoreSum += r.score;
      if (r.stance === "support") e.support += 1;
      else if (r.stance === "oppose") e.oppose += 1;
      else e.neutral += 1;
      map.set(key, e);
    }
    const pct = (part: number, total: number) =>
      total === 0 ? 0 : Math.round((part / total) * 1000) / 10;
    return Array.from(map.entries())
      .map(([key, e]) => ({
        key,
        count: e.count,
        supportPct: pct(e.support, e.count),
        opposePct: pct(e.oppose, e.count),
        neutralPct: pct(e.neutral, e.count),
        avgScore: Math.round((e.scoreSum / e.count) * 10) / 10,
      }))
      .sort((a, b) => b.count - a.count);
  };

  res.json(
    GetSimulationResponse.parse(
      jsonReady({
        simulation: sim,
        results: {
          byDistrict: group((r) => r.district),
          byAgeBracket: group((r) => r.ageBracket),
          byGender: group((r) => r.gender),
          byLeaning: group((r) => leaningBucket(r.politicalLeaning)),
        },
      }),
    ),
  );
});

router.post("/simulations/:id/run", async (req, res): Promise<void> => {
  const params = RunSimulationParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const [sim] = await db
    .select()
    .from(simulationsTable)
    .where(eq(simulationsTable.id, params.data.id));
  if (!sim) {
    res.status(404).json({ error: "Simulation not found" });
    return;
  }
  if (sim.status === "running") {
    res.status(202).json(ListSimulationsResponseItem.parse(jsonReady(sim)));
    return;
  }

  const [updated] = await db
    .update(simulationsTable)
    .set({ status: "running", progress: 0, summary: null, completedAt: null })
    .where(eq(simulationsTable.id, params.data.id))
    .returning();

  void runSimulation(params.data.id).catch((err) =>
    req.log.error({ err, id: params.data.id }, "Background simulation run crashed"),
  );

  res.status(202).json(ListSimulationsResponseItem.parse(jsonReady(updated)));
});

router.get("/simulations/:id/responses", async (req, res): Promise<void> => {
  const params = ListSimulationResponsesParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const rows = await db
    .select()
    .from(simulationResponsesTable)
    .where(eq(simulationResponsesTable.simulationId, params.data.id))
    .orderBy(simulationResponsesTable.id);
  res.json(ListSimulationResponsesResponse.parse(jsonReady(rows)));
});

router.delete("/simulations/:id", async (req, res): Promise<void> => {
  const params = DeleteSimulationParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  await db
    .delete(simulationResponsesTable)
    .where(eq(simulationResponsesTable.simulationId, params.data.id));
  const [deleted] = await db
    .delete(simulationsTable)
    .where(eq(simulationsTable.id, params.data.id))
    .returning();
  if (!deleted) {
    res.status(404).json({ error: "Simulation not found" });
    return;
  }
  res.sendStatus(204);
});

export default router;
