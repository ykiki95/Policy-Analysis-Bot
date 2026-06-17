import { eq } from "drizzle-orm";
import {
  db,
  agentsTable,
  simulationsTable,
  simulationResponsesTable,
  type Agent,
  type Simulation,
  type InsertSimulationResponse,
} from "@workspace/db";
import { openai } from "@workspace/integrations-openai-ai-server";
import { batchProcess } from "@workspace/integrations-openai-ai-server/batch";
import { logger } from "./logger";
import { costFromUsage, estimateCost, RUN_CONCURRENCY } from "./pricing";
import { buildPrompt, isCommercialSim, isPolicySim } from "./prompts";

type AgentVerdict = {
  stance: "support" | "oppose" | "neutral";
  score: number;
  confidence: number;
  reasoning: string;
};

function clampInt(value: unknown, min: number, max: number, fallback: number) {
  const n = typeof value === "number" ? value : Number(value);
  if (Number.isNaN(n)) return fallback;
  return Math.max(min, Math.min(max, Math.round(n)));
}

function normalizeStance(value: unknown, score: number): AgentVerdict["stance"] {
  const s = String(value).toLowerCase();
  if (s.includes("support") || s.includes("찬")) return "support";
  if (s.includes("oppose") || s.includes("반")) return "oppose";
  if (s.includes("neutral") || s.includes("중")) return "neutral";
  if (score >= 60) return "support";
  if (score <= 40) return "oppose";
  return "neutral";
}

async function evaluateAgent(
  agent: Agent,
  sim: Simulation,
): Promise<{ verdict: AgentVerdict; promptTokens: number; completionTokens: number }> {
  const response = await openai.chat.completions.create({
    model: sim.model,
    max_completion_tokens: 600,
    messages: [
      {
        role: "system",
        content:
          "당신은 합성 유권자 시뮬레이션 엔진입니다. 주어진 페르소나의 관점을 충실히 반영하여 반드시 유효한 JSON 객체 하나만 출력하세요.",
      },
      { role: "user", content: buildPrompt(agent, sim) },
    ],
    response_format: { type: "json_object" },
  });

  const content = response.choices[0]?.message?.content ?? "{}";
  let parsed: Record<string, unknown> = {};
  try {
    parsed = JSON.parse(content);
  } catch {
    parsed = {};
  }

  const score = clampInt(parsed.score, 0, 100, 50);
  const verdict: AgentVerdict = {
    score,
    confidence: clampInt(parsed.confidence, 0, 100, 60),
    stance: normalizeStance(parsed.stance, score),
    reasoning:
      typeof parsed.reasoning === "string" && parsed.reasoning.trim().length > 0
        ? parsed.reasoning.trim()
        : "해당 페르소나의 성향에 기반한 반응입니다.",
  };

  return {
    verdict,
    promptTokens: response.usage?.prompt_tokens ?? 0,
    completionTokens: response.usage?.completion_tokens ?? 0,
  };
}

function pct(part: number, total: number): number {
  if (total === 0) return 0;
  return Math.round((part / total) * 1000) / 10;
}

function buildSummary(
  sim: Simulation,
  supportPct: number,
  opposePct: number,
  neutralPct: number,
  topDistrict: string,
): string {
  const commercial = isCommercialSim(sim);
  const policy = isPolicySim(sim);
  const acceptanceTrack = commercial || policy;
  const verdict =
    supportPct >= 55
      ? "전반적으로 우호적인 반응"
      : opposePct >= 55
        ? "전반적으로 부정적인 반응"
        : acceptanceTrack
          ? "수용과 거부가 팽팽하게 갈리는 반응"
          : "찬반이 팽팽하게 갈리는 반응";
  const posLabel = acceptanceTrack ? "수용" : "찬성";
  const negLabel = acceptanceTrack ? "거부" : "반대";
  return `전국 합성 인구 ${sim.totalAgents}명 시뮬레이션 결과 ${verdict}이 나타났습니다. ${posLabel} ${supportPct}%, ${negLabel} ${opposePct}%, 중립 ${neutralPct}%로, ${topDistrict} 지역에서 ${acceptanceTrack ? "수용도" : "지지"}가 가장 높았습니다.`;
}

