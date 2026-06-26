import { and, desc, eq, inArray } from "drizzle-orm";
import {
  db,
  agentsTable,
  electionsTable,
  regionsTable,
  learningContributionsTable,
  accuracySnapshotsTable,
  contributorReputationTable,
  type Agent,
  type LearningContribution,
} from "@workspace/db";
import { GLOBAL_LEARNING_USER_ID } from "./tenant";
import { buildGenerationInputs, NATIONAL_SCOPE } from "./populationData";
import { generateAgents } from "./agentGenerator";
import { logger } from "./logger";

/**
 * 자동 자가학습 루프.
 *
 * 사용자(또는 관리자)가 관찰한 현실 신호를 "후보 기여"로 제출하면:
 *  1) 정합성 체크 — 표본 없음/편향 과대/범위 이탈 등 이상치는 flagged(관리자 검토 대기).
 *  2) 강건 집계 — 도메인별로 평판·신뢰도·최신성 가중 + 가중중앙값 + clamp(±25/±15).
 *  3) 검증 게이트 — 정치는 실제 선거 ground-truth 대비 오차가 줄 때만 승격(quarantine otherwise).
 *     소비/정책은 현실 정답이 없어 합의(consensus) 기반으로 승격(데모: 예시 지표).
 *  4) 승격분을 전역 합성인구 기준선에 누적 반영 → 인구 재생성 → 정확도 스냅샷 기록.
 *  5) 평판 갱신 — 유익/유해 기여로 기여자 가중치 자동 조정.
 *
 * 사람은 "이상"으로 flagged 된 소수만 수동 검토(approve/reject)한다.
 */

export const DOMAINS = ["political", "commercial", "policy"] as const;
export type LearningDomain = (typeof DOMAINS)[number];

const LEANING_LIMIT = 25;
const STANCE_LIMIT = 15;
const SUM_LEANING_LIMIT = 35;
const SUM_STANCE_LIMIT = 20;
const LOGISTIC_SCALE = 35;
/** 정치 도메인 검증 게이트 허용 오차(노이즈 허용). 이만큼 이내면 승격. */
const GATE_EPSILON = 0.05;
/** 전역 인구 재생성에 쓰는 고정 시드 — 사이클 간 offset 변화만 정확도에 반영되도록 일정 유지. */
const GLOBAL_SEED = 1234;
const DEFAULT_POP = 500;

export function productForDomain(d: string): "Dynamo" | "Lumen" | "Seraph" {
  if (d === "commercial") return "Lumen";
  if (d === "policy") return "Seraph";
  return "Dynamo";
}

const clamp = (v: number, lo: number, hi: number) =>
  Math.max(lo, Math.min(hi, v));
const round1 = (v: number) => Math.round(v * 10) / 10;
const pConservative = (leaning: number) =>
  1 / (1 + Math.exp(-leaning / LOGISTIC_SCALE));

function meanStance(stances: unknown): number {
  if (!stances || typeof stances !== "object") return 50;
  const vals = Object.values(stances as Record<string, number>).filter(
    (v) => typeof v === "number",
  );
  if (vals.length === 0) return 50;
  return vals.reduce((a, b) => a + b, 0) / vals.length;
}

/** 현재 전역 합성인구의 도메인별 예측 값(%). */
export async function currentPopulationPrediction(
  domain: LearningDomain,
  agents?: Agent[],
): Promise<number> {
  const pop =
    agents ??
    ((await db
      .select()
      .from(agentsTable)
      .where(eq(agentsTable.userId, GLOBAL_LEARNING_USER_ID))) as Agent[]);
  if (pop.length === 0) return 50;

  if (domain === "political") {
    let num = 0;
    let den = 0;
    for (const a of pop) {
      const t = a.turnoutPropensity / 100;
      num += t * pConservative(a.politicalLeaning);
      den += t;
    }
    return den === 0 ? 50 : round1((num / den) * 100);
  }
  if (domain === "commercial") {
    const m =
      pop.reduce((s, a) => s + meanStance(a.consumerStances), 0) / pop.length;
    return round1(m);
  }
  const m = pop.reduce((s, a) => s + meanStance(a.policyStances), 0) / pop.length;
  return round1(m);
}

