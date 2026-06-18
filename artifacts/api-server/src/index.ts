import app from "./app";
import { logger } from "./lib/logger";
import { startSimulationWorker } from "./lib/worker";

const rawPort = process.env["PORT"];

if (!rawPort) {
  throw new Error(
    "PORT environment variable is required but was not provided.",
  );
}

const port = Number(rawPort);

if (Number.isNaN(port) || port <= 0) {
  throw new Error(`Invalid PORT value: "${rawPort}"`);
}

app.listen(port, (err) => {
  if (err) {
    logger.error({ err }, "Error listening on port");
    process.exit(1);
  }

  logger.info({ port }, "Server listening");

  // 워커 루프: 큐(queued) 작업과 고아(heartbeat 만료) 작업을 claim 해 실행/재개한다.
  // 다만 프로덕션(Autoscale, 유휴 시 0으로 축소)에서는 "사용자가 화면을 보는 동안만"
  // 비용이 들도록 클라이언트 구동(B1, /simulations/:id/tick)으로 처리한다 — 상시 워커는
  // 인스턴스를 깨어 있게 만들어 비용을 유발하므로 프로덕션에서는 끈다. 개발에서는
  // 편의를 위해 워커를 켜 둔다(프런트 tick 없이도 시뮬레이션이 완료됨).
  if (process.env["NODE_ENV"] !== "production") {
    startSimulationWorker();
  } else {
    logger.info(
      "Worker loop disabled in production (client-driven tick processing)",
    );
  }
});
