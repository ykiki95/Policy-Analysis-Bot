import { Router, type IRouter } from "express";
import { db, calibrationsTable, electionsTable } from "@workspace/db";
import {
  ListCalibrationsResponse,
  ListElectionsResponse,
  GetElectionCalibrationResponse,
} from "@workspace/api-zod";
import { computeElectionCalibration } from "../lib/electionCalibration";

const router: IRouter = Router();

router.get("/calibration", async (_req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(calibrationsTable)
    .orderBy(calibrationsTable.id);
  res.json(ListCalibrationsResponse.parse(rows));
});

router.get("/calibration/elections", async (_req, res): Promise<void> => {
  const result = await computeElectionCalibration();
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