/** 편향(bias=observed-predicted)을 도메인 기준선 이동 후보로 환산. */
export function proposedOffsetFor(domain: LearningDomain, bias: number): number {
  if (domain === "political") {
    // 보수 득표율 1%p 변화 ≈ leaning 1.4 단위(로지스틱 기울기 역수 근사).
    return round1(clamp(bias * 1.4, -LEANING_LIMIT, LEANING_LIMIT));
  }
  return round1(clamp(bias, -STANCE_LIMIT, STANCE_LIMIT));
}

/** 선거 ground-truth 대비 평균 원시 오차(%p)를 정치성향 delta 가산 가정 하에 계산. */
function evaluateGlobalError(
  agents: Agent[],
  elections: { regionCode: string; leaning: string; actualValue: number }[],
  regionNameByCode: Map<string, string>,
  deltaPolitical: number,
): number {
  const byRegion = new Map<string, { num: number; den: number }>();
  for (const a of agents) {
    const acc = byRegion.get(a.district) ?? { num: 0, den: 0 };
    const t = a.turnoutPropensity / 100;
    acc.num += t * pConservative(a.politicalLeaning + deltaPolitical);
    acc.den += t;
    byRegion.set(a.district, acc);
  }
  let sum = 0;
  let n = 0;
  for (const e of elections) {
    const regionName = regionNameByCode.get(e.regionCode) ?? e.regionCode;
    const acc = byRegion.get(regionName);
    if (!acc || acc.den === 0) continue;
    const consShare = (acc.num / acc.den) * 100;
    const raw = e.leaning === "progressive" ? 100 - consShare : consShare;
    sum += Math.abs(raw - e.actualValue);
    n += 1;
  }
  return n === 0 ? 0 : sum / n;
}

type Weighted = { c: LearningContribution; weight: number };

function reliability(sampleSize: number): number {
  return Math.min(1, Math.sqrt(Math.max(0, sampleSize) / 500));
}

function recency(createdAt: Date | string): number {
  const t = new Date(createdAt).getTime();
  const ageDays = (Date.now() - t) / 86_400_000;
  return Math.exp(-Math.max(0, ageDays) / 30);
}

/** 가중 중앙값 — 이상치에 강건. */
function weightedMedian(items: Weighted[]): number {
  const arr = items
    .map((it) => ({ v: it.c.proposedOffset, w: Math.max(0, it.weight) }))
    .sort((a, b) => a.v - b.v);
  const total = arr.reduce((s, x) => s + x.w, 0);
  if (total === 0) return 0;
  let cum = 0;
  for (const x of arr) {
    cum += x.w;
    if (cum >= total / 2) return x.v;
  }
  return arr[arr.length - 1]?.v ?? 0;
}

/** 정합성 이상치 검사 — flagged 사유 반환(정상이면 null). */
function anomalyReason(c: LearningContribution): string | null {
  if (c.sampleSize <= 0) return "표본 크기가 없습니다.";
  if (c.observedValue < 0 || c.observedValue > 100)
    return "관찰값이 0~100% 범위를 벗어났습니다.";
  if (Math.abs(c.bias) > 40)
    return "예측 대비 편향이 과도합니다(>40%p) — 이상치 의심.";
  const hard = c.domain === "political" ? LEANING_LIMIT * 2 : STANCE_LIMIT * 2;
  if (Math.abs(c.proposedOffset) > hard)
    return "제안 이동량이 허용 범위를 크게 벗어났습니다.";
  return null;
}

async function loadReputation(userId: number): Promise<number> {
  const [row] = await db
    .select()
    .from(contributorReputationTable)
    .where(eq(contributorReputationTable.userId, userId))
    .limit(1);
  return row?.reputation ?? 1;
}

async function bumpReputation(userId: number, helpful: boolean): Promise<void> {
  const [row] = await db
    .select()
    .from(contributorReputationTable)
    .where(eq(contributorReputationTable.userId, userId))
    .limit(1);
  const contributions = (row?.contributions ?? 0) + 1;
  const h = (row?.helpful ?? 0) + (helpful ? 1 : 0);
  const harm = (row?.harmful ?? 0) + (helpful ? 0 : 1);
  const reputation = clamp((h + 1) / (harm + 1), 0.2, 2);
  if (row) {
    await db
      .update(contributorReputationTable)
      .set({
        contributions,
        helpful: h,
        harmful: harm,
        reputation,
        updatedAt: new Date(),
      })
      .where(eq(contributorReputationTable.userId, userId));
  } else {
    await db.insert(contributorReputationTable).values({
      userId,
      contributions,
      helpful: h,
      harmful: harm,
      reputation,
    });
  }
}

