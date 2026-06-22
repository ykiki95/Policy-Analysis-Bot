import { Router, type IRouter } from "express";
import { GetBudgetResponse } from "@workspace/api-zod";
import { getBudgetStatus } from "../lib/budget";
import { tenantId } from "../lib/tenant";

const router: IRouter = Router();

/**
 * 현재 사용자(또는 admin이 ?accountId로 지정한 계정)의 예산 현황.
 * 모든 금액은 실제 LLM 실비(USD)다. 화면 표시 배수는 프런트 lib/cost.ts 가 적용한다.
 */
router.get("/budget", async (req, res): Promise<void> => {
  const status = await getBudgetStatus(tenantId(req));
  res.json(
    GetBudgetResponse.parse({
      limitUsd: status.limitUsd,
      spentUsd: status.spentUsd,
      remainingUsd: status.remainingUsd,
    }),
  );
});

export default router;
