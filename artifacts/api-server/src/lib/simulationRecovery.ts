import { eq } from "drizzle-orm";
import { db, simulationsTable } from "@workspace/db";
import { logger } from "./logger";
import { runSimulation } from "./simulationEngine";

/**
 * 서버 부팅 시 호출한다. 직전 프로세스가 실행 중 죽으면(배포/재시작/크래시)
 * 시뮬레이션이 "running" 상태로 영원히 멈춘다(orphaned). 새 프로세스에서는
 * 어떤 실행도 진행 중이지 않으므로, "running" 인 모든 시뮬레이션은 고아이며
 * 안전하게 재개할 수 있다. 이미 응답이 저장된 에이전트는 건너뛰고 남은
 * 에이전트만 처리한다(증분 저장 + 멱등 insert 덕분).
 *
 * 비용/부하 폭증을 막기 위해 고아 시뮬레이션은 순차적으로 재개한다.
 * 서버 기동을 막지 않도록 호출부에서 await 하지 말 것(백그라운드 실행).
 */
export async function resumeOrphanedSimulations(): Promise<void> {
  let orphans: { id: number }[];
  try {
    orphans = await db
      .select({ id: simulationsTable.id })
      .from(simulationsTable)
      .where(eq(simulationsTable.status, "running"));
  } catch (err) {
    logger.error({ err }, "Failed to query orphaned simulations on startup");
    return;
  }

  if (orphans.length === 0) {
    logger.info("Startup recovery: no orphaned simulations to resume");
    return;
  }

  logger.info(
    { count: orphans.length, ids: orphans.map((o) => o.id) },
    "Startup recovery: resuming orphaned simulations",
  );

  for (const { id } of orphans) {
    try {
      await runSimulation(id, { resume: true });
    } catch (err) {
      logger.error({ err, simulationId: id }, "Failed to resume simulation");
    }
  }
}
