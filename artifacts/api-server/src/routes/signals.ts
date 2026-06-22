import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { eq, and, desc } from "drizzle-orm";
import { db, signalBatchesTable, signalSettingsTable } from "@workspace/db";
import type { SignalSettings } from "@workspace/db";
import { tenantId } from "../lib/tenant";
import { requireAdmin } from "../lib/auth";
import {
  ListSignalsResponse,
  GetSignalParams,
  GetSignalResponse,
  CreateSignalBody,
  GetSignalSettingsResponse,
  UpdateSignalSettingsBody,
  UpdateSignalSettingsResponse,
  UpdateUserSignalSettingsBody,
  UpdateUserSignalSettingsResponse,
  UpdateSignalParams,
  UpdateSignalBody,
  UpdateSignalResponse,
  DeleteSignalParams,
  AutoCollectSignalsBody,
} from "@workspace/api-zod";
import {
  mockSignalEffect,
  type SignalSource,
  type SignalProduct,
} from "../lib/signalMock";

const router: IRouter = Router();

function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v));
}

/** 소스별 가중치(0~2)를 설정에서 조회. */
function weightForSource(s: SignalSettings, source: string): number {
  if (source === "뉴스") return s.sourceNewsWeight;
  if (source === "검색트렌드") return s.sourceTrendWeight;
  return s.sourceSnsWeight;
}

function enabledForSource(s: SignalSettings, source: string): boolean {
  if (source === "뉴스") return s.sourceNewsEnabled;
  if (source === "검색트렌드") return s.sourceTrendEnabled;
  return s.sourceSnsEnabled;
}

/** 테넌트 설정 행을 조회하거나 없으면 기본행을 만들어 반환. */
async function getOrCreateSettings(uid: number): Promise<SignalSettings> {
  let [row] = await db
    .select()
    .from(signalSettingsTable)
    .where(eq(signalSettingsTable.userId, uid))
    .limit(1);
  if (!row) {
    [row] = await db
      .insert(signalSettingsTable)
      .values({ userId: uid })
      .returning();
  }
  return row;
}

/** 감성 3값을 합 100 으로 재정규화. */
function renormSentiment(
  pos: number,
  neu: number,
  neg: number,
): { pos: number; neu: number; neg: number } {
  const p = Math.max(0, pos);
  const u = Math.max(0, neu);
  const g = Math.max(0, neg);
  const sum = p + u + g || 1;
  const rp = Math.round((p / sum) * 100);
  const rg = Math.round((g / sum) * 100);
  const ru = Math.max(0, 100 - rp - rg);
  return { pos: rp, neu: ru, neg: rg };
}

// ── 설정 ────────────────────────────────────────────────────────────────
// 주의: 이 라우트는 /signals/:id 보다 먼저 등록되어야 한다("settings" 가 :id 로
// 매칭되지 않도록).
router.get("/signals/settings", async (req, res): Promise<void> => {
  const row = await getOrCreateSettings(tenantId(req));
  res.json(GetSignalSettingsResponse.parse(jsonReady(row)));
});

// 사용자 본인 설정: 신호 반영 여부만 변경 가능(수집 구성은 관리자 전용).
router.put("/signals/settings", async (req, res): Promise<void> => {
  const parsed = UpdateUserSignalSettingsBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const uid = tenantId(req);
  const existing = await getOrCreateSettings(uid);
  const [saved] = await db
    .update(signalSettingsTable)
    .set({ applyToPrediction: parsed.data.applyToPrediction, updatedAt: new Date() })
    .where(eq(signalSettingsTable.id, existing.id))
    .returning();
  res.json(UpdateUserSignalSettingsResponse.parse(jsonReady(saved)));
});

