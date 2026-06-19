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
import profileRouter from "./profile";
import adminRouter from "./admin";
import { requireAuth } from "../lib/auth";
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
router.use(profileRouter);

// adminRouter 는 자기서비스(테넌트 스코프) 라우트와 관리자 전용 라우트를 함께 담는다.
// 자기서비스(데이터 출처·설문 업로드·보정 설정·검증 이벤트·인구 재생성)는 모든 로그인
// 사용자가 본인 스코프로 사용하고, 관리자 전용(계정 관리·실선거 데이터 import)은 각
// 핸들러에 requireAdmin 을 직접 건다(routes/admin.ts). 따라서 전역 /admin 게이트는
// 두지 않는다 — 그래야 일반 사용자도 자기서비스 탭의 데이터를 볼 수 있다.
router.use(adminRouter);

export default router;
