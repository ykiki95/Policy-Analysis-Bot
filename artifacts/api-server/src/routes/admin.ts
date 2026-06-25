import { Router, type IRouter } from "express";
import { sql, eq, and } from "drizzle-orm";
import {
  db,
  agentsTable,
  surveysTable,
  dataSourcesTable,
  surveyUploadsTable,
  calibrationSettingsTable,
  calibrationsTable,
  demographicMarginsTable,
  electionsTable,
  regionsTable,
  usersTable,
} from "@workspace/db";
import { openai } from "@workspace/integrations-openai-ai-server";
import { jsonReady } from "../lib/serialize";
import { GLOBAL_LEARNING_USER_ID } from "../lib/tenant";
import { requireAdmin, hashPassword } from "../lib/auth";
import { HEARTBEAT_SECONDS } from "../lib/analytics";
import { ensureGeoForIps } from "../lib/geoLookup";
import { getSpend } from "../lib/budget";
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
  ListElectionSourcesResponse,
  ImportElectionBody,
  ImportElectionResponse,
  ListElectionBacktestsResponse,
  CreateManualElectionBody,
  CreateManualElectionResponse,
  DeleteElectionBacktestParams,
  DeleteElectionBacktestResponse,
  ListAdminAccountsResponse,
  UpdateAccountBudgetParams,
  UpdateAccountBudgetBody,
  UpdateAccountBudgetResponse,
  ResetAccountPasswordParams,
  GetAnalyticsQueryParams,
  GetAnalyticsResponse,
} from "@workspace/api-zod";
import {
  SUPPORTED_ELECTIONS,
  findElectionSource,
  fetchConservativeShares,
  DataGoKrError,
} from "../lib/dataGoKr";

const router: IRouter = Router();

