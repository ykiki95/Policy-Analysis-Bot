import {
  pgTable,
  serial,
  text,
  integer,
  boolean,
  doublePrecision,
  timestamp,
  index,
} from "drizzle-orm/pg-core";

/**
 * 접속 분석 이벤트 스트림(외부 오픈 서비스 사용 현황 추적).
 * 프런트가 보내는 pageview/heartbeat 비콘 + 서버가 기록하는 login 이벤트.
 * 비로그인 방문도 집계하므로 userId 는 nullable(null = 익명).
 * 세션 체류 시간 = sessionId 별 max(createdAt)-min(createdAt),
 * 메뉴별 사용 시간 ≈ path 별 heartbeat 수 × heartbeat 주기.
 */
export const accessEventsTable = pgTable(
  "access_events",
  {
    id: serial("id").primaryKey(),
    /** 브라우저 영속 식별자(localStorage) — 고유 방문자 추산용 */
    clientId: text("client_id").notNull(),
    /** 방문 세션 식별자(sessionStorage, 탭 단위) */
    sessionId: text("session_id").notNull(),
    /** 로그인 사용자 id. null = 비로그인(익명) 방문 */
    userId: integer("user_id"),
    /** 최선 추정 클라이언트 IP(cf-connecting-ip > x-forwarded-for > req.ip) */
    ip: text("ip"),
    userAgent: text("user_agent"),
    /** 'mobile' | 'tablet' | 'desktop' | 'bot' | 'unknown' */
    deviceType: text("device_type"),
    browser: text("browser"),
    os: text("os"),
    /** 접속한 메뉴/라우트 경로(예: '/simulations') */
    path: text("path").notNull(),
    /** 'pageview' | 'heartbeat' | 'login' */
    type: text("type").notNull(),
    /** login 이벤트의 성공 여부(그 외 null) */
    success: boolean("success"),
    createdAt: timestamp("created_at", { withTimezone: true })
      .notNull()
      .defaultNow(),
  },
  (t) => [
    index("access_events_created_at_idx").on(t.createdAt),
    index("access_events_session_idx").on(t.sessionId),
    index("access_events_user_idx").on(t.userId),
    index("access_events_ip_idx").on(t.ip),
  ],
);

export type AccessEvent = typeof accessEventsTable.$inferSelect;
export type InsertAccessEvent = typeof accessEventsTable.$inferInsert;

/**
 * IP → 위치 조회 캐시. 관리자가 분석을 열 때 미해결 IP 만 ip-api.com 배치로
 * 조회해 채운다(요청당 IP 마다 외부 호출하지 않음). 사설/로컬 IP 는 status='private'.
 */
export const ipGeoTable = pgTable("ip_geo", {
  ip: text("ip").primaryKey(),
  /** 'success' | 'fail' | 'private' */
  status: text("status").notNull(),
  country: text("country"),
  countryCode: text("country_code"),
  region: text("region"),
  city: text("city"),
  lat: doublePrecision("lat"),
  lon: doublePrecision("lon"),
  isp: text("isp"),
  fetchedAt: timestamp("fetched_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type IpGeo = typeof ipGeoTable.$inferSelect;
export type InsertIpGeo = typeof ipGeoTable.$inferInsert;
