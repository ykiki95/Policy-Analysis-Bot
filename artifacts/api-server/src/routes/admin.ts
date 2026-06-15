import { Router, type IRouter } from "express";
import { sql } from "drizzle-orm";
import {
  db,
  agentsTable,
  dataSourcesTable,
  surveyUploadsTable,
  calibrationSettingsTable,
} from "@workspace/db";
import { jsonReady } from "../lib/serialize";
import { generateAgents } from "../lib/agentGenerator";
import {
  ListDataSourcesResponse,
  RegeneratePopulationBody,
  RegeneratePopulationResponse,
  ListSurveyUploadsResponse,
  ListSurveyUploadsResponseItem,
  CreateSurveyUploadBody,
  GetCalibrationSettingsResponse,
  UpdateCalibrationSettingsBody,
  UpdateCalibrationSettingsResponse,
} from "@workspace/api-zod";

const router: IRouter = Router();

const DEFAULT_CALIBRATION = {
  method: "베이지안 축소 (Bayesian Shrinkage)",
  benchmarkWeight: 0.6,
  recencyWeight: 0.3,
  shrinkageFactor: 0.4,
  outlierTrimPct: 5,
  description:
    "과거 가상 이벤트 벤치마크에 가중치를 두고, 최근 데이터에 더 큰 비중을 부여하여 원시 예측을 보정합니다.",
};

router.get("/admin/data-sources", async (_req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(dataSourcesTable)
    .orderBy(dataSourcesTable.id);
  res.json(ListDataSourcesResponse.parse(rows));
});

router.post(
  "/admin/population/regenerate",
  async (req, res): Promise<void> => {
    const parsed = RegeneratePopulationBody.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.message });
      return;
    }
    const { count, seed } = parsed.data;
    const agents = generateAgents(count, seed ?? undefined);

    await db.transaction(async (tx) => {
      await tx.delete(agentsTable);
      await tx.execute(
        sql`ALTER SEQUENCE agents_id_seq RESTART WITH 1`,
      );
      const chunkSize = 500;
      for (let i = 0; i < agents.length; i += chunkSize) {
        await tx.insert(agentsTable).values(agents.slice(i, i + chunkSize));
      }
    });

    req.log.info({ count }, "Population regenerated");
    res.json(RegeneratePopulationResponse.parse({ total: agents.length }));
  },
);

router.get("/admin/survey-uploads", async (_req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(surveyUploadsTable)
    .orderBy(surveyUploadsTable.id);
  res.json(ListSurveyUploadsResponse.parse(jsonReady(rows)));
});

router.post("/admin/survey-uploads", async (req, res): Promise<void> => {
  const parsed = CreateSurveyUploadBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const { fileName, description, format, rowCount, columns, sampleRows } =
    parsed.data;
  const [created] = await db
    .insert(surveyUploadsTable)
    .values({
      fileName,
      description: description ?? "",
      format,
      rowCount,
      status: "검토 대기",
      appliedToPopulation: false,
      columns,
      sampleRows,
    })
    .returning();
  res
    .status(201)
    .json(ListSurveyUploadsResponseItem.parse(jsonReady(created)));
});

router.get("/admin/calibration-settings", async (_req, res): Promise<void> => {
  let [row] = await db.select().from(calibrationSettingsTable).limit(1);
  if (!row) {
    [row] = await db
      .insert(calibrationSettingsTable)
      .values(DEFAULT_CALIBRATION)
      .returning();
  }
  res.json(GetCalibrationSettingsResponse.parse(jsonReady(row)));
});

router.put("/admin/calibration-settings", async (req, res): Promise<void> => {
  const parsed = UpdateCalibrationSettingsBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const data = parsed.data;
  const [existing] = await db
    .select()
    .from(calibrationSettingsTable)
    .limit(1);

  const values = {
    method: data.method,
    benchmarkWeight: data.benchmarkWeight,
    recencyWeight: data.recencyWeight,
    shrinkageFactor: data.shrinkageFactor,
    outlierTrimPct: data.outlierTrimPct,
    description: data.description ?? "",
    updatedAt: new Date(),
  };

  let saved;
  if (existing) {
    [saved] = await db
      .update(calibrationSettingsTable)
      .set(values)
      .where(sql`${calibrationSettingsTable.id} = ${existing.id}`)
      .returning();
  } else {
    [saved] = await db
      .insert(calibrationSettingsTable)
      .values(values)
      .returning();
  }

  res.json(UpdateCalibrationSettingsResponse.parse(jsonReady(saved)));
});

export default router;
