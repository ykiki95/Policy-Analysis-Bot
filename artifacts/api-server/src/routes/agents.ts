import { Router, type IRouter } from "express";
import { eq, and, type SQL } from "drizzle-orm";
import { db, agentsTable } from "@workspace/db";
import { jsonReady } from "../lib/serialize";
import {
  ListAgentsResponse,
  ListAgentsQueryParams,
  GetAgentSummaryResponse,
  GetAgentParams,
  GetAgentResponse,
} from "@workspace/api-zod";

const router: IRouter = Router();

function leaningBucket(leaning: number): string {
  if (leaning <= -34) return "진보";
  if (leaning >= 34) return "보수";
  return "중도";
}

router.get("/agents", async (req, res): Promise<void> => {
  const query = ListAgentsQueryParams.safeParse(req.query);
  if (!query.success) {
    res.status(400).json({ error: query.error.message });
    return;
  }
  const { district, gender, ageBracket, limit } = query.data;

  const conditions: SQL[] = [];
  if (district) conditions.push(eq(agentsTable.district, district));
  if (gender) conditions.push(eq(agentsTable.gender, gender));
  if (ageBracket) conditions.push(eq(agentsTable.ageBracket, ageBracket));

  const base = db.select().from(agentsTable);
  const filtered =
    conditions.length > 0 ? base.where(and(...conditions)) : base;
  const ordered = filtered.orderBy(agentsTable.id);
  const rows = await (limit ? ordered.limit(limit) : ordered);

  res.json(ListAgentsResponse.parse(jsonReady(rows)));
});

router.get("/agents/summary", async (_req, res): Promise<void> => {
  const rows = await db.select().from(agentsTable);
  const total = rows.length;

  const breakdown = (
    keyFn: (a: (typeof rows)[number]) => string,
  ) => {
    const map = new Map<string, { count: number; leaningSum: number }>();
    for (const a of rows) {
      const key = keyFn(a);
      const entry = map.get(key) ?? { count: 0, leaningSum: 0 };
      entry.count += 1;
      entry.leaningSum += a.politicalLeaning;
      map.set(key, entry);
    }
    return Array.from(map.entries())
      .map(([key, { count, leaningSum }]) => ({
        key,
        count,
        avgLeaning: Math.round((leaningSum / count) * 10) / 10,
      }))
      .sort((a, b) => b.count - a.count);
  };

  const avgTurnout =
    total === 0
      ? 0
      : Math.round(
          (rows.reduce((acc, a) => acc + a.turnoutPropensity, 0) / total) * 10,
        ) / 10;
  const avgLeaning =
    total === 0
      ? 0
      : Math.round(
          (rows.reduce((acc, a) => acc + a.politicalLeaning, 0) / total) * 10,
        ) / 10;

  res.json(
    GetAgentSummaryResponse.parse({
      total,
      byDistrict: breakdown((a) => a.district),
      byAgeBracket: breakdown((a) => a.ageBracket),
      byGender: breakdown((a) => a.gender),
      byLeaning: breakdown((a) => leaningBucket(a.politicalLeaning)),
      avgTurnout,
      avgLeaning,
    }),
  );
});

router.get("/agents/:id", async (req, res): Promise<void> => {
  const params = GetAgentParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const [agent] = await db
    .select()
    .from(agentsTable)
    .where(eq(agentsTable.id, params.data.id));
  if (!agent) {
    res.status(404).json({ error: "Agent not found" });
    return;
  }
  res.json(GetAgentResponse.parse(jsonReady(agent)));
});

export default router;
