import { Router, type IRouter } from "express";
import { inArray } from "drizzle-orm";
import { db, calibrationsTable, electionsTable } from "@workspace/db";
import { tenantId, learningReadIds } from "../lib/tenant";
import {
  ListCalibrationsResponse,
  ListElectionsResponse,
  GetElectionCalibrationResponse,
} from "@workspace/api-zod";
import { computeElectionCalibration } from "../lib/electionCalibration";

const router: IRouter = Router();

router.get("/calibration", async (req, res): Promise<void> => {
  // 전역 학습(관리자 큐레이션) + 본인 개인 검증을 함께 보여준다.
  const rows = await db
    .select()
    .from(calibrationsTable)
    .where(inArray(calibrationsTable.userId, learningReadIds(req)))
    .orderBy(calibrationsTable.id);
  res.json(ListCalibrationsResponse.parse(rows));
});

router.get("/calibration/elections", async (req, res): Promise<void> => {
  const result = await computeElectionCalibration(tenantId(req));
  res.json(GetElectionCalibrationResponse.parse(result));
});

router.get("/elections", async (_req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(electionsTable)
    .orderBy(electionsTable.id);
  res.json(ListElectionsResponse.parse(rows));
});

export default router;