export async function runSimulation(simulationId: number): Promise<void> {
  try {
    const [sim] = await db
      .select()
      .from(simulationsTable)
      .where(eq(simulationsTable.id, simulationId));
    if (!sim) {
      logger.warn({ simulationId }, "runSimulation: simulation not found");
      return;
    }

    const agents = await db.select().from(agentsTable);

    await db
      .update(simulationsTable)
      .set({ status: "running", progress: 0, totalAgents: agents.length })
      .where(eq(simulationsTable.id, simulationId));

    let lastWritten = 0;
    let totalPromptTokens = 0;
    let totalCompletionTokens = 0;

    const results = await batchProcess(
      agents,
      async (agent) => {
        try {
          const r = await evaluateAgent(agent, sim);
          totalPromptTokens += r.promptTokens;
          totalCompletionTokens += r.completionTokens;
          return { agent, verdict: r.verdict };
        } catch (err) {
          logger.warn(
            { err, agentId: agent.id },
            "Agent evaluation failed after retries; using neutral fallback",
          );
          const fallback: AgentVerdict = {
            stance: "neutral",
            score: 50,
            confidence: 40,
            reasoning: "평가 중 오류가 발생하여 중립으로 처리되었습니다.",
          };
          return { agent, verdict: fallback };
        }
      },
      {
        concurrency: RUN_CONCURRENCY,
        retries: 4,
        onProgress: (completed, total) => {
          const progress = Math.floor((completed / total) * 100);
          if (progress - lastWritten >= 5 || completed === total) {
            lastWritten = progress;
            db
              .update(simulationsTable)
              .set({ progress })
              .where(eq(simulationsTable.id, simulationId))
              .then(undefined, (err) =>
                logger.error({ err, simulationId }, "Progress update failed"),
              );
          }
        },
      },
    );

    const snapshotPolicy = isPolicySim(sim);
    const rows: InsertSimulationResponse[] = results.map(
      ({ agent, verdict }) => ({
        simulationId,
        agentId: agent.id,
        agentName: agent.name,
        district: agent.district,
        ageBracket: agent.ageBracket,
        gender: agent.gender,
        politicalLeaning: agent.politicalLeaning,
        policyStances: snapshotPolicy ? agent.policyStances : null,
        stance: verdict.stance,
        score: verdict.score,
        confidence: verdict.confidence,
        reasoning: verdict.reasoning,
      }),
    );

    await db
      .delete(simulationResponsesTable)
      .where(eq(simulationResponsesTable.simulationId, simulationId));
    if (rows.length > 0) {
      await db.insert(simulationResponsesTable).values(rows);
    }

    const total = rows.length;
    const support = rows.filter((r) => r.stance === "support").length;
    const oppose = rows.filter((r) => r.stance === "oppose").length;
    const neutral = total - support - oppose;
    const avgScore =
      total === 0
        ? 0
        : Math.round(
            (rows.reduce((acc, r) => acc + r.score, 0) / total) * 10,
          ) / 10;

    const districtScores = new Map<string, { sum: number; count: number }>();
    for (const r of rows) {
      const entry = districtScores.get(r.district) ?? { sum: 0, count: 0 };
      entry.sum += r.score;
      entry.count += 1;
      districtScores.set(r.district, entry);
    }
    let topDistrict = "—";
    let topAvg = -1;
    for (const [district, { sum, count }] of districtScores) {
      const avg = sum / count;
      if (avg > topAvg) {
        topAvg = avg;
        topDistrict = district;
      }
    }

    const supportPct = pct(support, total);
    const opposePct = pct(oppose, total);
    const neutralPct = pct(neutral, total);

    const costActual =
      totalPromptTokens + totalCompletionTokens > 0
        ? costFromUsage(sim.model, totalPromptTokens, totalCompletionTokens)
        : estimateCost(sim.model, total).estimatedCostUsd;

    await db
      .update(simulationsTable)
      .set({
        status: "completed",
        progress: 100,
        overallSupport: avgScore,
        supportPct,
        opposePct,
        neutralPct,
        costActualUsd: costActual,
        summary: buildSummary(sim, supportPct, opposePct, neutralPct, topDistrict),
        completedAt: new Date(),
      })
      .where(eq(simulationsTable.id, simulationId));

    logger.info({ simulationId, total }, "Simulation completed");
  } catch (err) {
    logger.error({ err, simulationId }, "Simulation run failed");
    try {
      await db
        .update(simulationsTable)
        .set({ status: "failed" })
        .where(eq(simulationsTable.id, simulationId));
    } catch (updateErr) {
      logger.error(
        { err: updateErr, simulationId },
        "Failed to mark simulation as failed",
      );
    }
  }
}
