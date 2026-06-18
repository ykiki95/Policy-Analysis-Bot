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

  // 항상 가동되는 워커 루프를 시작한다. 큐(queued)에 적재된 작업과 직전
  // 프로세스에서 멈춘(heartbeat 만료) 고아 작업을 claim 해 실행/재개한다.
  startSimulationWorker();
});