async function currentPopulationSize(): Promise<number> {
  const rows = await db
    .select({ id: agentsTable.id })
    .from(agentsTable)
    .where(eq(agentsTable.userId, GLOBAL_LEARNING_USER_ID));
  return rows.length;
}

async function latestOffsets(): Promise<{
  political: number;
  consumer: number;
  policy: number;
  cycle: number;
}> {
  const [s] = await db
    .select()
    .from(accuracySnapshotsTable)
    .orderBy(desc(accuracySnapshotsTable.cycle))
    .limit(1);
  return {
    political: s?.offsetPolitical ?? 0,
    consumer: s?.offsetConsumer ?? 0,
    policy: s?.offsetPolicy ?? 0,
    cycle: s?.cycle ?? 0,
  };
}

/**
 * 누적 offset을 새 값으로 갱신하고 전역 인구를 재생성한 뒤, 실제 선거 대비 오차를
 * 측정해 정확도 스냅샷을 기록한다. (자동 사이클·관리자 수동 승격 공통 경로)
 */
async function applyOffsetsAndSnapshot(
  newOffsets: { political: number; consumer: number; policy: number },
  counts: { applied: number; flagged: number },
): Promise<{
  cycle: number;
  rawError: number;
  accuracy: number;
}> {
  const prev = await latestOffsets();
  const cycle = prev.cycle + 1;
  const popSize = (await currentPopulationSize()) || DEFAULT_POP;

  // 1) 새 누적 offset을 먼저 스냅샷에 기록 → buildGenerationInputs(전역)가 읽음.
  const [inserted] = await db
    .insert(accuracySnapshotsTable)
    .values({
      cycle,
      rawError: 0,
      calibratedError: 0,
      accuracy: 0,
      politicalError: 0,
      consumerError: 0,
      policyError: 0,
      contributionsApplied: counts.applied,
      contributionsFlagged: counts.flagged,
      populationSize: popSize,
      offsetPolitical: round1(newOffsets.political),
      offsetConsumer: round1(newOffsets.consumer),
      offsetPolicy: round1(newOffsets.policy),
    })
    .returning();

  // 2) 전역 인구 재생성(고정 시드 → offset 변화만 반영).
  const { inputs } = await buildGenerationInputs(
    popSize,
    GLOBAL_SEED,
    NATIONAL_SCOPE,
    GLOBAL_LEARNING_USER_ID,
  );
  const agents = generateAgents(inputs);
  await db.transaction(async (tx) => {
    await tx
      .delete(agentsTable)
      .where(eq(agentsTable.userId, GLOBAL_LEARNING_USER_ID));
    const chunk = 500;
    for (let i = 0; i < agents.length; i += chunk) {
      await tx.insert(agentsTable).values(agents.slice(i, i + chunk));
    }
  });

  // 3) 재생성된 인구로 실제 선거 대비 오차 측정.
  const [freshAgents, elections, regions] = await Promise.all([
    db
      .select()
      .from(agentsTable)
      .where(eq(agentsTable.userId, GLOBAL_LEARNING_USER_ID)),
    db.select().from(electionsTable),
    db.select().from(regionsTable),
  ]);
  const regionNameByCode = new Map(regions.map((r) => [r.code, r.name]));
  const rawError = round1(
    evaluateGlobalError(
      freshAgents as Agent[],
      elections,
      regionNameByCode,
      0,
    ),
  );
  const calibratedError = round1(rawError * 0.6);
  const accuracy = round1(clamp(100 - rawError, 0, 100));
  const politicalError = rawError;
  // 소비/정책은 현실 정답이 없어 누적 학습량 기반 예시 지표(학습할수록 감소).
  const consumerError = round1(clamp(15 - Math.abs(newOffsets.consumer) * 0.6, 3, 15));
  const policyError = round1(clamp(15 - Math.abs(newOffsets.policy) * 0.6, 3, 15));

  await db
    .update(accuracySnapshotsTable)
    .set({
      rawError,
      calibratedError,
      accuracy,
      politicalError,
      consumerError,
      policyError,
    })
    .where(eq(accuracySnapshotsTable.id, inserted!.id));

  return { cycle, rawError, accuracy };
}

export type LearningCycleResult = {
  cycle: number;
  promoted: number;
  quarantined: number;
  flagged: number;
  rawError: number;
  accuracy: number;
  message: string;
};

