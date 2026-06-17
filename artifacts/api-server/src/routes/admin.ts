import { Router, type IRouter } from "express";
import { sql, eq } from "drizzle-orm";
import {
  db,
  agentsTable,
  surveysTable,
  dataSourcesTable,
  surveyUploadsTable,
  calibrationSettingsTable,
  calibrationsTable,
  demographicMarginsTable,
} from "@workspace/db";
import { openai } from "@workspace/integrations-openai-ai-server";
import { jsonReady } from "../lib/serialize";
import { generateAgents } from "../lib/agentGenerator";
import {
  buildGenerationInputs,
  loadMargins,
  NATIONAL_SCOPE,
} from "../lib/populationData";
import {
  computeSurveyAdjustments,
  ISSUE_KEYS,
  ISSUE_LABELS,
} from "../lib/surveyWeighting";
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
  ListCalibrationsResponseItem,
  CreateCalibrationBody,
  DeleteCalibrationParams,
  SuggestSurveyDriversBody,
  SuggestSurveyDriversResponse,
  GetSurveyImpactResponse,
  ListDemographicMarginsResponse,
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

router.get(
  "/admin/demographic-margins",
  async (_req, res): Promise<void> => {
    const rows = await db
      .select()
      .from(demographicMarginsTable)
      .orderBy(demographicMarginsTable.id);
    res.json(ListDemographicMarginsResponse.parse(rows));
  },
);

router.post(
  "/admin/population/regenerate",
  async (req, res): Promise<void> => {
    const parsed = RegeneratePopulationBody.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.message });
      return;
    }
    const { count, seed, regionScope } = parsed.data;
    const { inputs, scopeName } = await buildGenerationInputs(
      count,
      seed ?? undefined,
      regionScope ?? NATIONAL_SCOPE,
    );
    const agents = generateAgents(inputs);

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

    req.log.info({ count, scope: scopeName }, "Population regenerated");
    res.json(
      RegeneratePopulationResponse.parse({ total: agents.length, scope: scopeName }),
    );
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

router.post("/admin/calibrations", async (req, res): Promise<void> => {
  const parsed = CreateCalibrationBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const { title, eventType, targetDate, metric, actualValue, rawPrediction } =
    parsed.data;

  // Derive calibrated values from the current calibration settings so an
  // uploaded event reflects the active validation loop (illustrative).
  const [settings] = await db
    .select()
    .from(calibrationSettingsTable)
    .limit(1);
  const shrinkage = settings?.shrinkageFactor ?? DEFAULT_CALIBRATION.shrinkageFactor;
  const method = settings?.method ?? DEFAULT_CALIBRATION.method;

  const calibratedPrediction = Number(
    (rawPrediction + shrinkage * (actualValue - rawPrediction)).toFixed(1),
  );
  const rawError = Number(Math.abs(rawPrediction - actualValue).toFixed(1));
  const calibratedError = Number(
    Math.abs(calibratedPrediction - actualValue).toFixed(1),
  );

  const [created] = await db
    .insert(calibrationsTable)
    .values({
      title,
      eventType,
      targetDate,
      metric,
      actualValue,
      rawPrediction,
      calibratedPrediction,
      rawError,
      calibratedError,
      method,
    })
    .returning();
  res.status(201).json(ListCalibrationsResponseItem.parse(jsonReady(created)));
});

router.delete("/admin/calibrations/:id", async (req, res): Promise<void> => {
  const parsed = DeleteCalibrationParams.safeParse(req.params);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const [deleted] = await db
    .delete(calibrationsTable)
    .where(eq(calibrationsTable.id, parsed.data.id))
    .returning();
  if (!deleted) {
    res.status(404).json({ error: "Calibration not found" });
    return;
  }
  res.sendStatus(204);
});

