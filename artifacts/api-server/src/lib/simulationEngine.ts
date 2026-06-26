import { and, eq, sql } from "drizzle-orm";
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
import { GLOBAL_LEARNING_USER_ID } from "./tenant";

/**
 * 시뮬레이션 표본 추출(역할 기반 공유 모델).
 * 합성 학습 인구는 전역(userId=0) 공유 풀이며, 각 시뮬레이션은 그 풀에서
 * `n`(=simulations.totalAgents = 사용자가 고른 표본 크기)만큼만 결정론적으로
 * 부분 추출해 평가한다. md5(agentId:simId) 정렬로 자치구·연령 셀 순차 생성 편향을
 * 흩뜨려 표본 대표성을 확보하고, 같은 (simId, n) 이면 항상 같은 표본을 돌려줘
 * resume/tick 경로가 동일 집합을 본다.
 */
async function selectSampledAgents(
  simulationId: number,
  n: number,
): Promise<Agent[]> {
  if (n <= 0) return [];
  return db
    .select()
    .from(agentsTable)
    .where(eq(agentsTable.userId, GLOBAL_LEARNING_USER_ID))
    .orderBy(
      sql`md5(${agentsTable.id}::text || ':' || ${simulationId}::text)`,
    )
    .limit(n);
}

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

/**
 * 에이전트 1명당 LLM 호출의 상한 시간(ms). 무의미·악성 입력으로 추론 모델이
 * 응답을 못 끝내거나 네트워크가 hang 해도 tick 이 영영 멈추지 않도록 한다.
 * 타임아웃 시 SDK 가 throw → batchProcess 의 catch 가 중립 fallback 을 기록하므로
 * 진행률은 계속 전진한다. (SDK 자체 재시도는 끄고 batchProcess 재시도만 사용)
 */
const AGENT_CALL_TIMEOUT_MS = 45_000;

async function evaluateAgent(
  agent: Agent,
  sim: Simulation,
): Promise<{ verdict: AgentVerdict; promptTokens: number; completionTokens: number }> {
  const response = await openai.chat.completions.create(
    {
      model: sim.model,
      // gpt-5 계열은 추론 모델이라 max_completion_tokens 에 "추론 토큰"이 포함된다.
      // 값이 작으면(예: 600) 추론에 전부 소진돼 finish_reason='length' + content=''가 되어
      // 모든 응답이 빈 JSON → 기본값(neutral/50)으로 떨어진다. 충분히 크게 둔다.
      max_completion_tokens: 8192,
      messages: [
        {
          role: "system",
          content:
            "당신은 합성 유권자 시뮬레이션 엔진입니다. 주어진 페르소나의 관점을 충실히 반영하여 반드시 유효한 JSON 객체 하나만 출력하세요.",
        },
        { role: "user", content: buildPrompt(agent, sim) },
      ],
      response_format: { type: "json_object" },
    },
    { timeout: AGENT_CALL_TIMEOUT_MS, maxRetries: 0 },
  );

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
  // 지정되면 이 lease 소유자에 한해 완료 처리한다. tick 경로는 무거운 배치 직후
  // 사용자가 중단(stop → pending, 리스 해제)했을 수 있으므로 TICK_WORKER_ID 를 넘겨
  // 중단 승리(stopped sim 부활 방지)를 보장한다. 워커 경로는 생략(무조건 완료).
  requireLockedBy?: string,
): Promise<boolean> {
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

  const finalized = await db
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
      // 예측 잠금(라이프사이클): 완료 시 핵심 예측 지표(찬성률)와 잠금 시각을 기록한다.
      // 이미 잠겨 있으면(과거 완료분 재완료) 보존해 실제값 입력 후의 비교 기준을 흔들지 않는다.
      predictionLockedAt: sim.predictionLockedAt ?? new Date(),
      predictionValue: sim.predictionValue ?? supportPct,
      lockedBy: null,
      lockedAt: null,
      heartbeatAt: null,
    })
    .where(
      requireLockedBy
        ? and(
            eq(simulationsTable.id, sim.id),
            eq(simulationsTable.lockedBy, requireLockedBy),
          )
        : eq(simulationsTable.id, sim.id),
    )
    .returning({ id: simulationsTable.id });

  if (finalized.length === 0) {
    logger.info(
      { simulationId: sim.id },
      "Finalize skipped: lease lost or simulation stopped before completion",
    );
    return false;
  }

  logger.info({ simulationId: sim.id, total }, "Simulation completed");
  return true;
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

    // 전역 인구 풀에서 이 시뮬레이션의 표본(totalAgents)만 결정론적으로 추출.
    const agents = await selectSampledAgents(simulationId, sim.totalAgents);

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
              .set({ progress, heartbeatAt: new Date() })
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
        .set({
          status: "failed",
          lastError: String((err as Error)?.message ?? err).slice(0, 500),
          lockedBy: null,
          lockedAt: null,
          heartbeatAt: null,
        })
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