router.put(
  "/admin/signals/settings",
  requireAdmin,
  async (req, res): Promise<void> => {
    const parsed = UpdateSignalSettingsBody.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.message });
      return;
    }
    const d = parsed.data;
    const uid = tenantId(req);
    const [existing] = await db
      .select()
      .from(signalSettingsTable)
      .where(eq(signalSettingsTable.userId, uid))
      .limit(1);

    const values = {
      sourceNewsEnabled: d.sourceNewsEnabled,
      sourceTrendEnabled: d.sourceTrendEnabled,
      sourceSnsEnabled: d.sourceSnsEnabled,
      sourceNewsWeight: clamp(d.sourceNewsWeight, 0, 2),
      sourceTrendWeight: clamp(d.sourceTrendWeight, 0, 2),
      sourceSnsWeight: clamp(d.sourceSnsWeight, 0, 2),
      applyToPrediction: d.applyToPrediction,
      scheduleEnabled: d.scheduleEnabled,
      scheduleInterval: d.scheduleInterval,
      filterBotRemoval: d.filterBotRemoval,
      filterDedup: d.filterDedup,
      filterMinItems: Math.max(0, Math.round(d.filterMinItems)),
      updatedAt: new Date(),
    };

    let saved;
    if (existing) {
      [saved] = await db
        .update(signalSettingsTable)
        .set(values)
        .where(eq(signalSettingsTable.id, existing.id))
        .returning();
    } else {
      [saved] = await db
        .insert(signalSettingsTable)
        .values({ ...values, userId: uid })
        .returning();
    }
    res.json(UpdateSignalSettingsResponse.parse(jsonReady(saved)));
  },
);

// ── 목록/단건 ─────────────────────────────────────────────────────────────
router.get("/signals", async (req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(signalBatchesTable)
    .where(eq(signalBatchesTable.userId, tenantId(req)))
    .orderBy(desc(signalBatchesTable.collectedAt));
  res.json(ListSignalsResponse.parse(jsonReady(rows)));
});

router.get("/signals/:id", async (req, res): Promise<void> => {
  const params = GetSignalParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const [batch] = await db
    .select()
    .from(signalBatchesTable)
    .where(
      and(
        eq(signalBatchesTable.id, params.data.id),
        eq(signalBatchesTable.userId, tenantId(req)),
      ),
    );
  if (!batch) {
    res.status(404).json({ error: "Signal batch not found" });
    return;
  }
  res.json(GetSignalResponse.parse(jsonReady(batch)));
});

// ── 관리자: 수동 배치 생성 ─────────────────────────────────────────────────
// 효과 수치는 결정론적 목업. 이 배치는 simulations 행 수치를 변경하지 않는다.
router.post(
  "/admin/signals",
  requireAdmin,
  async (req, res): Promise<void> => {
    const parsed = CreateSignalBody.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.message });
      return;
    }
    const d = parsed.data;
    const settings = await getOrCreateSettings(tenantId(req));
    if (!enabledForSource(settings, d.source)) {
      res.status(400).json({ error: `비활성화된 소스(${d.source})로는 신호를 수집할 수 없습니다.` });
      return;
    }
    const effect = mockSignalEffect(
      d.source as SignalSource,
      d.linkedProduct as SignalProduct,
      d.title ?? null,
      weightForSource(settings, d.source),
    );
    const [created] = await db
      .insert(signalBatchesTable)
      .values({
        userId: tenantId(req),
        source: d.source,
        title:
          d.title && d.title.trim().length > 0 ? d.title.trim() : effect.title,
        collectedAt: new Date(),
        itemCount: d.itemCount ?? effect.itemCount,
        sentimentPos: effect.sentimentPos,
        sentimentNeu: effect.sentimentNeu,
        sentimentNeg: effect.sentimentNeg,
        summary: effect.summary,
        linkedProduct: d.linkedProduct,
        linkedSimulationId: d.linkedSimulationId ?? null,
        metric: effect.metric,
        valueBefore: effect.valueBefore,
        valueAfter: effect.valueAfter,
        status: "완료",
      })
      .returning();
    res.status(201).json(GetSignalResponse.parse(jsonReady(created)));
  },
);

