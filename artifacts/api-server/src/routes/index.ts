import { Router, type IRouter } from "express";
import healthRouter from "./health";
import agentsRouter from "./agents";
import surveysRouter from "./surveys";
import simulationsRouter from "./simulations";
import calibrationRouter from "./calibration";
import productsRouter from "./products";
import dashboardRouter from "./dashboard";

const router: IRouter = Router();

router.use(healthRouter);
router.use(agentsRouter);
router.use(surveysRouter);
router.use(simulationsRouter);
router.use(calibrationRouter);
router.use(productsRouter);
router.use(dashboardRouter);

export default router;
