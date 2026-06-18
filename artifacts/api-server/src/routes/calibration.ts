import { Router, type IRouter } from "express";
import { eq } from "drizzle-orm";
import { db, calibrationsTable, electionsTable } from "@workspace/db";
import { tenantId } from "../lib/tenant";
import {
  ListCalibrationsResponse,
  ListElectionsResponse,
  GetElectionCalibrationResponse,
} from "@workspace/api-zod";
import { computeElectionCalibration } from "../lib/electionCalibration";

const router: IRouter = Router();

router.get("/calibration", async (req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(calibrationsTable)
    .where(eq(calibrationsTable.userId, tenantId(req)))
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
