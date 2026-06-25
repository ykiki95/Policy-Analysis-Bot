import type { Request } from "express";
import { UAParser } from "ua-parser-js";
import { db, accessEventsTable } from "@workspace/db";
import { logger } from "./logger";

/** heartbeat 비콘 주기(초). 프런트 tracking.ts 와 반드시 동일하게 유지. */
export const HEARTBEAT_SECONDS = 20;

export interface ParsedDevice {
  deviceType: string; // 'mobile' | 'tablet' | 'desktop' | 'bot' | 'unknown'
  browser: string;
  os: string;
}

/**
 * User-Agent 문자열을 기기 종류/브라우저/OS 로 파싱한다.
 * ua-parser 의 device.type 은 desktop 일 때 비어 있으므로 보정한다.
 */
export function parseUserAgent(ua: string | undefined): ParsedDevice {
  if (!ua) return { deviceType: "unknown", browser: "unknown", os: "unknown" };
  const parsed = UAParser(ua);
  const rawType = parsed.device.type; // mobile | tablet | console | smarttv | wearable | embedded | undefined
  let deviceType: string;
  if (rawType === "mobile" || rawType === "tablet") {
    deviceType = rawType;
  } else if (/bot|crawler|spider|crawl|slurp/i.test(ua)) {
    deviceType = "bot";
  } else if (rawType === undefined) {
    deviceType = "desktop";
  } else {
    deviceType = rawType;
  }
  return {
    deviceType,
    browser: parsed.browser.name ?? "unknown",
    os: parsed.os.name ?? "unknown",
  };
}

/**
 * 최선 추정 클라이언트 IP.
 * 외부 오픈은 Cloudflare Worker → Replit 프록시 → 앱 경로라 req.ip 는 프록시
 * 주소일 수 있다. 실제 방문자 IP 는 cf-connecting-ip → x-forwarded-for 첫 항목
 * → req.ip 순으로 추정한다.
 */
export function getClientIp(req: Request): string | undefined {
  const cf = req.headers["cf-connecting-ip"];
  if (typeof cf === "string" && cf.trim()) return cf.trim();

  const xff = req.headers["x-forwarded-for"];
  if (typeof xff === "string" && xff.trim()) {
    const first = xff.split(",")[0]?.trim();
    if (first) return first;
  }
  return req.ip;
}

export type AccessEventType = "pageview" | "heartbeat" | "login";

export interface RecordEventArgs {
  clientId: string;
  sessionId: string;
  userId?: number | null;
  path: string;
  type: AccessEventType;
  success?: boolean | null;
}

/**
 * 접속 이벤트 1건 기록(fire-and-forget). UA/IP 는 요청에서 추출한다.
 * 분석 수집은 절대 사용자 경험을 막지 않으므로 실패는 조용히 로깅만 한다.
 */
export async function recordEvent(
  req: Request,
  args: RecordEventArgs,
): Promise<void> {
  try {
    const { deviceType, browser, os } = parseUserAgent(req.headers["user-agent"]);
    await db.insert(accessEventsTable).values({
      clientId: args.clientId.slice(0, 80),
      sessionId: args.sessionId.slice(0, 80),
      userId: args.userId ?? null,
      ip: getClientIp(req) ?? null,
      userAgent: (req.headers["user-agent"] ?? "").slice(0, 500) || null,
      deviceType,
      browser,
      os,
      path: args.path.slice(0, 300),
      type: args.type,
      success: args.success ?? null,
    });
  } catch (err) {
    logger.warn({ err }, "접속 이벤트 기록 실패(스킵)");
  }
}
