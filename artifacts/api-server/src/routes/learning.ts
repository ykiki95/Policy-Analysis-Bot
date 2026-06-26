import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { desc, eq, inArray } from "drizzle-orm";
import { db, learningContributionsTable } from "@workspace/db";
import { tenantId, isAdmin, learningReadIds } from "../lib/tenant";
import { requireAdmin } from "../lib/auth";
import {
  getOverview,
  submitContribution,
  runLearningCycle,
  approveContribution,
  rejectContribution,
  DOMAINS,
  type LearningDomain,
} from "../lib/autoLearning";
import {
  LearningOverviewResponse,
  ListContributionsResponse,
  CreateContributionBody,
  CreateContributionResponse,
  RunLearningResponse,
  ContributionDecisionParams,
  ContributionDecisionBody,
  ContributionDecisionResponse,
} from "@workspace/api-zod";

const router: IRouter = Router();

/** 전역 합성인구의 현실 정확도 개요(추이 + 통계 + 도메인별). */
router.get("/learning/overview", async (_req, res): Promise<void> => {
  const overview = await getOverview();
  res.json(LearningOverviewResponse.parse(jsonReady(overview)));
});

/** 학습 기여 목록. 관리자는 전체(또는 ?status= 필터), 일반 사용자는 전역+본인. */
router.get("/learning/contributions", async (req, res): Promise<void> => {
  const status = typeof req.query["status"] === "string" ? req.query["status"] : null;
  const rows = await db
    .select()
    .from(learningContributionsTable)
    .orderBy(desc(learningContributionsTable.createdAt));

  const visible = isAdmin(req)
    ? rows
    : rows.filter((r) => learningReadIds(req).includes(r.userId));
  const filtered = status ? visible.filter((r) => r.status === status) : visible;

  res.json(ListContributionsResponse.parse(jsonReady(filtered)));
});

/** 학습 기여 제출(모든 로그인 사용자). 제출 즉시 자동 사이클이 평가·반영한다. */
router.post("/learning/contributions", async (req, res): Promise<void> => {
  const parsed = CreateContributionBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.message });
    return;
  }
  const { domain, title, observedValue, sampleSize } = parsed.data;
  if (!DOMAINS.includes(domain as LearningDomain)) {
    res.status(400).json({ error: "알 수 없는 도메인입니다." });
    return;
  }
  const contribution = await submitContribution({
    userId: tenantId(req),
    domain: domain as LearningDomain,
    title,
    observedValue,
    sampleSize,
  });
  // 자동 자가학습: 제출 즉시 사이클을 돌려 검증 게이트로 반영/격리/플래그한다.
  const cycle = await runLearningCycle();
  res.json(
    CreateContributionResponse.parse(
      jsonReady({ contribution, cycle }),
    ),
  );
});

/** 관리자: 학습 사이클 수동 실행. */
router.post(
  "/admin/learning/run",
  requireAdmin,
  async (_req, res): Promise<void> => {
    const result = await runLearningCycle();
    res.json(RunLearningResponse.parse(jsonReady(result)));
  },
);

/** 관리자: flagged/quarantined 기여 수동 승인/거부. */
router.post(
  "/admin/learning/contributions/:id/decision",
  requireAdmin,
  async (req, res): Promise<void> => {
    const params = ContributionDecisionParams.safeParse(req.params);
    const body = ContributionDecisionBody.safeParse(req.body);
    if (!params.success || !body.success) {
      res.status(400).json({ error: "잘못된 요청입니다." });
      return;
    }
    const id = Number(params.data.id);
    const updated =
      body.data.action === "approve"
        ? await approveContribution(id)
        : await rejectContribution(id);
    if (!updated) {
      res.status(404).json({ error: "기여를 찾을 수 없습니다." });
      return;
    }
    res.json(ContributionDecisionResponse.parse(jsonReady(updated)));
  },
);

export default router;