const DEFAULT_CALIBRATION = {
  method: "베이지안 축소 (Bayesian Shrinkage)",
  benchmarkWeight: 0.6,
  recencyWeight: 0.3,
  shrinkageFactor: 0.4,
  outlierTrimPct: 5,
  applyToPopulation: false,
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

// 전체 계정 목록 + 예산/지출(모두 실비 USD; 화면 표시 배수는 프런트가 적용). admin 전용.
router.get("/admin/accounts", requireAdmin, async (_req, res): Promise<void> => {
  const users = await db.select().from(usersTable).orderBy(usersTable.id);
  const accounts = await Promise.all(
    users.map(async (u) => {
      const spent = await getSpend(u.id);
      const remaining = Math.max(0, u.budgetLimitUsd - spent);
      return {
        id: u.id,
        username: u.username,
        name: u.name,
        role: u.role,
        createdAt: u.createdAt,
        budgetLimitUsd: u.budgetLimitUsd,
        spentUsd: Math.round(spent * 10000) / 10000,
        remainingUsd: Math.round(remaining * 10000) / 10000,
      };
    }),
  );
  res.json(ListAdminAccountsResponse.parse(jsonReady(accounts)));
});

// 계정별 예산 한도 설정(입력·응답 모두 실비 USD; 화면 표시 배수는 프런트가 적용). admin 전용.
router.put("/admin/accounts/:id/budget", requireAdmin, async (req, res): Promise<void> => {
  const params = UpdateAccountBudgetParams.safeParse(req.params);
  const body = UpdateAccountBudgetBody.safeParse(req.body);
  if (!params.success || !body.success) {
    res
      .status(400)
      .json({ error: (params.error ?? body.error)?.message ?? "Invalid input" });
    return;
  }
  const [updated] = await db
    .update(usersTable)
    .set({ budgetLimitUsd: body.data.budgetLimitUsd })
    .where(eq(usersTable.id, params.data.id))
    .returning();
  if (!updated) {
    res.status(404).json({ error: "계정을 찾을 수 없습니다." });
    return;
  }
  const spent = await getSpend(updated.id);
  const remaining = Math.max(0, updated.budgetLimitUsd - spent);
  res.json(
    UpdateAccountBudgetResponse.parse(
      jsonReady({
        id: updated.id,
        username: updated.username,
        name: updated.name,
        avatar: updated.avatar,
        role: updated.role,
        createdAt: updated.createdAt,
        budgetLimitUsd: updated.budgetLimitUsd,
        spentUsd: Math.round(spent * 10000) / 10000,
        remainingUsd: Math.round(remaining * 10000) / 10000,
      }),
    ),
  );
});

// 회원 비밀번호 초기화 — "1111" 로 재설정. admin 전용.
router.post(
  "/admin/accounts/:id/reset-password",
  requireAdmin,
  async (req, res): Promise<void> => {
    const params = ResetAccountPasswordParams.safeParse(req.params);
    if (!params.success) {
      res.status(400).json({ error: "잘못된 요청입니다." });
      return;
    }
    const passwordHash = await hashPassword("1111");
    const [updated] = await db
      .update(usersTable)
      .set({ passwordHash })
      .where(eq(usersTable.id, params.data.id))
      .returning();
    if (!updated) {
      res.status(404).json({ error: "계정을 찾을 수 없습니다." });
      return;
    }
    req.log.info({ targetUserId: updated.id }, "Admin reset account password");
    res.json({ ok: true });
  },
);

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
  requireAdmin,
  async (req, res): Promise<void> => {
    const parsed = RegeneratePopulationBody.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.message });
      return;
    }
    const { count, seed, regionScope } = parsed.data;
    // 합성 학습 인구는 전 계정 공유. 관리자가 ?accountId 로 무엇을 보고 있든
    // 인구는 항상 전역(0) 소유로 교체한다.
    const uid = GLOBAL_LEARNING_USER_ID;
    const { inputs, scopeName } = await buildGenerationInputs(
      count,
      seed ?? undefined,
      regionScope ?? NATIONAL_SCOPE,
      uid,
    );
    const agents = generateAgents(inputs);

    // 해당 계정(테넌트)의 인구만 교체한다. agents id 공간은 모든 계정이 공유하므로
    // 전역 시퀀스는 리셋하지 않는다(과거 시뮬레이션 집계는 응답 스냅샷 기반이라 무관).
    await db.transaction(async (tx) => {
      await tx.delete(agentsTable).where(eq(agentsTable.userId, uid));
      const chunkSize = 500;
      for (let i = 0; i < agents.length; i += chunkSize) {
        await tx.insert(agentsTable).values(agents.slice(i, i + chunkSize));
      }
    });

    req.log.info({ count, scope: scopeName, userId: uid }, "Population regenerated");
    res.json(
      RegeneratePopulationResponse.parse({ total: agents.length, scope: scopeName }),
    );
  },
);

router.get("/admin/survey-uploads", async (req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(surveyUploadsTable)
    .where(eq(surveyUploadsTable.userId, GLOBAL_LEARNING_USER_ID))
    .orderBy(surveyUploadsTable.id);
  res.json(ListSurveyUploadsResponse.parse(jsonReady(rows)));
});

