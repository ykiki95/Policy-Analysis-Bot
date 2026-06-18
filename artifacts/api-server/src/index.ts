import app from "./app";
import { logger } from "./lib/logger";
import { resumeOrphanedSimulations } from "./lib/simulationRecovery";

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

  // 부팅 시 직전 프로세스에서 멈춘(running) 시뮬레이션을 백그라운드로 재개한다.
  // 서버 기동을 막지 않도록 await 하지 않는다.
  void resumeOrphanedSimulations().catch((err) =>
    logger.error({ err }, "Startup simulation recovery crashed"),
  );
});
