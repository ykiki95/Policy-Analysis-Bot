import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { eq, desc, and } from "drizzle-orm";
import {
  db,
  agentsTable,
  simulationsTable,
  simulationResponsesTable,
  calibrationsTable,
  calibrationSettingsTable,
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
  EnterSimulationActualParams,
  EnterSimulationActualBody,
  LearnFromSimulationParams,
  LearnFromSimulationResponse,
  ListSimulationResponsesParams,
  ListSimulationResponsesResponse,
} from "@workspace/api-zod";
import { estimateCost, DEFAULT_MODEL, isSupportedModel } from "../lib/pricing";
import { processSimulationBatch } from "../lib/simulationEngine";
import { tenantId, isAdmin } from "../lib/tenant";
import { assertWithinBudgetTx, BudgetExceededError, DISPLAY_MULTIPLIER } from "../lib/budget";
import { runLimiter } from "../lib/rateLimit";
import { POLICY_AXIS_KEYS, POLICY_AXIS_LABELS } from "../lib/policyWeighting";
import {
  buildOutputCalibrationModel,
  applyOutputCalibration,
} from "../lib/calibrationModel";

const router: IRouter = Router();

function leaningBucket(leaning: number): string {
  if (leaning <= -34) return "진보";
  if (leaning >= 34) return "보수";
  return "중도";
}

function policyAxisBucket(value: number): string {
  if (value >= 67) return "상";
  if (value <= 33) return "하";
  return "중";
}

const POLICY_BUCKET_ORDER: Record<string, number> = { 상: 0, 중: 1, 하: 2 };

async function countAgents(userId: number): Promise<number> {
  const rows = await db
    .select({ id: agentsTable.id })
    .from(agentsTable)
    .where(eq(agentsTable.userId, userId));
  return rows.length;
}

router.get("/simulations", async (req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(simulationsTable)
    .where(eq(simulationsTable.userId, tenantId(req)))
    .orderBy(desc(simulationsTable.createdAt));
  res.json(ListSimulationsResponse.parse(jsonReady(rows)));
});