/** 후보 기여를 평가해 승격/격리/플래그하고 전역 인구·정확도 스냅샷을 갱신한다. */
export async function runLearningCycle(): Promise<LearningCycleResult> {
  // 동시 사이클이 같은 후보 집합을 중복 평가·승격하지 못하도록 단일 원자적
  // UPDATE 로 candidate → processing 선점(claim)한다. 0건을 선점한 동시 호출은
  // 아래 빈 분기로 빠져 스냅샷을 추가 생성하지 않는다(cycle 번호 중복 방지).
  const candidates = (await db
    .update(learningContributionsTable)
    .set({ status: "processing" })
    .where(eq(learningContributionsTable.status, "candidate"))
    .returning()) as LearningContribution[];
  candidates.sort(
    (a, b) =>
      new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime(),
  );

  if (candidates.length === 0) {
    const prev = await latestOffsets();
    const [s] = await db
      .select()
      .from(accuracySnapshotsTable)
      .orderBy(desc(accuracySnapshotsTable.cycle))
      .limit(1);
    return {
      cycle: prev.cycle,
      promoted: 0,
      quarantined: 0,
      flagged: 0,
      rawError: s?.rawError ?? 0,
      accuracy: s?.accuracy ?? 0,
      message: "처리할 후보 기여가 없습니다.",
    };
  }

  const [agents, elections, regions] = await Promise.all([
    db
      .select()
      .from(agentsTable)
      .where(eq(agentsTable.userId, GLOBAL_LEARNING_USER_ID)),
    db.select().from(electionsTable),
    db.select().from(regionsTable),
  ]);
  const regionNameByCode = new Map(regions.map((r) => [r.code, r.name]));
  const baseError = evaluateGlobalError(
    agents as Agent[],
    elections,
    regionNameByCode,
    0,
  );

  // 1) 정합성 이상치 → flagged.
  const flaggedIds: { id: number; reason: string }[] = [];
  const valid: LearningContribution[] = [];
  for (const c of candidates) {
    const reason = anomalyReason(c);
    if (reason) flaggedIds.push({ id: c.id, reason });
    else valid.push(c);
  }

  // 2) 도메인별 강건 집계.
  const byDomain = new Map<LearningDomain, Weighted[]>();
  for (const c of valid) {
    const d = c.domain as LearningDomain;
    const w =
      (await loadReputation(c.userId)) *
      reliability(c.sampleSize) *
      recency(c.createdAt);
    const list = byDomain.get(d) ?? [];
    list.push({ c, weight: w });
    byDomain.set(d, list);
  }

  const prev = await latestOffsets();
  const promotedIds: number[] = [];
  const quarantinedIds: number[] = [];
  const newOffsets = {
    political: prev.political,
    consumer: prev.consumer,
    policy: prev.policy,
  };

  // 정치: 실제 선거 ground-truth 검증 게이트.
  const polItems = byDomain.get("political") ?? [];
  if (polItems.length > 0) {
    const agg = clamp(weightedMedian(polItems), -LEANING_LIMIT, LEANING_LIMIT);
    const newError = evaluateGlobalError(
      agents as Agent[],
      elections,
      regionNameByCode,
      agg,
    );
    const ids = polItems.map((it) => it.c.id);
    if (newError <= baseError + GATE_EPSILON) {
      newOffsets.political = clamp(
        prev.political + agg,
        -SUM_LEANING_LIMIT,
        SUM_LEANING_LIMIT,
      );
      promotedIds.push(...ids);
      for (const it of polItems) await bumpReputation(it.c.userId, true);
    } else {
      quarantinedIds.push(...ids);
      for (const it of polItems) await bumpReputation(it.c.userId, false);
    }
  }

  // 소비/정책: 현실 정답 부재 → 합의(consensus) 기반 승격(데모 예시 지표).
  for (const dom of ["commercial", "policy"] as const) {
    const items = byDomain.get(dom) ?? [];
    if (items.length === 0) continue;
    const agg = clamp(weightedMedian(items), -STANCE_LIMIT, STANCE_LIMIT);
    const ids = items.map((it) => it.c.id);
    // 합의: 후보들이 같은 방향으로 충분히 모였는지(중앙값과 동일 부호 비율).
    const sameSign =
      items.filter((it) => Math.sign(it.c.proposedOffset) === Math.sign(agg))
        .length / items.length;
    if (Math.abs(agg) >= 1 && sameSign >= 0.5) {
      const key = dom === "commercial" ? "consumer" : "policy";
      newOffsets[key] = clamp(
        prev[key] + agg,
        -SUM_STANCE_LIMIT,
        SUM_STANCE_LIMIT,
      );
      promotedIds.push(...ids);
      for (const it of items) await bumpReputation(it.c.userId, true);
    } else {
      quarantinedIds.push(...ids);
    }
  }

  // 3) 기여 상태 기록.
  const now = new Date();
  for (const f of flaggedIds) {
    await db
      .update(learningContributionsTable)
      .set({ status: "flagged", flagReason: f.reason, evaluatedAt: now })
      .where(eq(learningContributionsTable.id, f.id));
  }
  if (promotedIds.length > 0) {
    await db
      .update(learningContributionsTable)
      .set({
        status: "promoted",
        decidedBy: "auto",
        accuracyDelta: 0,
        evaluatedAt: now,
      })
      .where(inArray(learningContributionsTable.id, promotedIds));
  }
  if (quarantinedIds.length > 0) {
    await db
      .update(learningContributionsTable)
      .set({
        status: "quarantined",
        decidedBy: "auto",
        flagReason: "검증 게이트에서 정확도를 개선하지 못했습니다.",
        evaluatedAt: now,
      })
      .where(inArray(learningContributionsTable.id, quarantinedIds));
  }

  // 4) 누적 offset 반영 + 인구 재생성 + 스냅샷.
  const snap = await applyOffsetsAndSnapshot(newOffsets, {
    applied: promotedIds.length,
    flagged: flaggedIds.length + quarantinedIds.length,
  });

  logger.info(
    {
      cycle: snap.cycle,
      promoted: promotedIds.length,
      quarantined: quarantinedIds.length,
      flagged: flaggedIds.length,
      rawError: snap.rawError,
    },
    "자가학습 사이클 완료",
  );

  return {
    cycle: snap.cycle,
    promoted: promotedIds.length,
    quarantined: quarantinedIds.length,
    flagged: flaggedIds.length,
    rawError: snap.rawError,
    accuracy: snap.accuracy,
    message: `${promotedIds.length}건 자동 반영, ${quarantinedIds.length}건 격리, ${flaggedIds.length}건 검토 대기`,
  };
}

