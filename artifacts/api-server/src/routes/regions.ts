import { Router, type IRouter } from "express";
import { db, regionsTable } from "@workspace/db";
import { ListRegionsResponse } from "@workspace/api-zod";

const router: IRouter = Router();

router.get("/regions", async (_req, res): Promise<void> => {
  const rows = await db
    .select()
    .from(regionsTable)
    .orderBy(regionsTable.displayOrder);
  res.json(ListRegionsResponse.parse(rows));
});

export default router;
