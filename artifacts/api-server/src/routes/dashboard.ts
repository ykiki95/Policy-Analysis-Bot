import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { desc, eq } from "drizzle-orm";
import {
  db,
  agentsTable,
  simulationsTable,
  calibrationsTable,
} from "@workspace/db";
import { tenantId } from "../lib/tenant";
import { GetDashboardSummaryResponse } from "@workspace/api-zod";

const router: IRouter = Router();

router.get("/dashboard/summary", async (req, res): Promise<void> => {
  const uid = tenantId(req);
  const [agents, simulations, calibrations] = await Promise.all([
    db.select().from(agentsTable).where(eq(agentsTable.userId, uid)),
    db
      .select()
      .from(simulationsTable)
      .where(eq(simulationsTable.userId, uid))
      .orderBy(desc(simulationsTable.createdAt)),
    db
      .select()
      .from(calibrationsTable)
      .where(eq(calibrationsTable.userId, uid)),
  ]);

  const completed = simulations.filter((s) => s.status === "completed");
  const totalSpend = simulations.reduce(
    (acc, s) => acc + (s.costActualUsd ?? 0),
    0,
  );

  const avg = (nums: number[]) =>
    nums.length === 0
      ? 0
      : Math.round((nums.reduce((a, b) => a + b, 0) / nums.length) * 10) / 10;

  const avgCalibratedAccuracy = avg(
    calibrations.map((c) => 100 - Math.abs(c.calibratedError)),
  );
  const avgRawAccuracy = avg(
    calibrations.map((c) => 100 - Math.abs(c.rawError)),
  );

  res.json(
    GetDashboardSummaryResponse.parse(
      jsonReady({
        totalAgents: agents.length,
        totalSimulations: simulations.length,
        completedSimulations: completed.length,
        avgCalibratedAccuracy,
        avgRawAccuracy,
        totalSpendUsd: Math.round(totalSpend * 10000) / 10000,
        recentSimulations: simulations.slice(0, 5),
      }),
    ),
  );
});

export default router;