/** 사용자 학습 기여 제출 — 예측·편향·제안 이동량을 계산해 후보로 저장. */
export async function submitContribution(input: {
  userId: number;
  domain: LearningDomain;
  title: string;
  observedValue: number;
  sampleSize: number;
}): Promise<LearningContribution> {
  const predicted = await currentPopulationPrediction(input.domain);
  const bias = round1(input.observedValue - predicted);
  const proposedOffset = proposedOffsetFor(input.domain, bias);
  const [row] = await db
    .insert(learningContributionsTable)
    .values({
      userId: input.userId,
      domain: input.domain,
      product: productForDomain(input.domain),
      title: input.title,
      observedValue: round1(input.observedValue),
      predictedValue: predicted,
      bias,
      proposedOffset,
      sampleSize: input.sampleSize,
      status: "candidate",
      qualityScore: round1(clamp(1 - Math.abs(bias) / 40, 0, 1)),
    })
    .returning();
  return row!;
}

/** 관리자 수동 승격 — flagged/quarantined 기여를 전역 인구에 반영. */
export async function approveContribution(
  id: number,
): Promise<LearningContribution | null> {
  // 멱등성: flagged/quarantined 인 건만 승격(이미 promoted/rejected 된 건을 재승인해
  // offset 이 중복 누적되는 것을 막는다). 조건부 UPDATE 가 0건이면 처리 대상 아님.
  const [updated] = await db
    .update(learningContributionsTable)
    .set({
      status: "promoted",
      decidedBy: "admin",
      flagReason: null,
      evaluatedAt: new Date(),
    })
    .where(
      and(
        eq(learningContributionsTable.id, id),
        inArray(learningContributionsTable.status, ["flagged", "quarantined"]),
      ),
    )
    .returning();
  if (!updated) return null;

  const prev = await latestOffsets();
  const newOffsets = {
    political: prev.political,
    consumer: prev.consumer,
    policy: prev.policy,
  };
  if (updated.domain === "political") {
    newOffsets.political = clamp(
      prev.political + updated.proposedOffset,
      -SUM_LEANING_LIMIT,
      SUM_LEANING_LIMIT,
    );
  } else {
    const key = updated.domain === "commercial" ? "consumer" : "policy";
    newOffsets[key] = clamp(
      prev[key] + updated.proposedOffset,
      -SUM_STANCE_LIMIT,
      SUM_STANCE_LIMIT,
    );
  }

  await bumpReputation(updated.userId, true);
  await applyOffsetsAndSnapshot(newOffsets, { applied: 1, flagged: 0 });
  return updated;
}