// ── 관리자: 자동 수집(하드코딩 샘플 풀) ─────────────────────────────────────
const AUTO_POOL: { source: SignalSource; product: SignalProduct; title: string }[] = [
  { source: "뉴스", product: "Dynamo", title: "여야 지지율 격차 보도 확산" },
  { source: "뉴스", product: "Lumen", title: "신제품 출시 주요 매체 일제 보도" },
  { source: "뉴스", product: "Seraph", title: "복지 정책 개편안 언론 집중 조명" },
  { source: "검색트렌드", product: "Dynamo", title: "후보 이름 검색량 주간 급상승" },
  { source: "검색트렌드", product: "Lumen", title: "브랜드 연관 검색어 상위권 진입" },
  { source: "검색트렌드", product: "Seraph", title: "정책 키워드 검색 관심도 확대" },
  { source: "SNS·커뮤니티", product: "Dynamo", title: "커뮤니티 정치 여론 확산세 포착" },
  { source: "SNS·커뮤니티", product: "Lumen", title: "SNS 제품 언급량 급증" },
  { source: "SNS·커뮤니티", product: "Seraph", title: "온라인 정책 반응 양극화 심화" },
];

router.post(
  "/admin/signals/auto",
  requireAdmin,
  async (req, res): Promise<void> => {
    const parsed = AutoCollectSignalsBody.safeParse(req.body ?? {});
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.message });
      return;
    }
    const uid = tenantId(req);
    const settings = await getOrCreateSettings(uid);
    const count = parsed.data.count ?? 1;
    const requestedSource = parsed.data.source as SignalSource | undefined;

    // 활성 소스만 후보로. 특정 소스 요청 시 해당 소스로 한정.
    let pool = AUTO_POOL.filter((p) => enabledForSource(settings, p.source));
    if (requestedSource) pool = pool.filter((p) => p.source === requestedSource);
    if (pool.length === 0) {
      res.status(400).json({
        error: "선택 가능한 활성 소스가 없습니다. 소스 설정을 확인해 주세요.",
      });
      return;
    }

    const now = Date.now();
    const offset = Math.floor(Math.random() * pool.length);
    const rows = [];
    for (let i = 0; i < count; i++) {
      const pick = pool[(offset + i) % pool.length];
      const effect = mockSignalEffect(
        pick.source,
        pick.product,
        pick.title,
        weightForSource(settings, pick.source),
      );
      rows.push({
        userId: uid,
        source: pick.source,
        title: effect.title,
        // 동일 시각 충돌 방지: 몇 초씩 어긋나게.
        collectedAt: new Date(now + i * 1000),
        itemCount: effect.itemCount,
        sentimentPos: effect.sentimentPos,
        sentimentNeu: effect.sentimentNeu,
        sentimentNeg: effect.sentimentNeg,
        summary: effect.summary,
        linkedProduct: pick.product,
        linkedSimulationId: null,
        metric: effect.metric,
        valueBefore: effect.valueBefore,
        valueAfter: effect.valueAfter,
        status: "완료",
      });
    }
    const created = await db
      .insert(signalBatchesTable)
      .values(rows)
      .returning();
    created.sort(
      (a, b) => b.collectedAt.getTime() - a.collectedAt.getTime(),
    );
    res.status(201).json(ListSignalsResponse.parse(jsonReady(created)));
  },
);

// ── 관리자: 시드 리셋 ──────────────────────────────────────────────────────
const RESET_COMBOS: { source: SignalSource; product: SignalProduct }[] = [
  { source: "뉴스", product: "Dynamo" },
  { source: "검색트렌드", product: "Lumen" },
  { source: "SNS·커뮤니티", product: "Seraph" },
  { source: "뉴스", product: "Lumen" },
  { source: "검색트렌드", product: "Dynamo" },
  { source: "SNS·커뮤니티", product: "Dynamo" },
  { source: "뉴스", product: "Seraph" },
];

