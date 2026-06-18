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

function buildResponseRow(
  simulationId: number,
  agent: Agent,
  verdict: AgentVerdict,
  snapshotPolicy: boolean,
): InsertSimulationResponse {
  return {
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
  };
}

/**
 * 완료된(또는 재개 후 완료된) 시뮬레이션의 최종 집계를 DB에 영속화한다.
 * 집계는 항상 simulation_responses 전체(기존 + 이번 세션 신규)에서 다시 읽어
 * 계산하므로 fresh 실행과 resume 실행 모두 동일하게 동작한다.
 */
async function finalizeSimulation(
  sim: Simulation,
  promptTokens: number,
  completionTokens: number,
  tokensCoverAllAgents: boolean,
): Promise<void> {
  const persisted = await db
    .select({
      stance: simulationResponsesTable.stance,
      score: simulationResponsesTable.score,
      district: simulationResponsesTable.district,
    })
    .from(simulationResponsesTable)
    .where(eq(simulationResponsesTable.simulationId, sim.id));

  const total = persisted.length;
  const support = persisted.filter((r) => r.stance === "support").length;
  const oppose = persisted.filter((r) => r.stance === "oppose").length;
  const neutral = total - support - oppose;
  const avgScore =
    total === 0
      ? 0
      : Math.round(
          (persisted.reduce((acc, r) => acc + r.score, 0) / total) * 10,
        ) / 10;

  const districtScores = new Map<string, { sum: number; count: number }>();
  for (const r of persisted) {
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

  // 비용은 이번 세션에서 실제 호출한 토큰으로 계산한다. 단 resume 실행은
  // 이전 세션(크래시 전)의 토큰을 복구할 수 없어 세션 토큰만으로는 체계적으로
  // 과소계상되므로, 일부 에이전트만 이번 세션에서 처리된 경우(전체를 커버하지
  // 못하는 경우)에는 전체 에이전트 기준 추정치로 보정한다.
  const costActual =
    tokensCoverAllAgents && promptTokens + completionTokens > 0
      ? costFromUsage(sim.model, promptTokens, completionTokens)
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
    .where(eq(simulationsTable.id, sim.id));

  logger.info({ simulationId: sim.id, total }, "Simulation completed");
}

/**
 * 시뮬레이션을 실행한다. 내구성(durability) 보장:
 *  - 각 에이전트 응답을 평가 직후 곧바로 DB에 영속화한다(증분 저장).
 *    서버가 중간에 죽어도 이미 끝난 에이전트의 결과는 남는다.
 *  - resume=true 면 이미 응답이 있는 에이전트는 건너뛰고 남은 것만 처리한다.
 *    (서버 부팅 시 startup recovery 가 orphaned "running" 시뮬레이션을 재개)
 *  - resume=false(신규 실행) 면 기존 응답을 먼저 지우고 처음부터 실행한다.
 */
/**
 * 같은 프로세스 안에서 동일 시뮬레이션이 동시에 두 번 실행되는 것을 막는
 * 인메모리 가드. (예: /run 레이스, 부팅 복구와 수동 재실행 중복) DB insert 는
 * 유니크 인덱스로 멱등하지만, LLM 호출 자체의 중복은 비용을 낭비하므로 차단한다.
 * 다중 인스턴스 배포에서는 DB lease 가 필요하나 현재 단일 프로세스 데모 범위 밖.
 */
const activeRuns = new Set<number>();

export async function runSimulation(
  simulationId: number,
  opts: { resume?: boolean } = {},
): Promise<void> {
  const resume = opts.resume ?? false;
  if (activeRuns.has(simulationId)) {
    logger.warn(
      { simulationId },
      "runSimulation: already running in this process; skipping duplicate",
    );
    return;
  }
  activeRuns.add(simulationId);
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

    // 신규 실행은 이전 결과를 초기화한다. resume 은 보존한다.
    if (!resume) {
      await db
        .delete(simulationResponsesTable)
        .where(eq(simulationResponsesTable.simulationId, simulationId));
    }

    // resume 시 이미 처리된 에이전트 id 집합을 구해 건너뛴다.
    const doneAgentIds = new Set<number>();
    if (resume) {
      const existing = await db
        .select({ agentId: simulationResponsesTable.agentId })
        .from(simulationResponsesTable)
        .where(eq(simulationResponsesTable.simulationId, simulationId));
      for (const r of existing) doneAgentIds.add(r.agentId);
    }

    const alreadyDone = doneAgentIds.size;
    const pendingAgents = agents.filter((a) => !doneAgentIds.has(a.id));

    await db
      .update(simulationsTable)
      .set({
        status: "running",
        progress:
          agents.length === 0
            ? 0
            : Math.floor((alreadyDone / agents.length) * 100),
        totalAgents: agents.length,
      })
      .where(eq(simulationsTable.id, simulationId));

    logger.info(
      {
        simulationId,
        resume,
        totalAgents: agents.length,
        alreadyDone,
        pending: pendingAgents.length,
      },
      resume ? "Resuming simulation" : "Starting simulation",
    );

    const snapshotPolicy = isPolicySim(sim);
    let totalPromptTokens = 0;
    let totalCompletionTokens = 0;
    let lastWritten = -1;

    await batchProcess(
      pendingAgents,
      async (agent) => {
        let verdict: AgentVerdict;
        try {
          const r = await evaluateAgent(agent, sim);
          totalPromptTokens += r.promptTokens;
          totalCompletionTokens += r.completionTokens;
          verdict = r.verdict;
        } catch (err) {
          logger.warn(
            { err, agentId: agent.id },
            "Agent evaluation failed after retries; using neutral fallback",
          );
          verdict = {
            stance: "neutral",
            score: 50,
            confidence: 40,
            reasoning: "평가 중 오류가 발생하여 중립으로 처리되었습니다.",
          };
        }

        // 내구성: 결과를 즉시 영속화한다. resume 재처리 시 중복은 무시한다.
        await db
          .insert(simulationResponsesTable)
          .values(buildResponseRow(simulationId, agent, verdict, snapshotPolicy))
          .onConflictDoNothing({
            target: [
              simulationResponsesTable.simulationId,
              simulationResponsesTable.agentId,
            ],
          });

        return null;
      },
      {
        concurrency: RUN_CONCURRENCY,
        retries: 4,
        onProgress: (completed, total) => {
          const overall = alreadyDone + completed;
          const grand = alreadyDone + total;
          const progress =
            grand === 0 ? 100 : Math.floor((overall / grand) * 100);
          if (progress - lastWritten >= 5 || overall === grand) {
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

    // 이번 세션이 전체 에이전트를 처리했을 때만 토큰 기반 실비용을 신뢰한다.
    await finalizeSimulation(
      sim,
      totalPromptTokens,
      totalCompletionTokens,
      alreadyDone === 0,
    );
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
  } finally {
    activeRuns.delete(simulationId);
  }
}