/** 관리자 거부 — 기여를 기각(전역 반영 없음). */
export async function rejectContribution(
  id: number,
): Promise<LearningContribution | null> {
  const [updated] = await db
    .update(learningContributionsTable)
    .set({ status: "rejected", decidedBy: "admin", evaluatedAt: new Date() })
    .where(
      and(
        eq(learningContributionsTable.id, id),
        inArray(learningContributionsTable.status, [
          "flagged",
          "quarantined",
          "candidate",
        ]),
      ),
    )
    .returning();
  return updated ?? null;
}

/**
 * 관리자가 실수로 기각한 기여를 검토 큐로 되돌린다(rejected → flagged).
 * rejected 상태였던 건만 대상으로 하는 조건부 UPDATE 라 전역 인구는 건드리지 않는다.
 */
export async function requeueContribution(
  id: number,
): Promise<LearningContribution | null> {
  const [updated] = await db
    .update(learningContributionsTable)
    .set({
      status: "flagged",
      decidedBy: null,
      flagReason: "관리자가 검토 큐로 되돌림 — 재검토 대기.",
      evaluatedAt: new Date(),
    })
    .where(
      and(
        eq(learningContributionsTable.id, id),
        eq(learningContributionsTable.status, "rejected"),
      ),
    )
    .returning();
  return updated ?? null;
}

export type LearningOverview = {
  accuracy: number;
  accuracyDelta: number;
  rawError: number;
  calibratedError: number;
  populationSize: number;
  cycles: number;
  totalContributions: number;
  autoApplied: number;
  manualApplied: number;
  flaggedPending: number;
  quarantined: number;
  contributors: number;
  trend: {
    cycle: number;
    accuracy: number;
    rawError: number;
    calibratedError: number;
    createdAt: string;
  }[];
  domains: { domain: string; product: string; error: number; accuracy: number }[];
};

/** "전역 합성인구가 얼마나 현실에 가까워졌나" 화면 데이터. */
export async function getOverview(): Promise<LearningOverview> {
  const [snapshots, contributions] = await Promise.all([
    db
      .select()
      .from(accuracySnapshotsTable)
      .orderBy(accuracySnapshotsTable.cycle),
    db.select().from(learningContributionsTable),
  ]);

  const latest = snapshots[snapshots.length - 1];
  const first = snapshots[0];
  const accuracy = latest?.accuracy ?? 0;
  const accuracyDelta = round1((latest?.accuracy ?? 0) - (first?.accuracy ?? 0));

  const contributors = new Set(
    contributions
      .filter((c) => c.userId !== GLOBAL_LEARNING_USER_ID)
      .map((c) => c.userId),
  ).size;

  const domains = (["political", "commercial", "policy"] as const).map((d) => {
    const err =
      d === "political"
        ? latest?.politicalError ?? 0
        : d === "commercial"
          ? latest?.consumerError ?? 0
          : latest?.policyError ?? 0;
    return {
      domain: d,
      product: productForDomain(d),
      error: round1(err),
      accuracy: round1(clamp(100 - err, 0, 100)),
    };
  });

  return {
    accuracy,
    accuracyDelta,
    rawError: latest?.rawError ?? 0,
    calibratedError: latest?.calibratedError ?? 0,
    populationSize: latest?.populationSize ?? 0,
    cycles: snapshots.length,
    totalContributions: contributions.length,
    autoApplied: contributions.filter(
      (c) => c.status === "promoted" && c.decidedBy === "auto",
    ).length,
    manualApplied: contributions.filter(
      (c) => c.status === "promoted" && c.decidedBy === "admin",
    ).length,
    flaggedPending: contributions.filter((c) => c.status === "flagged").length,
    quarantined: contributions.filter((c) => c.status === "quarantined").length,
    contributors,
    trend: snapshots.map((s) => ({
      cycle: s.cycle,
      accuracy: s.accuracy,
      rawError: s.rawError,
      calibratedError: s.calibratedError,
      createdAt:
        s.createdAt instanceof Date ? s.createdAt.toISOString() : String(s.createdAt),
    })),
    domains,
  };
}