router.post(
  "/admin/survey-uploads/suggest-drivers",
  async (req, res): Promise<void> => {
    const parsed = SuggestSurveyDriversBody.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.message });
      return;
    }
    const { fileName, description } = parsed.data;
    if (parsed.data.sampleRows.length === 0) {
      res.status(400).json({ error: "표본 행이 없습니다." });
      return;
    }

    const sampleRows = parsed.data.sampleRows.slice(0, 8).map((row) => {
      const trimmed: Record<string, string> = {};
      for (const [k, v] of Object.entries(row).slice(0, 20)) {
        trimmed[k] = String(v).slice(0, 200);
      }
      return trimmed;
    });
    const columns = parsed.data.columns?.slice(0, 20);
    const cols = columns?.length ? columns : Object.keys(sampleRows[0] ?? {});
    const prompt = [
      `다음은 업로드된 설문 데이터의 일부입니다. 이 설문이 합성 인구의 이슈별 태도에 어떤 영향을 주는지 "태도 동인(driver)" 목록으로 요약하세요.`,
      fileName ? `파일명: ${fileName}` : "",
      description ? `설명: ${description}` : "",
      `컬럼: ${cols.join(", ")}`,
      `표본 행(JSON): ${JSON.stringify(sampleRows.slice(0, 8))}`,
      ``,
      `규칙:`,
      `- issue 값은 반드시 다음 중 하나의 한국어 단어만 사용: 경제, 복지, 안보, 환경, 주거`,
      `- factor 는 설문에서 그 이슈를 설명하는 인구통계/태도 요인(예: 연령, 소득, 자치구, 정치성향, 학력, 주거형태)`,
      `- weight 는 0~1 사이 실수(영향의 강도)`,
      `- direction 은 영향의 방향을 설명하는 한국어 한 줄(예: "고령일수록 복지 확대 지지")`,
      `- 표본에서 근거를 찾을 수 있는 동인만 최대 5개까지 제안`,
      `- summary 는 이 설문이 인구 태도에 주는 영향을 1~2문장 한국어로 요약`,
      ``,
      `반드시 아래 JSON 형식 하나만 출력:`,
      `{"summary":"...","drivers":[{"factor":"...","issue":"경제|복지|안보|환경|주거","weight":0.0,"direction":"..."}]}`,
    ]
      .filter(Boolean)
      .join("\n");

    try {
      const response = await openai.chat.completions.create({
        model: "gpt-5-mini",
        max_completion_tokens: 4000,
        messages: [
          {
            role: "system",
            content:
              "당신은 설문 데이터를 합성 인구 태도 모델의 동인으로 매핑하는 분석가입니다. 반드시 유효한 JSON 객체 하나만 출력하세요. 이 결과는 사람이 검토 후 확정하는 초안입니다.",
          },
          { role: "user", content: prompt },
        ],
        response_format: { type: "json_object" },
      });

      const content = response.choices[0]?.message?.content ?? "{}";
      let raw: { summary?: unknown; drivers?: unknown } = {};
      try {
        raw = JSON.parse(content);
      } catch {
        raw = {};
      }

      const validIssues = new Set(["경제", "복지", "안보", "환경", "주거"]);
      const drivers = Array.isArray(raw.drivers)
        ? raw.drivers
            .map((d: Record<string, unknown>) => ({
              factor: String(d?.factor ?? "").trim() || "요인",
              issue: String(d?.issue ?? "").trim(),
              weight: Math.max(
                0,
                Math.min(1, Number(d?.weight) || 0),
              ),
              direction: String(d?.direction ?? "").trim() || "—",
            }))
            .filter((d) => validIssues.has(d.issue))
            .slice(0, 5)
        : [];

      const summary =
        typeof raw.summary === "string" && raw.summary.trim().length > 0
          ? raw.summary.trim()
          : "이 설문에서 도출된 태도 동인 초안입니다. 검토 후 확정하세요.";

      req.log.info({ fileName, count: drivers.length }, "Suggested survey drivers");
      res.json(SuggestSurveyDriversResponse.parse({ summary, drivers }));
    } catch (err) {
      req.log.error({ err }, "suggest-drivers failed");
      res.status(502).json({ error: "자동 매핑 제안에 실패했습니다. 잠시 후 다시 시도해 주세요." });
    }
  },
);

router.get("/admin/survey-impact", async (_req, res): Promise<void> => {
  const surveys = await db.select().from(surveysTable);
  const adjustments = computeSurveyAdjustments(surveys);
  const appliedSurveyCount = surveys.filter(
    (s) => s.appliedToPopulation,
  ).length;
  const items = ISSUE_KEYS.map((key) => ({
    issue: ISSUE_LABELS[key],
    key,
    weightSum: adjustments[key].weightSum,
    multiplier: adjustments[key].multiplier,
    noiseScale: adjustments[key].noiseScale,
    driverCount: adjustments[key].driverCount,
    targetMean: adjustments[key].targetMean,
    targetPull: adjustments[key].targetPull,
  }));
  res.json(GetSurveyImpactResponse.parse({ appliedSurveyCount, items }));
});

export default router;
