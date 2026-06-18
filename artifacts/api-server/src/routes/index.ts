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
import adminRouter from "./admin";
import { requireAuth, requireAdmin } from "../lib/auth";

const router: IRouter = Router();

// 비로그인 접근 허용 — 헬스체크 + 인증(로그인/회원가입)
router.use(healthRouter);
router.use(authRouter);

// 이하 모든 데이터 라우트는 로그인 필수
router.use(requireAuth);
router.use(agentsRouter);
router.use(surveysRouter);
router.use(simulationsRouter);
router.use(calibrationRouter);
router.use(regionsRouter);
router.use(productsRouter);
router.use(dashboardRouter);

// 관리자 전용
router.use(requireAdmin, adminRouter);

export default router;
