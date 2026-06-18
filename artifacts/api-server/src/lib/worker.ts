import { sql } from "drizzle-orm";
import { db } from "@workspace/db";
import { logger } from "./logger";
import { runSimulation } from "./simulationEngine";

/**
 * 항상 가동되는 시뮬레이션 워커 루프. API의 `/simulations/:id/run`은 작업을
 * 큐에 넣기만 하고(status='queued'), 실제 LLM 실행은 이 루프가 담당한다.
 *
 * 작업 claim 은 DB lease 로 원자적으로 수행한다:
 *  - `status='queued'` 인 신규 작업, 또는
 *  - `status='running'` 이지만 heartbeat 가 만료된 고아(직전 프로세스 크래시/재배포)
 * 를 한 건 집어 `running` 으로 전환하고 locked_by/heartbeat 를 찍는다.
 * `FOR UPDATE SKIP LOCKED` 로 다중 인스턴스에서도 한 작업을 한 워커만 가져간다.
 *
 * 실행은 항상 resume 모드(증분 저장 + 멱등 insert)라서, 워커가 중간에 죽어도
 * heartbeat 만료 후 다른(또는 재시작된) 워커가 이어받아 남은 에이전트만 처리한다.
 */
const WORKER_ID = `${process.pid}-${Math.random().toString(36).slice(2, 8)}`;
const POLL_MS = 3000;
const STALE_MS = 60_000;

let ticking = false;
let timer: ReturnType<typeof setInterval> | null = null;

async function claimNext(): Promise<number | null> {
  const staleCutoff = new Date(Date.now() - STALE_MS);
  const result = await db.execute<{ id: number }>(sql`
    UPDATE simulations
    SET status = 'running',
        locked_by = ${WORKER_ID},
        locked_at = now(),
        heartbeat_at = now(),
        last_error = NULL
    WHERE id = (
      SELECT id FROM simulations
      WHERE status = 'queued'
         OR (status = 'running' AND (heartbeat_at IS NULL OR heartbeat_at < ${staleCutoff}))
      ORDER BY created_at
      LIMIT 1
      FOR UPDATE SKIP LOCKED
    )
    RETURNING id
  `);
  const row = result.rows[0];
  return row ? Number(row.id) : null;
}

async function tick(): Promise<void> {
  if (ticking) return;
  ticking = true;
  try {
    let id = await claimNext();
    while (id != null) {
      logger.info({ simulationId: id, worker: WORKER_ID }, "Worker claimed simulation");
      try {
        await runSimulation(id, { resume: true });
      } catch (err) {
        logger.error({ err, simulationId: id }, "Worker simulation run failed");
      }
      id = await claimNext();
    }
  } catch (err) {
    logger.error({ err }, "Worker tick failed");
  } finally {
    ticking = false;
  }
}

/** 서버 기동 시 1회 호출. 폴링 루프를 시작한다(idempotent). */
export function startSimulationWorker(): void {
  if (timer) return;
  logger.info({ worker: WORKER_ID, pollMs: POLL_MS }, "Starting simulation worker loop");
  timer = setInterval(() => void tick(), POLL_MS);
  void tick();
}
