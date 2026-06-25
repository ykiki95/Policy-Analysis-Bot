import rateLimit, { ipKeyGenerator } from "express-rate-limit";
import type { RequestHandler } from "express";

/**
 * 무차별 대입(brute-force) 방지용 인증 제한기. 로그인/회원가입에 적용한다.
 * IP당 15분에 30회.
 */
export const authLimiter: RequestHandler = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 30,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: "요청이 너무 많습니다. 잠시 후 다시 시도해 주세요." },
});

/**
 * 시뮬레이션 실행(enqueue) 남용 방지용 제한기. 사용자당(미인증 시 IP) 1분에 20회.
 */
export const runLimiter: RequestHandler = rateLimit({
  windowMs: 60 * 1000,
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) =>
    req.session?.userId
      ? `u:${req.session.userId}`
      : ipKeyGenerator(req.ip ?? ""),
  message: { error: "실행 요청이 너무 많습니다. 잠시 후 다시 시도해 주세요." },
});

/**
 * 접속 분석 비콘(/track) 남용 방지용 제한기. 공개(비로그인) write 엔드포인트라
 * 임의 스크립트의 대량 이벤트 주입(지표 오염 + DB write 폭증)을 차단한다.
 * IP당 1분에 60회(정상 비콘은 pageview + 20초 heartbeat 수준이라 넉넉).
 * 초과해도 비콘은 fire-and-forget 이므로 429 를 무시해도 UX 영향이 없다.
 */
export const trackLimiter: RequestHandler = rateLimit({
  windowMs: 60 * 1000,
  max: 60,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => ipKeyGenerator(req.ip ?? ""),
  message: { error: "요청이 너무 많습니다." },
});