router.post("/admin/survey-uploads", requireAdmin, async (req, res): Promise<void> => {
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
      userId: GLOBAL_LEARNING_USER_ID,
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

router.get("/admin/calibration-settings", async (req, res): Promise<void> => {
  const uid = GLOBAL_LEARNING_USER_ID;
  let [row] = await db
    .select()
    .from(calibrationSettingsTable)
    .where(eq(calibrationSettingsTable.userId, uid))
    .limit(1);
  if (!row) {
    [row] = await db
      .insert(calibrationSettingsTable)
      .values({ ...DEFAULT_CALIBRATION, userId: uid })
      .returning();
  }
  res.json(GetCalibrationSettingsResponse.parse(jsonReady(row)));
});

router.put("/admin/calibration-settings", requireAdmin, async (req, res): Promise<void> => {
  const parsed = UpdateCalibrationSettingsBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const data = parsed.data;
  const uid = GLOBAL_LEARNING_USER_ID;
  const [existing] = await db
    .select()
    .from(calibrationSettingsTable)
    .where(eq(calibrationSettingsTable.userId, uid))
    .limit(1);

  const values = {
    method: data.method,
    benchmarkWeight: data.benchmarkWeight,
    recencyWeight: data.recencyWeight,
    shrinkageFactor: data.shrinkageFactor,
    outlierTrimPct: data.outlierTrimPct,
    applyToPopulation:
      data.applyToPopulation ?? existing?.applyToPopulation ?? false,
    description: data.description ?? "",
    updatedAt: new Date(),
  };

  let saved;
  if (existing) {
    [saved] = await db
      .update(calibrationSettingsTable)
      .set(values)
      .where(eq(calibrationSettingsTable.id, existing.id))
      .returning();
  } else {
    [saved] = await db
      .insert(calibrationSettingsTable)
      .values({ ...values, userId: uid })
      .returning();
  }

  res.json(UpdateCalibrationSettingsResponse.parse(jsonReady(saved)));
});

router.post("/admin/calibrations", requireAdmin, async (req, res): Promise<void> => {
  const parsed = CreateCalibrationBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const { title, product, eventType, targetDate, metric, actualValue, rawPrediction } =
    parsed.data;

  // Derive calibrated values from the current calibration settings so an
  // uploaded event reflects the active validation loop (illustrative).
  // 관리자가 등록하는 정확도검증은 전역 학습(0) — 전 계정 인구 보정에 반영.
  const uid = GLOBAL_LEARNING_USER_ID;
  const [settings] = await db
    .select()
    .from(calibrationSettingsTable)
    .where(eq(calibrationSettingsTable.userId, uid))
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
      userId: uid,
      title,
      product,
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

router.delete("/admin/calibrations/:id", requireAdmin, async (req, res): Promise<void> => {
  const parsed = DeleteCalibrationParams.safeParse(req.params);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const [deleted] = await db
    .delete(calibrationsTable)
    .where(
      and(
        eq(calibrationsTable.id, parsed.data.id),
        eq(calibrationsTable.userId, GLOBAL_LEARNING_USER_ID),
      ),
    )
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

router.get("/admin/survey-impact", async (req, res): Promise<void> => {
  const surveys = await db
    .select()
    .from(surveysTable)
    .where(eq(surveysTable.userId, GLOBAL_LEARNING_USER_ID));
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

router.get("/admin/elections/sources", requireAdmin, async (_req, res): Promise<void> => {
  res.json(ListElectionSourcesResponse.parse(SUPPORTED_ELECTIONS));
});

router.post("/admin/elections/import", requireAdmin, async (req, res): Promise<void> => {
  const parsed = ImportElectionBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const source = findElectionSource(parsed.data.sgId);
  if (!source) {
    res.status(400).json({ error: "지원하지 않는 선거입니다." });
    return;
  }

  try {
    const shares = await fetchConservativeShares(source.sgId);
    // 메트릭 라벨은 시·도 전역에서 참인 값(보수 정당명)으로만 만든다. 지방선거 광역단체장은
    // 시·도마다 후보가 다르므로 특정 후보명을 넣으면 안 된다(예: 오세훈을 17개 지역에 공통
    // 저장 금지). 비례대표는 정당 투표라 "보수 정당", 그 외(대통령·광역단체장)는 "보수 후보".
    const isPartyVote = source.electionType.includes("국회의원");
    const metric = isPartyVote
      ? `보수 정당(${source.conservativeParty}) 득표율`
      : `보수 후보(${source.conservativeParty}) 득표율`;
    // 응답의 candidate는 안내용 대표값 — 비례·지방은 정당명, 대선은 단일 후보명.
    const candidate = isPartyVote
      ? source.conservativeParty
      : (shares[0]?.candidate ?? source.conservativeParty);
    const rows = shares.map((s) => ({
      name: source.name,
      electionType: source.electionType,
      electionDate: source.electionDate,
      regionCode: s.regionCode,
      metric,
      leaning: "conservative",
      actualValue: s.actualValue,
      actualWinner: s.actualWinner,
    }));

    // 선거 검증 화면은 이제 여러 선거를 선택해 비교하므로, 다른 선거 ground-truth를
    // 건드리지 않도록 같은 선거(electionDate)의 기존 행만 교체한다. 완전성 검증(17개
    // 시·도)은 fetchConservativeShares에서 이미 끝났다.
    await db.transaction(async (tx) => {
      await tx
        .delete(electionsTable)
        .where(eq(electionsTable.electionDate, source.electionDate));
      await tx.insert(electionsTable).values(rows);
    });

    req.log.info(
      { sgId: source.sgId, regions: rows.length },
      "Imported real election results from data.go.kr",
    );
    res.json(
      ImportElectionResponse.parse({
        electionName: source.name,
        electionType: source.electionType,
        electionDate: source.electionDate,
        metric,
        candidate,
        imported: rows.length,
        source: "중앙선거관리위원회 (공공데이터포털)",
      }),
    );
  } catch (err) {
    if (err instanceof DataGoKrError) {
      req.log.warn({ sgId: source.sgId, msg: err.message }, "election import failed");
      res.status(502).json({ error: err.message });
      return;
    }
    req.log.error({ err }, "election import failed");
    res.status(502).json({
      error: "공공데이터 연동에 실패했습니다. 잠시 후 다시 시도해 주세요.",
    });
  }
});

// 등록된 모든 선거 백테스트를 electionDate별로 묶어 요약한다. 관리 목록·삭제 UI에서 사용.
// manual = data.go.kr 자동 연동 대상(SUPPORTED_ELECTIONS) 날짜가 아니면 수동 입력으로 표시.
router.get("/admin/elections", requireAdmin, async (_req, res): Promise<void> => {
  const rows = await db.select().from(electionsTable);
  const supportedDates = new Set(SUPPORTED_ELECTIONS.map((s) => s.electionDate));
  const groups = new Map<
    string,
    { name: string; electionType: string; metric: string; regionCount: number }
  >();
  for (const r of rows) {
    const g = groups.get(r.electionDate);
    if (g) {
      g.regionCount += 1;
    } else {
      groups.set(r.electionDate, {
        name: r.name,
        electionType: r.electionType,
        metric: r.metric,
        regionCount: 1,
      });
    }
  }
  const summaries = [...groups.entries()]
    .map(([electionDate, g]) => ({
      name: g.name,
      electionType: g.electionType,
      electionDate,
      metric: g.metric,
      regionCount: g.regionCount,
      manual: !supportedDates.has(electionDate),
    }))
    .sort((a, b) => (a.electionDate < b.electionDate ? 1 : -1));
  res.json(ListElectionBacktestsResponse.parse(summaries));
});

// 관리자가 시·도별 보수 득표율을 직접 입력해 백테스트(ground-truth)를 등록한다. API가 없는
// 선거·여론조사도 수동 등록 가능. electionDate를 키로 같은 날짜의 기존 행을 교체한다.
router.post("/admin/elections/manual", requireAdmin, async (req, res): Promise<void> => {
  const parsed = CreateManualElectionBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const { name, electionType, electionDate, metric, rows: inputRows } = parsed.data;

  const validRegions = await db
    .select({ code: regionsTable.code })
    .from(regionsTable);
  const validCodes = new Set(validRegions.map((r) => r.code));

  const seen = new Set<string>();
  for (const r of inputRows) {
    if (!validCodes.has(r.regionCode)) {
      res.status(400).json({ error: `알 수 없는 지역 코드: ${r.regionCode}` });
      return;
    }
    if (seen.has(r.regionCode)) {
      res.status(400).json({ error: `중복된 지역 코드: ${r.regionCode}` });
      return;
    }
    seen.add(r.regionCode);
    if (r.actualValue < 0 || r.actualValue > 100) {
      res.status(400).json({ error: "득표율은 0~100 사이여야 합니다." });
      return;
    }
    if (r.actualWinner !== "conservative" && r.actualWinner !== "progressive") {
      res.status(400).json({ error: "actualWinner는 conservative 또는 progressive여야 합니다." });
      return;
    }
  }

  const rows = inputRows.map((r) => ({
    name,
    electionType,
    electionDate,
    regionCode: r.regionCode,
    metric,
    leaning: "conservative",
    actualValue: r.actualValue,
    actualWinner: r.actualWinner,
  }));

  await db.transaction(async (tx) => {
    await tx.delete(electionsTable).where(eq(electionsTable.electionDate, electionDate));
    await tx.insert(electionsTable).values(rows);
  });

  req.log.info({ electionDate, regions: rows.length }, "Registered manual election backtest");
  res.json(
    CreateManualElectionResponse.parse({
      name,
      electionType,
      electionDate,
      metric,
      regionCount: rows.length,
      manual: true,
    }),
  );
});

// 등록된 선거 백테스트를 electionDate 기준으로 삭제한다(자동·수동 모두).
router.delete("/admin/elections/:electionDate", requireAdmin, async (req, res): Promise<void> => {
  const parsed = DeleteElectionBacktestParams.safeParse(req.params);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const { electionDate } = parsed.data;
  const deleted = await db
    .delete(electionsTable)
    .where(eq(electionsTable.electionDate, electionDate))
    .returning({ id: electionsTable.id });
  res.json(
    DeleteElectionBacktestResponse.parse({ electionDate, deleted: deleted.length }),
  );
});

// ── 접속 분석 ──────────────────────────────────────────────────────────────
router.get("/admin/analytics", requireAdmin, async (req, res): Promise<void> => {
  const parsedQuery = GetAnalyticsQueryParams.safeParse(req.query);
  const days = parsedQuery.success ? Math.max(0, Math.round(parsedQuery.data.days)) : 30;
  // days 는 검증된 정수라 인터벌 인라인이 안전(인젝션 불가).
  const range = days > 0 ? `created_at >= now() - interval '${days} days'` : `TRUE`;
  const HB = HEARTBEAT_SECONDS;

  // 위치 lazy 해결: 범위 내 비-null IP 중 미해결분만 ip-api 로 채운다.
  const ipRows = await db.execute<{ ip: string }>(
    sql.raw(
      `SELECT DISTINCT ip FROM access_events WHERE ip IS NOT NULL AND ${range}`,
    ),
  );
  await ensureGeoForIps(ipRows.rows.map((r) => r.ip));

  // 세션 단위 집계 CTE(로그인 이벤트는 세션 지표에서 제외).
  const sessCte = `
    WITH sess AS (
      SELECT
        session_id,
        max(user_id) AS user_id,
        (array_agg(ip ORDER BY created_at DESC) FILTER (WHERE ip IS NOT NULL))[1] AS ip,
        (array_agg(device_type ORDER BY created_at DESC) FILTER (WHERE device_type IS NOT NULL))[1] AS device_type,
        (array_agg(browser ORDER BY created_at DESC) FILTER (WHERE browser IS NOT NULL))[1] AS browser,
        (array_agg(os ORDER BY created_at DESC) FILTER (WHERE os IS NOT NULL))[1] AS os,
        (array_agg(client_id ORDER BY created_at DESC))[1] AS client_id,
        min(created_at) AS start_at,
        max(created_at) AS end_at,
        count(*) FILTER (WHERE type = 'pageview') AS pageviews,
        count(*) FILTER (WHERE type = 'heartbeat') AS heartbeats,
        count(*) AS events
      FROM access_events
      WHERE type IN ('pageview','heartbeat') AND ${range}
      GROUP BY session_id
    )`;

  const [
    summaryRes,
    loginRes,
    accountsRes,
    anonRes,
    devicesRes,
    browsersRes,
    menusRes,
    locationsRes,
    sessionsRes,
    dailyRes,
  ] = await Promise.all([
    db.execute<{
      total_sessions: string;
      total_events: string;
      unique_visitors: string;
      logged_in_accounts: string;
      anonymous_sessions: string;
      total_heartbeats: string;
      mobile_sessions: string;
      desktop_sessions: string;
      tablet_sessions: string;
    }>(
      sql.raw(`${sessCte}
        SELECT
          count(*) AS total_sessions,
          coalesce(sum(events),0) AS total_events,
          count(DISTINCT client_id) AS unique_visitors,
          count(DISTINCT user_id) FILTER (WHERE user_id IS NOT NULL) AS logged_in_accounts,
          count(*) FILTER (WHERE user_id IS NULL) AS anonymous_sessions,
          coalesce(sum(heartbeats),0) AS total_heartbeats,
          count(*) FILTER (WHERE device_type='mobile') AS mobile_sessions,
          count(*) FILTER (WHERE device_type='desktop') AS desktop_sessions,
          count(*) FILTER (WHERE device_type='tablet') AS tablet_sessions
        FROM sess`),
    ),
    db.execute<{ login_success: string; login_fail: string }>(
      sql.raw(`SELECT
          count(*) FILTER (WHERE success IS TRUE) AS login_success,
          count(*) FILTER (WHERE success IS FALSE) AS login_fail
        FROM access_events WHERE type='login' AND ${range}`),
    ),
    db.execute<{
      user_id: number;
      username: string;
      name: string;
      role: string;
      sessions: string;
      events: string;
      pageviews: string;
      heartbeats: string;
      first_seen: string;
      last_seen: string;
      mobile_sessions: string;
      desktop_sessions: string;
    }>(
      sql.raw(`${sessCte}
        SELECT s.user_id, u.username, u.name, u.role,
          count(*) AS sessions, coalesce(sum(s.events),0) AS events,
          coalesce(sum(s.pageviews),0) AS pageviews,
          coalesce(sum(s.heartbeats),0) AS heartbeats,
          min(s.start_at) AS first_seen, max(s.end_at) AS last_seen,
          count(*) FILTER (WHERE s.device_type='mobile') AS mobile_sessions,
          count(*) FILTER (WHERE s.device_type='desktop') AS desktop_sessions
        FROM sess s JOIN users u ON u.id = s.user_id
        WHERE s.user_id IS NOT NULL
        GROUP BY s.user_id, u.username, u.name, u.role
        ORDER BY last_seen DESC`),
    ),
    db.execute<{ sessions: string; events: string; heartbeats: string }>(
      sql.raw(`${sessCte}
        SELECT count(*) AS sessions, coalesce(sum(events),0) AS events,
          coalesce(sum(heartbeats),0) AS heartbeats
        FROM sess WHERE user_id IS NULL`),
    ),
    db.execute<{ device_type: string | null; sessions: string; events: string }>(
      sql.raw(`${sessCte}
        SELECT coalesce(device_type,'unknown') AS device_type,
          count(*) AS sessions, coalesce(sum(events),0) AS events
        FROM sess GROUP BY device_type ORDER BY sessions DESC`),
    ),
    db.execute<{ browser: string | null; sessions: string }>(
      sql.raw(`${sessCte}
        SELECT coalesce(browser,'unknown') AS browser, count(*) AS sessions
        FROM sess GROUP BY browser ORDER BY sessions DESC`),
    ),
    db.execute<{
      path: string;
      views: string;
      heartbeats: string;
      sessions: string;
      visitors: string;
    }>(
      sql.raw(`SELECT path,
          count(*) FILTER (WHERE type='pageview') AS views,
          count(*) FILTER (WHERE type='heartbeat') AS heartbeats,
          count(DISTINCT session_id) AS sessions,
          count(DISTINCT client_id) AS visitors
        FROM access_events
        WHERE type IN ('pageview','heartbeat') AND ${range}
        GROUP BY path ORDER BY views DESC`),
    ),
    db.execute<{
      country: string | null;
      country_code: string | null;
      region: string | null;
      city: string | null;
      sessions: string;
      visitors: string;
    }>(
      sql.raw(`${sessCte}
        SELECT g.country, g.country_code, g.region, g.city,
          count(*) AS sessions, count(DISTINCT s.client_id) AS visitors
        FROM sess s LEFT JOIN ip_geo g ON g.ip = s.ip
        GROUP BY g.country, g.country_code, g.region, g.city
        ORDER BY sessions DESC`),
    ),
    db.execute<{
      session_id: string;
      user_id: number | null;
      username: string | null;
      name: string | null;
      ip: string | null;
      device_type: string | null;
      browser: string | null;
      os: string | null;
      country: string | null;
      region: string | null;
      city: string | null;
      start_at: string;
      end_at: string;
      heartbeats: string;
      pageviews: string;
      events: string;
    }>(
      sql.raw(`${sessCte}
        SELECT s.session_id, s.user_id, u.username, u.name, s.ip,
          s.device_type, s.browser, s.os,
          g.country, g.region, g.city,
          s.start_at, s.end_at, s.heartbeats, s.pageviews, s.events
        FROM sess s
        LEFT JOIN users u ON u.id = s.user_id
        LEFT JOIN ip_geo g ON g.ip = s.ip
        ORDER BY s.end_at DESC
        LIMIT 200`),
    ),
    db.execute<{
      date: string;
      events: string;
      sessions: string;
      visitors: string;
    }>(
      sql.raw(`SELECT to_char(date_trunc('day', created_at),'YYYY-MM-DD') AS date,
          count(*) AS events,
          count(DISTINCT session_id) AS sessions,
          count(DISTINCT client_id) AS visitors
        FROM access_events
        WHERE type IN ('pageview','heartbeat') AND ${range}
        GROUP BY 1 ORDER BY 1`),
    ),
  ]);

  const n = (v: string | number | null | undefined): number => Number(v ?? 0);
  const minutesFromHb = (hb: number): number =>
    Math.round(((hb * HB) / 60) * 10) / 10;

  const s = summaryRes.rows[0];
  const lg = loginRes.rows[0];
  const totalHeartbeats = n(s?.total_heartbeats);

  const payload = {
    rangeDays: days,
    summary: {
      totalEvents: n(s?.total_events),
      totalSessions: n(s?.total_sessions),
      uniqueVisitors: n(s?.unique_visitors),
      loggedInAccounts: n(s?.logged_in_accounts),
      anonymousSessions: n(s?.anonymous_sessions),
      totalMinutes: minutesFromHb(totalHeartbeats),
      mobileSessions: n(s?.mobile_sessions),
      desktopSessions: n(s?.desktop_sessions),
      tabletSessions: n(s?.tablet_sessions),
      loginSuccess: n(lg?.login_success),
      loginFail: n(lg?.login_fail),
    },
    accounts: accountsRes.rows.map((r) => ({
      userId: n(r.user_id),
      username: r.username,
      name: r.name,
      role: r.role,
      sessions: n(r.sessions),
      events: n(r.events),
      pageviews: n(r.pageviews),
      totalMinutes: minutesFromHb(n(r.heartbeats)),
      firstSeenAt: r.first_seen,
      lastSeenAt: r.last_seen,
      mobileSessions: n(r.mobile_sessions),
      desktopSessions: n(r.desktop_sessions),
    })),
    anonymous: {
      sessions: n(anonRes.rows[0]?.sessions),
      events: n(anonRes.rows[0]?.events),
      totalMinutes: minutesFromHb(n(anonRes.rows[0]?.heartbeats)),
    },
    menus: menusRes.rows.map((r) => ({
      path: r.path,
      views: n(r.views),
      heartbeats: n(r.heartbeats),
      sessions: n(r.sessions),
      visitors: n(r.visitors),
      totalMinutes: minutesFromHb(n(r.heartbeats)),
    })),
    devices: devicesRes.rows.map((r) => ({
      deviceType: r.device_type ?? "unknown",
      sessions: n(r.sessions),
      events: n(r.events),
    })),
    browsers: browsersRes.rows.map((r) => ({
      browser: r.browser ?? "unknown",
      sessions: n(r.sessions),
    })),
    locations: locationsRes.rows.map((r) => ({
      country: r.country,
      countryCode: r.country_code,
      region: r.region,
      city: r.city,
      sessions: n(r.sessions),
      visitors: n(r.visitors),
    })),
    sessions: sessionsRes.rows.map((r) => ({
      sessionId: r.session_id,
      userId: r.user_id,
      username: r.username,
      name: r.name,
      ip: r.ip,
      deviceType: r.device_type,
      browser: r.browser,
      os: r.os,
      country: r.country,
      region: r.region,
      city: r.city,
      startAt: r.start_at,
      endAt: r.end_at,
      durationMinutes: minutesFromHb(n(r.heartbeats)),
      pageviews: n(r.pageviews),
      events: n(r.events),
    })),
    daily: dailyRes.rows.map((r) => ({
      date: r.date,
      events: n(r.events),
      sessions: n(r.sessions),
      visitors: n(r.visitors),
    })),
  };

  res.json(GetAnalyticsResponse.parse(jsonReady(payload)));
});

export default router;