/**
 * 한 틱(tick)에서 처리할 최대 에이전트 수. 클라이언트 구동(B1) 처리에서 한 번의
 * HTTP 요청이 이 수만큼만 평가하고 반환한다. Autoscale 요청 타임아웃 안에 한 틱이
 * 끝나야 하므로 동시성(8)의 배수로 작게 잡는다(기본 16 = 2웨이브). 한 틱이 타임아웃에
 * 잘려도 증분 저장 + 멱등 insert 덕분에 다음 틱이 이어받으므로 데이터 손실은 없다.
 * 배포 환경(모델 속도)에 맞춰 `TICK_MAX_AGENTS` env 로 조정 가능.
 */
const TICK_MAX_AGENTS = (() => {
  const v = Number(process.env["TICK_MAX_AGENTS"]);
  return Number.isFinite(v) && v >= 1 ? Math.floor(v) : 16;
})();

/**
 * 이 프로세스의 tick 워커 식별자 + 리스 만료 시간. Autoscale 다중 인스턴스에서
 * 같은 시뮬레이션을 두 인스턴스가 동시에 전진시켜 중복 LLM 호출이 발생하지 않도록,
 * 워커(worker.ts)와 동일한 DB 리스(claim) 규약을 tick 경로에도 적용한다.
 */
const TICK_WORKER_ID = `tick-${process.pid}-${Math.random().toString(36).slice(2, 8)}`;
const TICK_STALE_MS = 60_000;

/**
 * 시뮬레이션을 "한 배치(batch)"만 전진시킨다 — 클라이언트 구동(B1) 처리용.
 *
 * 프런트엔드(진행률 화면)가 이 함수를 트리거하는 `/tick` 요청을 주기적으로 호출해
 * 시뮬레이션을 조금씩 진행시킨다. 항상 가동되는 워커에 의존하지 않으므로,
 * Autoscale 배포(유휴 시 0으로 축소)에서도 사용자가 화면을 보는 동안만 비용이 든다.
 *
 * 내구성/멱등성은 runSimulation 과 동일한 규약을 따른다:
 *  - 항상 resume 의미(이미 응답 있는 에이전트는 건너뜀), 기존 결과를 지우지 않는다.
 *  - 각 에이전트 응답을 즉시 영속화(증분 저장 + onConflictDoNothing).
 *  - 남은 에이전트가 없으면 finalize(완료 집계). 비용은 다중 세션이라 추정치로 보정.
 *  - activeRuns 인메모리 가드로 같은 프로세스 내 동시 배치를 직렬화한다(중복 호출은 즉시 반환).
 *  - DB 리스(claim)로 다중 인스턴스(Autoscale)에서도 한 번에 한 인스턴스만 전진시킨다.
 */