router.post(
  "/admin/signals/reset",
  requireAdmin,
  async (req, res): Promise<void> => {
    const uid = tenantId(req);
    const settings = await getOrCreateSettings(uid);
    await db
      .delete(signalBatchesTable)
      .where(eq(signalBatchesTable.userId, uid));

    const now = Date.now();
    const dayMs = 24 * 60 * 60 * 1000;
    const n = RESET_COMBOS.length;
    const rows = RESET_COMBOS.map((c, i) => {
      const effect = mockSignalEffect(
        c.source,
        c.product,
        null,
        weightForSource(settings, c.source),
      );
      // 최근 ~18일에 걸쳐 시간순 분포(오래된 것 → 최신).
      const collectedAt = new Date(now - (n - 1 - i) * 2.6 * dayMs);
      return {
        userId: uid,
        source: c.source,
        title: effect.title,
        collectedAt,
        itemCount: effect.itemCount,
        sentimentPos: effect.sentimentPos,
        sentimentNeu: effect.sentimentNeu,
        sentimentNeg: effect.sentimentNeg,
        summary: effect.summary,
        linkedProduct: c.product,
        linkedSimulationId: null,
        metric: effect.metric,
        valueBefore: effect.valueBefore,
        valueAfter: effect.valueAfter,
        status: "완료",
      };
    });
    const created = await db
      .insert(signalBatchesTable)
      .values(rows)
      .returning();
    created.sort(
      (a, b) => b.collectedAt.getTime() - a.collectedAt.getTime(),
    );
    res.status(201).json(ListSignalsResponse.parse(jsonReady(created)));
  },
);

// ── 관리자: 배치 수정 ──────────────────────────────────────────────────────
router.patch(
  "/admin/signals/:id",
  requireAdmin,
  async (req, res): Promise<void> => {
    const params = UpdateSignalParams.safeParse(req.params);
    if (!params.success) {
      res.status(400).json({ error: params.error.message });
      return;
    }
    const parsed = UpdateSignalBody.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.message });
      return;
    }
    const uid = tenantId(req);
    const [batch] = await db
      .select()
      .from(signalBatchesTable)
      .where(
        and(
          eq(signalBatchesTable.id, params.data.id),
          eq(signalBatchesTable.userId, uid),
        ),
      );
    if (!batch) {
      res.status(404).json({ error: "Signal batch not found" });
      return;
    }
    const d = parsed.data;

    const valueBefore = d.valueBefore ?? batch.valueBefore;
    let valueAfter: number;
    if (d.direction && d.magnitude != null) {
      const dir = d.direction === "up" ? 1 : -1;
      valueAfter = clamp(
        Math.round((valueBefore + dir * d.magnitude) * 10) / 10,
        0,
        100,
      );
    } else if (d.valueAfter != null) {
      valueAfter = clamp(d.valueAfter, 0, 100);
    } else {
      valueAfter = batch.valueAfter;
    }

    const sent = renormSentiment(
      d.sentimentPos ?? batch.sentimentPos,
      d.sentimentNeu ?? batch.sentimentNeu,
      d.sentimentNeg ?? batch.sentimentNeg,
    );

    const [updated] = await db
      .update(signalBatchesTable)
      .set({
        source: d.source ?? batch.source,
        title:
          d.title && d.title.trim().length > 0 ? d.title.trim() : batch.title,
        linkedProduct: d.linkedProduct ?? batch.linkedProduct,
        linkedSimulationId:
          d.linkedSimulationId !== undefined
            ? d.linkedSimulationId
            : batch.linkedSimulationId,
        collectedAt: d.collectedAt ? new Date(d.collectedAt) : batch.collectedAt,
        sentimentPos: sent.pos,
        sentimentNeu: sent.neu,
        sentimentNeg: sent.neg,
        valueBefore,
        valueAfter,
      })
      .where(eq(signalBatchesTable.id, batch.id))
      .returning();
    res.json(UpdateSignalResponse.parse(jsonReady(updated)));
  },
);

// ── 관리자: 배치 삭제 ──────────────────────────────────────────────────────
router.delete(
  "/admin/signals/:id",
  requireAdmin,
  async (req, res): Promise<void> => {
    const params = DeleteSignalParams.safeParse(req.params);
    if (!params.success) {
      res.status(400).json({ error: params.error.message });
      return;
    }
    const uid = tenantId(req);
    const deleted = await db
      .delete(signalBatchesTable)
      .where(
        and(
          eq(signalBatchesTable.id, params.data.id),
          eq(signalBatchesTable.userId, uid),
        ),
      )
      .returning();
    if (deleted.length === 0) {
      res.status(404).json({ error: "Signal batch not found" });
      return;
    }
    res.status(204).end();
  },
);

export default router;
