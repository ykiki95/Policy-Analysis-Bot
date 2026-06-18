import { Router, type IRouter } from "express";
import healthRouter from "./health";
import authRouter from "./auth";
import agentsRouter from "./agents";
import surveysRouter from "./surveys";
import simulationsRouter from "./simulations";
import calibrationRouter from "./calibration";
import regionsRouter from "./regions";
import productsRouter from "./products";
import dashboardRouter from "./dashboard";
import budgetRouter from "./budget";
import adminRouter from "./admin";
import { requireAuth, requireAdmin } from "../lib/auth";
import { withTenant } from "../lib/tenant";

const router: IRouter = Router();

// 비로그인 접근 허용 — 헬스체크 + 인증(로그인/회원가입)
router.use(healthRouter);
// 인증 라우트. 무차별 대입 방지 rate limit 은 authRouter 내부에서 signup/login
// 라우트에만 직접 적용한다(전역 마운트 시 폴링/tick 등 모든 /api 요청이 제한되어
// 429 가 발생하므로 경로별로 좁게 건다).
router.use(authRouter);

// 이하 모든 데이터 라우트는 로그인 필수 + 테넌트 컨텍스트(소유자 스코프) 부여
router.use(requireAuth);
router.use(withTenant);
router.use(agentsRouter);
router.use(surveysRouter);
router.use(simulationsRouter);
router.use(calibrationRouter);
router.use(regionsRouter);
router.use(productsRouter);
router.use(dashboardRouter);
router.use(budgetRouter);

// 관리자 전용 — /admin/* 경로에만 admin 게이트를 적용한다(미등록 경로의 404
// 핸들러를 가리지 않도록 catch-all 미들웨어로 두지 않는다).
router.use("/admin", requireAdmin);
router.use(adminRouter);

export default router;
