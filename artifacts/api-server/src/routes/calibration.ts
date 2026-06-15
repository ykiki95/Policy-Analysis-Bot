import { Router, type IRouter } from "express";
import { db, calibrationsTable } from "@workspace/db";
import { ListCalibrationsResponse } from "@workspace/api-zod";

const router: IRouter = Router();

router.get("/calibration", async (_req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(calibrationsTable)
    .orderBy(calibrationsTable.id);
  res.json(ListCalibrationsResponse.parse(rows));
});

export default router;