router.post("/simulations/estimate", async (req, res): Promise<void> => {
  const parsed = EstimateSimulationBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const totalAgents =
    parsed.data.totalAgents ?? (await countAgents(tenantId(req)));
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
  const totalAgents = await countAgents(tenantId(req));
  const estimate = estimateCost(model, totalAgents);

  const [sim] = await db
    .insert(simulationsTable)
    .values({
      userId: tenantId(req),
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
  const uid = tenantId(req);
  const [sim] = await db
    .select()
    .from(simulationsTable)
    .where(
      and(
        eq(simulationsTable.id, params.data.id),
        eq(simulationsTable.userId, uid),
      ),
    );
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
      politicalLeaning: simulationResponsesTable.politicalLeaning,
      policyStances: simulationResponsesTable.policyStances,
    })
    .from(simulationResponsesTable)
    .where(eq(simulationResponsesTable.simulationId, params.data.id));

  type Row = (typeof rows)[number];
  const pct = (part: number, total: number) =>
    total === 0 ? 0 : Math.round((part / total) * 1000) / 10;

  const groupBy = (
    source: Row[],
    keyFn: (r: Row) => string,
    sortFn?: (a: { key: string }, b: { key: string }) => number,
  ) => {
    const map = new Map<
      string,
      {
        count: number;
        support: number;
        oppose: number;
        neutral: number;
        scoreSum: number;
      }
    >();
    for (const r of source) {
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
    const out = Array.from(map.entries()).map(([key, e]) => ({
      key,
      count: e.count,
      supportPct: pct(e.support, e.count),
      opposePct: pct(e.oppose, e.count),
      neutralPct: pct(e.neutral, e.count),
      avgScore: Math.round((e.scoreSum / e.count) * 10) / 10,
    }));
    return out.sort(sortFn ?? ((a, b) => b.count - a.count));
  };
  const group = (keyFn: (r: Row) => string) => groupBy(rows, keyFn);

  // Policy-axis cross-analysis: only when this is a Seraph (policy) sim and the
  // responses carry the policy snapshot captured at run time.
  const isPolicy = sim.product?.toLowerCase() === "seraph";
  const policyRows = isPolicy ? rows.filter((r) => r.policyStances != null) : [];
  const byPolicyAxis =
    policyRows.length > 0
      ? POLICY_AXIS_KEYS.map((axis) => ({
          axis,
          label: POLICY_AXIS_LABELS[axis],
          segments: groupBy(
            policyRows,
            (r) => policyAxisBucket(r.policyStances?.[axis] ?? 50),
            (a, b) =>
              (POLICY_BUCKET_ORDER[a.key] ?? 99) -
              (POLICY_BUCKET_ORDER[b.key] ?? 99),
          ),
        }))
      : undefined;

  // 출력 보정(Lever 2): 이 시뮬레이션 제품의 과거 검증 이벤트에서 학습한
  // 평균 편향으로 원시 지지율을 사후 교정한다. 완료된 시뮬레이션에만 적용.
  // 검증 이벤트/설정은 시뮬레이션 소유자(테넌트) 스코프로 조회한다.
  let calibration:
    | {
        applied: boolean;
        eventCount: number;
        meanBias: number;
        shrinkage: number;
        calibratedSupportPct: number | null;
        calibratedOpposePct: number | null;
        calibratedNeutralPct: number | null;
        events: {
          id: number;
          title: string;
          eventType: string;
          targetDate: string;
          actualValue: number;
          rawPrediction: number;
          bias: number;
        }[];
      }
    | undefined;

  if (
    sim.status === "completed" &&
    sim.supportPct != null &&
    sim.opposePct != null &&
    sim.neutralPct != null
  ) {
    const [productEvents, [settings]] = await Promise.all([
      db
        .select()
        .from(calibrationsTable)
        .where(
          and(
            eq(calibrationsTable.product, sim.product),
            eq(calibrationsTable.userId, uid),
          ),
        )
        .orderBy(desc(calibrationsTable.targetDate)),
      db
        .select()
        .from(calibrationSettingsTable)
        .where(eq(calibrationSettingsTable.userId, uid))
        .limit(1),
    ]);
    const model = buildOutputCalibrationModel(
      productEvents,
      settings?.shrinkageFactor ?? 0.4,
    );
    const calibrated = applyOutputCalibration(
      {
        supportPct: sim.supportPct,
        opposePct: sim.opposePct,
        neutralPct: sim.neutralPct,
      },
      model,
    );
    calibration = {
      applied: model.applied,
      eventCount: model.eventCount,
      meanBias: model.meanBias,
      shrinkage: model.shrinkage,
      calibratedSupportPct: calibrated?.supportPct ?? null,
      calibratedOpposePct: calibrated?.opposePct ?? null,
      calibratedNeutralPct: calibrated?.neutralPct ?? null,
      events: productEvents.map((ev) => ({
        id: ev.id,
        title: ev.title,
        eventType: ev.eventType,
        targetDate: ev.targetDate,
        actualValue: ev.actualValue,
        rawPrediction: ev.rawPrediction,
        bias: Math.round((ev.actualValue - ev.rawPrediction) * 10) / 10,
      })),
    };
  }

  res.json(
    GetSimulationResponse.parse(
      jsonReady({
        simulation: sim,
        results: {
          byDistrict: group((r) => r.district),
          byAgeBracket: group((r) => r.ageBracket),
          byGender: group((r) => r.gender),
          byLeaning: group((r) => leaningBucket(r.politicalLeaning)),
          ...(byPolicyAxis ? { byPolicyAxis } : {}),
        },
        ...(calibration ? { calibration } : {}),
      }),
    ),
  );
});

router.post("/simulations/:id/run", runLimiter, async (req, res): Promise<void> => {
  const params = RunSimulationParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const uid = tenantId(req);
  const [sim] = await db
    .select()
    .from(simulationsTable)
    .where(
      and(
        eq(simulationsTable.id, params.data.id),
        eq(simulationsTable.userId, uid),
      ),
    );
  if (!sim) {
    res.status(404).json({ error: "Simulation not found" });
    return;
  }
  if (sim.status === "running" || sim.status === "queued") {
    res.status(202).json(ListSimulationsResponseItem.parse(jsonReady(sim)));
    return;
  }

  // 실행 시점 기준으로 추정 비용을 재계산한다(생성 후 인구 규모가 바뀌었을 수
  // 있으므로 저장된 costEstimateUsd 를 그대로 신뢰하지 않는다).
  const freshAgents = await countAgents(uid);
  const freshEstimate = estimateCost(sim.model, freshAgents).estimatedCostUsd;

  // 예산 검사 + 큐 적재를 하나의 트랜잭션으로 묶는다. 사용자 행을 FOR UPDATE 로
  // 잠가 동시 enqueue 를 직렬화하고, 대기열/실행중 예약분까지 합산해 한도 초과를
  // 막는다. 통과 시에만 status='queued' + 재계산 추정치로 갱신한다.
  let updated;
  try {
    updated = await db.transaction(async (tx) => {
      await assertWithinBudgetTx(tx, uid, freshEstimate);
      // (재)실행은 항상 깨끗한 상태에서 시작한다 — 이전 실행/완료의 응답을 비운다.
      // 처리(processSimulationBatch)는 resume 의미이므로, 비우지 않으면 재실행이
      // 기존 응답을 "이미 완료"로 보고 즉시 종료하거나(인구 재생성 시) 과거+신규
      // 응답이 섞여 집계가 오염된다. 크래시 중단 후 이어하기는 /tick(resume)이
      // 담당하며 /run 을 다시 호출하지 않으므로 여기서 비워도 안전하다.
      await tx
        .delete(simulationResponsesTable)
        .where(eq(simulationResponsesTable.simulationId, params.data.id));
      const [row] = await tx
        .update(simulationsTable)
        .set({
          status: "queued",
          progress: 0,
          summary: null,
          completedAt: null,
          totalAgents: freshAgents,
          costEstimateUsd: freshEstimate,
          lockedBy: null,
          lockedAt: null,
          heartbeatAt: null,
          lastError: null,
        })
        .where(eq(simulationsTable.id, params.data.id))
        .returning();
      return row;
    });
  } catch (err) {
    if (err instanceof BudgetExceededError) {
      // 예산 수치는 화면 표시 단위(×10)로 변환해 /budget·admin API 와 일관성 유지.
      const d = err.detail;
      res.status(402).json({
        error: err.message,
        budget: {
          limitUsd: Math.round(d.limitUsd * DISPLAY_MULTIPLIER * 100) / 100,
          spentUsd: Math.round(d.spentUsd * DISPLAY_MULTIPLIER * 100) / 100,
          remainingUsd: Math.round(d.remainingUsd * DISPLAY_MULTIPLIER * 100) / 100,
          estimateUsd: Math.round(d.estimateUsd * DISPLAY_MULTIPLIER * 100) / 100,
          multiplier: DISPLAY_MULTIPLIER,
        },
      });
      return;
    }
    throw err;
  }

  res.status(202).json(ListSimulationsResponseItem.parse(jsonReady(updated)));
});

// 사용자가 진행 중(queued/running)인 시뮬레이션을 중단한다. 상태를 'pending' 으로
// 되돌리고 부분 응답을 비워 깨끗한 재실행 상태로 만든다. lease(lockedBy/At,
// heartbeatAt)도 초기화한다. costActualUsd 는 건드리지 않는다 — 이 값은 완료
// (finalize) 시에만 기록되는 "확정 실비"이므로, 완료된 시뮬레이션을 재실행(queued)
// 했다가 중단하는 경로에서 과거 실비를 지우면 누적 한도(lifetime cap)를 우회하게
// 된다(/run 의 리셋도 동일하게 costActualUsd 를 보존한다). 진행 중이 아니면 변경
// 없이 현재 상태를 반환한다(멱등).
router.post("/simulations/:id/stop", async (req, res): Promise<void> => {
  const params = RunSimulationParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const uid = tenantId(req);
  const [sim] = await db
    .select()
    .from(simulationsTable)
    .where(
      and(
        eq(simulationsTable.id, params.data.id),
        eq(simulationsTable.userId, uid),
      ),
    );
  if (!sim) {
    res.status(404).json({ error: "Simulation not found" });
    return;
  }
  if (sim.status !== "running" && sim.status !== "queued") {
    res.status(200).json(ListSimulationsResponseItem.parse(jsonReady(sim)));
    return;
  }

  const [updated] = await db.transaction(async (tx) => {
    await tx
      .delete(simulationResponsesTable)
      .where(eq(simulationResponsesTable.simulationId, params.data.id));
    return tx
      .update(simulationsTable)
      .set({
        status: "pending",
        progress: 0,
        summary: null,
        completedAt: null,
        lockedBy: null,
        lockedAt: null,
        heartbeatAt: null,
        lastError: null,
      })
      .where(eq(simulationsTable.id, params.data.id))
      .returning();
  });

  res.json(ListSimulationsResponseItem.parse(jsonReady(updated)));
});

// 클라이언트 구동(B1) 처리: 진행률 화면이 이 엔드포인트를 주기적으로 호출하면
// 시뮬레이션을 한 배치씩 전진시킨다. 항상 가동되는 워커 없이도 진행되므로
// Autoscale(유휴 시 0 축소) 배포에서 "보는 동안만" 비용이 든다. 예산 검사는 /run
// (enqueue)에서 이미 끝났으므로 여기서는 다시 하지 않는다. queued/running 만 전진.
router.post("/simulations/:id/tick", async (req, res): Promise<void> => {
  const params = RunSimulationParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const uid = tenantId(req);
  const [owned] = await db
    .select({ id: simulationsTable.id })
    .from(simulationsTable)
    .where(
      and(
        eq(simulationsTable.id, params.data.id),
        eq(simulationsTable.userId, uid),
      ),
    );
  if (!owned) {
    res.status(404).json({ error: "Simulation not found" });
    return;
  }

  await processSimulationBatch(params.data.id);

  const [sim] = await db
    .select()
    .from(simulationsTable)
    .where(eq(simulationsTable.id, params.data.id));
  res.json(ListSimulationsResponseItem.parse(jsonReady(sim)));
});

// 라이프사이클 2단계: 완료된 시뮬레이션에 실제 관측치(actualValue)를 입력한다.
// 예측값(predictionValue, 완료 시 잠금된 찬성률)과 비교해 predictionError 를 계산·저장한다.
// 본인 소유 시뮬레이션만, 완료 상태에서만 허용.
router.post("/simulations/:id/actual", async (req, res): Promise<void> => {
  const params = EnterSimulationActualParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const body = EnterSimulationActualBody.safeParse(req.body);
  if (!body.success) {
    res.status(400).json({ error: body.error.message });
    return;
  }
  const uid = tenantId(req);
  const [sim] = await db
    .select()
    .from(simulationsTable)
    .where(
      and(
        eq(simulationsTable.id, params.data.id),
        eq(simulationsTable.userId, uid),
      ),
    );
  if (!sim) {
    res.status(404).json({ error: "Simulation not found" });
    return;
  }
  if (sim.status !== "completed" || sim.predictionValue == null) {
    res
      .status(400)
      .json({ error: "완료된 시뮬레이션에만 실제값을 입력할 수 있습니다." });
    return;
  }

  const actualValue = Math.round(body.data.actualValue * 10) / 10;
  const predictionError =
    Math.round(Math.abs(sim.predictionValue - actualValue) * 10) / 10;

  const [updated] = await db
    .update(simulationsTable)
    .set({
      actualValue,
      actualMetric: body.data.actualMetric ?? null,
      actualEnteredAt: new Date(),
      predictionError,
    })
    .where(eq(simulationsTable.id, params.data.id))
    .returning();

  res.json(ListSimulationsResponseItem.parse(jsonReady(updated)));
});

// 라이프사이클 3단계(관리자): 시뮬레이션의 예측 vs 실제를 검증 이벤트(calibration)로
// 전환해 보정 루프에 환류한다. /admin 미들웨어 밖이라 isAdmin 을 직접 검사한다.
// 검증 이벤트는 시뮬레이션 소유자 스코프로 생성되어 해당 사용자의 보정 화면에 나타난다.
router.post("/simulations/:id/learn", async (req, res): Promise<void> => {
  if (!isAdmin(req)) {
    res.status(403).json({ error: "관리자만 학습을 적용할 수 있습니다." });
    return;
  }
  const params = LearnFromSimulationParams.safeParse(req.params);
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
  if (
    sim.status !== "completed" ||
    sim.predictionValue == null ||
    sim.actualValue == null
  ) {
    res
      .status(400)
      .json({ error: "예측·실제값이 모두 있어야 학습할 수 있습니다." });
    return;
  }

  // 보정 예측은 현재 보정 설정(축소 계수)을 사용해 검증 이벤트 생성과 동일 규약으로 계산한다.
  const [settings] = await db
    .select()
    .from(calibrationSettingsTable)
    .where(eq(calibrationSettingsTable.userId, sim.userId))
    .limit(1);
  const shrinkage = settings?.shrinkageFactor ?? 0.4;
  const method = settings?.method ?? "post_stratify_shrink";

  const rawPrediction = sim.predictionValue;
  const actualValue = sim.actualValue;
  const calibratedPrediction = Number(
    (rawPrediction + shrinkage * (actualValue - rawPrediction)).toFixed(1),
  );
  const rawError = Number(Math.abs(rawPrediction - actualValue).toFixed(1));
  const calibratedError = Number(
    Math.abs(calibratedPrediction - actualValue).toFixed(1),
  );
  const targetDate = (sim.actualEnteredAt ?? new Date())
    .toISOString()
    .slice(0, 10);

  const [created] = await db
    .insert(calibrationsTable)
    .values({
      userId: sim.userId,
      title: `시뮬레이션 학습 — ${sim.title}`,
      product: sim.product,
      eventType: "시뮬레이션",
      targetDate,
      metric: sim.actualMetric ?? "찬성률",
      actualValue,
      rawPrediction,
      calibratedPrediction,
      rawError,
      calibratedError,
      method,
    })
    .returning();

  const [updated] = await db
    .update(simulationsTable)
    .set({ learnedAt: new Date() })
    .where(eq(simulationsTable.id, params.data.id))
    .returning();

  res.json(
    LearnFromSimulationResponse.parse(
      jsonReady({ simulation: updated, calibrationId: created.id }),
    ),
  );
});

router.get("/simulations/:id/responses", async (req, res): Promise<void> => {
  const params = ListSimulationResponsesParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const [sim] = await db
    .select({ id: simulationsTable.id })
    .from(simulationsTable)
    .where(
      and(
        eq(simulationsTable.id, params.data.id),
        eq(simulationsTable.userId, tenantId(req)),
      ),
    );
  if (!sim) {
    res.status(404).json({ error: "Simulation not found" });
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
  const [owned] = await db
    .select({ id: simulationsTable.id })
    .from(simulationsTable)
    .where(
      and(
        eq(simulationsTable.id, params.data.id),
        eq(simulationsTable.userId, tenantId(req)),
      ),
    );
  if (!owned) {
    res.status(404).json({ error: "Simulation not found" });
    return;
  }
  await db
    .delete(simulationResponsesTable)
    .where(eq(simulationResponsesTable.simulationId, params.data.id));
  await db
    .delete(simulationsTable)
    .where(eq(simulationsTable.id, params.data.id));
  res.sendStatus(204);
});

export default router;
