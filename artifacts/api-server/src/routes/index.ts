import { Router, type IRouter } from "express";
import healthRouter from "./health";
import agentsRouter from "./agents";
import surveysRouter from "./surveys";
import simulationsRouter from "./simulations";
import calibrationRouter from "./calibration";
import regionsRouter from "./regions";
import productsRouter from "./products";
import dashboardRouter from "./dashboard";
import adminRouter from "./admin";

const router: IRouter = Router();

router.use(healthRouter);
router.use(agentsRouter);
router.use(surveysRouter);
router.use(simulationsRouter);
router.use(calibrationRouter);
router.use(regionsRouter);
router.use(productsRouter);
router.use(dashboardRouter);
router.use(adminRouter);

export default router;
