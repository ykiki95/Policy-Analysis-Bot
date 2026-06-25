import { Router, type IRouter } from "express";
import { TrackEventBody } from "@workspace/api-zod";
import { recordEvent } from "../lib/analytics";
import { trackLimiter } from "../lib/rateLimit";

const router: IRouter = Router();

/**
 * 접속 분석 비콘 수집. 비로그인 방문자도 집계하므로 requireAuth 이전에 마운트한다.
 * fire-and-forget: 입력이 잘못돼도 사용자 경험을 막지 않도록 항상 204 로 응답하되,
 * 명백히 형식이 틀린 경우만 400 을 반환한다.
 */
router.post("/track", trackLimiter, async (req, res): Promise<void> => {
  const parsed = TrackEventBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "입력값이 올바르지 않습니다." });
    return;
  }
  const { clientId, sessionId, path, type } = parsed.data;
  // 세션에 로그인 사용자가 있으면 함께 기록(없으면 익명).
  const userId = req.session?.userId ?? null;
  await recordEvent(req, { clientId, sessionId, userId, path, type });
  res.status(204).end();
});

export default router;
