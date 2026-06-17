import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { eq } from "drizzle-orm";
import { db, surveysTable } from "@workspace/db";
import {
  ListSurveysResponse,
  GetSurveyParams,
  GetSurveyResponse,
  CreateSurveyBody,
  DeleteSurveyParams,
  SetSurveyAppliedParams,
  SetSurveyAppliedBody,
  SetSurveyAppliedResponse,
} from "@workspace/api-zod";

const router: IRouter = Router();

router.get("/surveys", async (_req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(surveysTable)
    .orderBy(surveysTable.id);
  res.json(ListSurveysResponse.parse(jsonReady(rows)));
});

router.post("/surveys", async (req, res): Promise<void> => {
  const parsed = CreateSurveyBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const d = parsed.data;
  const [created] = await db
    .insert(surveysTable)
    .values({
      title: d.title,
      description: d.description ?? "",
      methodology: d.methodology ?? "직접 입력",
      sampleSize: d.sampleSize ?? 0,
      fieldedDate: d.fieldedDate ?? new Date().toISOString().slice(0, 10),
      status: "active",
      reliability: d.reliability ?? 0,
      drivers: d.drivers,
      appliedToPopulation: d.appliedToPopulation ?? false,
      domain: d.domain ?? "political",
      isReal: d.isReal ?? false,
      sourceAgency: d.sourceAgency ?? null,
      sourceTitle: d.sourceTitle ?? null,
      fieldPeriod: d.fieldPeriod ?? null,
      sourceUrl: d.sourceUrl ?? null,
    })
    .returning();
  res.status(201).json(GetSurveyResponse.parse(jsonReady(created)));
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

router.delete("/surveys/:id", async (req, res): Promise<void> => {
  const params = DeleteSurveyParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const [deleted] = await db
    .delete(surveysTable)
    .where(eq(surveysTable.id, params.data.id))
    .returning();
  if (!deleted) {
    res.status(404).json({ error: "Survey not found" });
    return;
  }
  res.sendStatus(204);
});

router.patch("/surveys/:id/applied", async (req, res): Promise<void> => {
  const params = SetSurveyAppliedParams.safeParse(req.params);
  if (!params.success) {
    res.status(400).json({ error: params.error.message });
    return;
  }
  const body = SetSurveyAppliedBody.safeParse(req.body);
  if (!body.success) {
    res.status(400).json({ error: body.error.message });
    return;
  }
  const [updated] = await db
    .update(surveysTable)
    .set({ appliedToPopulation: body.data.appliedToPopulation })
    .where(eq(surveysTable.id, params.data.id))
    .returning();
  if (!updated) {
    res.status(404).json({ error: "Survey not found" });
    return;
  }
  res.json(SetSurveyAppliedResponse.parse(jsonReady(updated)));
});

export default router;
