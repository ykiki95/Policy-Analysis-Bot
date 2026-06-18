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
