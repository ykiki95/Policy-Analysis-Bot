import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { eq, and, desc } from "drizzle-orm";
import { db, signalBatchesTable } from "@workspace/db";
import { tenantId } from "../lib/tenant";
import { requireAdmin } from "../lib/auth";
import {
  ListSignalsResponse,
  GetSignalParams,
  GetSignalResponse,
  CreateSignalBody,
} from "@workspace/api-zod";
import {
  mockSignalEffect,
  type SignalSource,
  type SignalProduct,
} from "../lib/signalMock";

const router: IRouter = Router();

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

// 관리자 전용: 새 배치 생성. 효과 수치는 결정론적 목업(실제 수집/계산 없음).
// 이 배치는 simulations 행의 수치를 절대 변경하지 않는다.
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
    const effect = mockSignalEffect(
      d.source as SignalSource,
      d.linkedProduct as SignalProduct,
      d.title ?? null,
    );
    const [created] = await db
      .insert(signalBatchesTable)
      .values({
        userId: tenantId(req),
        source: d.source,
        title: d.title && d.title.trim().length > 0 ? d.title.trim() : effect.title,
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

export default router;
