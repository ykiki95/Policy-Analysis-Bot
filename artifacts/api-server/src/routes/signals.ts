import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { eq, and, asc, desc, inArray } from "drizzle-orm";
import { db, signalBatchesTable, signalSettingsTable } from "@workspace/db";
import type { SignalSettings } from "@workspace/db";
import { GLOBAL_LEARNING_USER_ID, learningReadIds } from "../lib/tenant";
import { requireAdmin } from "../lib/auth";
import {
  ListSignalsResponse,
  GetSignalParams,
  GetSignalResponse,
  CreateSignalBody,
  GetSignalSettingsResponse,
  UpdateSignalSettingsBody,
  UpdateSignalSettingsResponse,
  UpdateSignalParams,
  UpdateSignalBody,
  UpdateSignalResponse,
  DeleteSignalParams,
  AutoCollectSignalsBody,
} from "@workspace/api-zod";
import {
  mockSignalEffect,
  RESET_SCENARIOS,
} from "../lib/signalMock";
import {
  ingestNewsSignal,
  pickNewsTopics,
  defaultQueryForProduct,
  type IngestProduct,
} from "../lib/signalIngest";

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

/**
 * 전역 신호 설정 행(공용). 단일 행만 의미를 가지며 가장 낮은 id 의 행을 사용한다.
 * 없으면 기본행을 만들어 반환한다. 모든 사용자가 같은 설정을 본다(관리자만 변경).
 */