export async function processSimulationBatch(
  simulationId: number,
  opts: { maxAgents?: number } = {},
): Promise<void> {
  const maxAgents = opts.maxAgents ?? TICK_MAX_AGENTS;
  if (activeRuns.has(simulationId)) {
    // 이미 이 프로세스에서 배치가 진행 중 — 즉시 반환(겹친 tick 요청은 무비용).
    return;
  }
  activeRuns.add(simulationId);
  try {
    // DB 리스(claim): queued, 또는 running 이지만 우리 소유/리스 만료(고아)인 경우에만
    // 원자적으로 점유한다. claim 실패 = pending/completed/failed 이거나 다른 살아있는
    // 인스턴스가 처리 중 → 즉시 반환(중복 LLM 호출 방지). worker.ts 와 동일 규약.
    const staleCutoff = new Date(Date.now() - TICK_STALE_MS);
    const claim = await db.execute<{ id: number }>(sql`
      UPDATE simulations
         SET status = 'running',
             locked_by = ${TICK_WORKER_ID},
             locked_at = now(),
             heartbeat_at = now(),
             last_error = NULL
       WHERE id = ${simulationId}
         AND (
           status = 'queued'
           OR (
             status = 'running'
             AND (
               locked_by = ${TICK_WORKER_ID}
               OR locked_by IS NULL
               OR heartbeat_at IS NULL
               OR heartbeat_at < ${staleCutoff}
             )
           )
         )
      RETURNING id`);
    if (claim.rows.length === 0) {
      // claim 불가 — pending/completed/failed 이거나 다른 살아있는 인스턴스가 점유 중.
      logger.debug(
        { simulationId, worker: TICK_WORKER_ID },
        "Tick lease not acquired; another driver owns this simulation",
      );
      return;
    }

    const [sim] = await db
      .select()
      .from(simulationsTable)
      .where(eq(simulationsTable.id, simulationId));
    if (!sim) {
      logger.warn({ simulationId }, "processSimulationBatch: simulation not found");
      return;
    }

    // 전역 인구 풀에서 이 시뮬레이션의 표본(totalAgents)만 결정론적으로 추출.
    const agents = await selectSampledAgents(simulationId, sim.totalAgents);

    const existing = await db
      .select({ agentId: simulationResponsesTable.agentId })
      .from(simulationResponsesTable)
      .where(eq(simulationResponsesTable.simulationId, simulationId));
    const doneAgentIds = new Set<number>(existing.map((r) => r.agentId));
    const alreadyDone = doneAgentIds.size;
    const pending = agents.filter((a) => !doneAgentIds.has(a.id));

    // 리스는 이미 우리 소유 — totalAgents/진행률/하트비트만 갱신. 단 claim 직후의
    // 좁은 틈에 stop(리스 해제)이 들어올 수 있으므로 이 쓰기도 lease-조건부로 둬서
    // 멈춘(pending) 시뮬레이션에 progress/heartbeat 가 남지 않도록 한다.
    await db
      .update(simulationsTable)
      .set({
        totalAgents: agents.length,
        progress:
          agents.length === 0
            ? 0
            : Math.floor((alreadyDone / agents.length) * 100),
        heartbeatAt: new Date(),
      })
      .where(
        and(
          eq(simulationsTable.id, simulationId),
          eq(simulationsTable.lockedBy, TICK_WORKER_ID),
        ),
      );

    if (pending.length === 0) {
      // 남은 에이전트가 없다 — 완료 집계 후 종료.
      await finalizeSimulation(sim, 0, 0, false, TICK_WORKER_ID);
      return;
    }

    const slice = pending.slice(0, maxAgents);
    const snapshotPolicy = isPolicySim(sim);

    logger.info(
      {
        simulationId,
        totalAgents: agents.length,
        alreadyDone,
        batchSize: slice.length,
        remaining: pending.length,
      },
      "Processing simulation batch (client-driven tick)",
    );

    await batchProcess(
      slice,
      async (agent) => {
        let verdict: AgentVerdict;
        try {
          const r = await evaluateAgent(agent, sim);
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
      { concurrency: RUN_CONCURRENCY, retries: 4 },
    );

    // 배치 후: 무거운 LLM 호출 중에 사용자가 중단(stop → status=pending, 리스 해제)
    // 했거나 다른 인스턴스가 리스를 가져갔을 수 있다. 진행률/완료 집계를 쓰기 전에
    // 우리가 여전히 running 리스를 소유하는지 재확인한다 — 아니면 멈춘 시뮬레이션을
    // 되살리지 않도록 즉시 종료한다(이 배치가 삽입한 일부 응답은 다음 /run 이 비운다).
    const [current] = await db
      .select({
        status: simulationsTable.status,
        lockedBy: simulationsTable.lockedBy,
      })
      .from(simulationsTable)
      .where(eq(simulationsTable.id, simulationId));
    if (
      !current ||
      current.status !== "running" ||
      current.lockedBy !== TICK_WORKER_ID
    ) {
      logger.info(
        { simulationId, status: current?.status },
        "Batch result discarded: lease lost or simulation stopped mid-batch",
      );
      return;
    }

    // 배치 후 실제 영속된 응답 수로 진행률 재계산(정확성). 모두 끝났으면 finalize.
    const after = await db
      .select({ agentId: simulationResponsesTable.agentId })
      .from(simulationResponsesTable)
      .where(eq(simulationResponsesTable.simulationId, simulationId));
    const nowDone = after.length;
    // 진행불가(stall) 가드: 정상 동작에선 batchProcess 의 catch 가 실패 에이전트도
    // 중립 fallback 으로 반드시 insert 하므로 비어있지 않은 slice 를 처리한 뒤엔
    // nowDone 이 반드시 alreadyDone 보다 커야 한다. 그대로면(0건 영속) DB insert
    // 자체가 체계적으로 실패하는 비정상 상태 → 무한 tick 루프를 끊고 failed 처리한다.
    if (slice.length > 0 && nowDone <= alreadyDone) {
      logger.error(
        { simulationId, alreadyDone, nowDone, sliceSize: slice.length },
        "Simulation stalled: batch persisted no new responses; marking failed",
      );
      await db
        .update(simulationsTable)
        .set({
          status: "failed",
          lastError:
            "배치가 새 응답을 하나도 저장하지 못했습니다(진행 불가). 다시 실행해주세요.",
          lockedBy: null,
          lockedAt: null,
          heartbeatAt: null,
        })
        .where(
          and(
            eq(simulationsTable.id, simulationId),
            eq(simulationsTable.lockedBy, TICK_WORKER_ID),
          ),
        );
      return;
    }
    if (nowDone >= agents.length) {
      await finalizeSimulation(sim, 0, 0, false, TICK_WORKER_ID);
    } else {
      // 진행률/heartbeat 쓰기도 lease-조건부로 — 재확인과 이 update 사이의 미세한
      // 틈에 stop 이 들어오면(리스 해제) 멈춘 시뮬레이션을 되살리지 않도록 no-op.
      await db
        .update(simulationsTable)
        .set({
          progress:
            agents.length === 0
              ? 100
              : Math.floor((nowDone / agents.length) * 100),
          heartbeatAt: new Date(),
        })
        .where(
          and(
            eq(simulationsTable.id, simulationId),
            eq(simulationsTable.lockedBy, TICK_WORKER_ID),
          ),
        );
    }
  } catch (err) {
    logger.error({ err, simulationId }, "Simulation batch failed");
    try {
      // 우리가 여전히 소유한 리스에 대해서만 failed 로 전환한다 — 그 사이 사용자가
      // 중단(stop → pending, 리스 해제)했다면 pending 을 failed 로 덮어쓰지 않는다.
      await db
        .update(simulationsTable)
        .set({
          status: "failed",
          lastError: String((err as Error)?.message ?? err).slice(0, 500),
          lockedBy: null,
          lockedAt: null,
          heartbeatAt: null,
        })
        .where(
          and(
            eq(simulationsTable.id, simulationId),
            eq(simulationsTable.lockedBy, TICK_WORKER_ID),
          ),
        );
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
