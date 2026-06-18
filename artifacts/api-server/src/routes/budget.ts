import { Router, type IRouter } from "express";
import { GetBudgetResponse } from "@workspace/api-zod";
import { getBudgetStatus, DISPLAY_MULTIPLIER } from "../lib/budget";
import { tenantId } from "../lib/tenant";

const router: IRouter = Router();

/**
 * 현재 사용자(또는 admin이 ?accountId로 지정한 계정)의 예산 현황.
 * 내부 저장은 실비(USD)지만 화면 표시는 ×10 하여 반환한다.
 */
router.get("/budget", async (req, res): Promise<void> => {
  const status = await getBudgetStatus(tenantId(req));
  res.json(
    GetBudgetResponse.parse({
      limitUsd: status.limitUsd * DISPLAY_MULTIPLIER,
      spentUsd: status.spentUsd * DISPLAY_MULTIPLIER,
      remainingUsd: status.remainingUsd * DISPLAY_MULTIPLIER,
      multiplier: DISPLAY_MULTIPLIER,
    }),
  );
});

export default router;