async function getGlobalSettings(): Promise<SignalSettings> {
  let [row] = await db
    .select()
    .from(signalSettingsTable)
    .orderBy(asc(signalSettingsTable.id))
    .limit(1);
  if (!row) {
    [row] = await db
      .insert(signalSettingsTable)
      .values({ userId: 0 })
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

// ── 설정(전역) ────────────────────────────────────────────────────────────
// 주의: 이 라우트는 /signals/:id 보다 먼저 등록되어야 한다("settings" 가 :id 로
// 매칭되지 않도록).
router.get("/signals/settings", async (_req, res): Promise<void> => {
  const row = await getGlobalSettings();
  res.json(GetSignalSettingsResponse.parse(jsonReady(row)));
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
    const existing = await getGlobalSettings();

    const [saved] = await db
      .update(signalSettingsTable)
      .set({
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
      })
      .where(eq(signalSettingsTable.id, existing.id))
      .returning();
    res.json(UpdateSignalSettingsResponse.parse(jsonReady(saved)));
  },
);

// ── 목록/단건(공용) ───────────────────────────────────────────────────────
router.get("/signals", async (req, res): Promise<void> => {
  // 전역(관리자 큐레이션) 신호 + 본인 개인 신호를 함께 보여준다.
  const rows = await db
    .select()
    .from(signalBatchesTable)
    .where(inArray(signalBatchesTable.userId, learningReadIds(req)))
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
        inArray(signalBatchesTable.userId, learningReadIds(req)),
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
    const settings = await getGlobalSettings();
    if (!enabledForSource(settings, d.source)) {
      res.status(400).json({ error: `비활성화된 소스(${d.source})로는 신호를 수집할 수 없습니다.` });
      return;
    }
    // 실시간 실제 수집은 'Google 뉴스 RSS' 소스만 지원한다(가짜 fallback 금지).
    if (d.source !== "뉴스") {
      res.status(400).json({
        error: `실시간 실제 수집은 현재 '뉴스'(Google 뉴스 RSS) 소스만 지원합니다. 선택: ${d.source}`,
      });
      return;
    }
    const product = d.linkedProduct as IngestProduct;
    const query =
      d.title && d.title.trim().length > 0
        ? d.title.trim()
        : defaultQueryForProduct(product);
    let effect;
    try {
      effect = await ingestNewsSignal(
        query,
        product,
        weightForSource(settings, d.source),
      );
    } catch (err) {
      req.log.warn({ err, query, product }, "signal ingest failed");
      res.status(502).json({
        error: `실시간 신호 수집 실패: ${err instanceof Error ? err.message : String(err)}`,
      });
      return;
    }
    const [created] = await db
      .insert(signalBatchesTable)
      .values({
        userId: GLOBAL_LEARNING_USER_ID,
        source: d.source,
        title:
          d.title && d.title.trim().length > 0 ? d.title.trim() : effect.title,
        collectedAt: new Date(),
        itemCount: effect.itemCount,
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

// ── 관리자: 자동 수집(한국 이슈 시나리오 풀) ───────────────────────────────
router.post(
  "/admin/signals/auto",
  requireAdmin,
  async (req, res): Promise<void> => {
    const parsed = AutoCollectSignalsBody.safeParse(req.body ?? {});
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.message });
      return;
    }
    const uid = GLOBAL_LEARNING_USER_ID;
    const settings = await getGlobalSettings();
    const count = parsed.data.count ?? 1;
    const requestedSource = parsed.data.source;

    // 실시간 실제 수집은 'Google 뉴스 RSS' 소스만 지원한다(가짜 fallback 금지).
    if (requestedSource && requestedSource !== "뉴스") {
      res.status(400).json({
        error: `실시간 실제 수집은 현재 '뉴스'(Google 뉴스 RSS) 소스만 지원합니다. 선택: ${requestedSource}`,
      });
      return;
    }
    if (!enabledForSource(settings, "뉴스")) {
      res.status(400).json({
        error: "'뉴스' 소스가 비활성화되어 있습니다. 소스 설정을 확인해 주세요.",
      });
      return;
    }

    // 수집 주제 선정: query+product 가 오면 그 단일 주제를 count 번, 아니면 기본 주제 로테이션.
    const explicitProduct = parsed.data.linkedProduct as
      | IngestProduct
      | undefined;
    const explicitQuery = parsed.data.query?.trim();
    const topics =
      explicitQuery && explicitProduct
        ? Array.from({ length: count }, () => ({
            product: explicitProduct,
            query: explicitQuery,
          }))
        : pickNewsTopics(count);

    const weight = weightForSource(settings, "뉴스");
    const now = Date.now();
    // fail-fast: 한 주제라도 수집 실패하면 DB 쓰기 없이 즉시 502(가짜·부분성공 은폐 금지).
    const rows = [];
    for (let i = 0; i < topics.length; i++) {
      const t = topics[i]!;
      let effect;
      try {
        effect = await ingestNewsSignal(t.query, t.product, weight);
      } catch (err) {
        req.log.warn({ err, topic: t }, "auto signal ingest failed");
        res.status(502).json({
          error: `실시간 신호 수집 실패(${t.query}): ${err instanceof Error ? err.message : String(err)}`,
        });
        return;
      }
      rows.push({
        userId: uid,
        source: "뉴스",
        title: effect.title,
        // 동일 시각 충돌 방지: 몇 초씩 어긋나게.
        collectedAt: new Date(now + i * 1000),
        itemCount: effect.itemCount,
        sentimentPos: effect.sentimentPos,
        sentimentNeu: effect.sentimentNeu,
        sentimentNeg: effect.sentimentNeg,
        summary: effect.summary,
        linkedProduct: t.product,
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

// ── 관리자: 시드 리셋(전체 삭제 후 재시드) ─────────────────────────────────
router.post(
  "/admin/signals/reset",
  requireAdmin,
  async (req, res): Promise<void> => {
    const uid = GLOBAL_LEARNING_USER_ID;
    const settings = await getGlobalSettings();
    await db.delete(signalBatchesTable).where(eq(signalBatchesTable.userId, uid));

    const now = Date.now();
    const dayMs = 24 * 60 * 60 * 1000;
    const n = RESET_SCENARIOS.length;
    const rows = RESET_SCENARIOS.map((c, i) => {
      const effect = mockSignalEffect(
        c.source,
        c.product,
        null,
        weightForSource(settings, c.source),
        c,
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
    const [batch] = await db
      .select()
      .from(signalBatchesTable)
      .where(
        and(
          eq(signalBatchesTable.id, params.data.id),
          eq(signalBatchesTable.userId, GLOBAL_LEARNING_USER_ID),
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
    const deleted = await db
      .delete(signalBatchesTable)
      .where(
        and(
          eq(signalBatchesTable.id, params.data.id),
          eq(signalBatchesTable.userId, GLOBAL_LEARNING_USER_ID),
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
