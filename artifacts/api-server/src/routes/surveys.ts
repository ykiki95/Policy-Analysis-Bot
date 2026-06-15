import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { eq } from "drizzle-orm";
import { db, surveysTable } from "@workspace/db";
import {
  ListSurveysResponse,
  GetSurveyParams,
  GetSurveyResponse,
} from "@workspace/api-zod";

const router: IRouter = Router();

router.get("/surveys", async (_req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(surveysTable)
    .orderBy(surveysTable.id);
  res.json(ListSurveysResponse.parse(jsonReady(rows)));
});

router.get("/surveys/:id", async (req, res): Promise<void> => {
  const params = GetSurveyParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const [survey] = await db
    .select()
    .from(surveysTable)
    .where(eq(surveysTable.id, params.data.id));
  if (!survey) {
    res.status(404).json({ error: "Survey not found" });
    return;
  }
  res.json(GetSurveyResponse.parse(jsonReady(survey)));
});

export default router;
