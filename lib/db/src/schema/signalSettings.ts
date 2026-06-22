import {
  pgTable,
  serial,
  integer,
  text,
  boolean,
  doublePrecision,
  timestamp,
} from "drizzle-orm/pg-core";

/**
 * 신호 인제스트 전역 설정(사용자당 1행).
 * 소스 on/off·가중치(0~2)와 신호 반영 토글은 실제로 동작한다(가중치는 신규 배치
 * 효과 크기에, applyToPrediction 은 추이 차트 기준선에 반영). 스케줄·품질 필터는
 * 화면·영속만 하고 실제 크론/필터링 파이프라인은 없다.
 */
export const signalSettingsTable = pgTable("signal_settings", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().unique(),
  /** 소스 활성화 토글 */
  sourceNewsEnabled: boolean("source_news_enabled").notNull().default(true),
  sourceTrendEnabled: boolean("source_trend_enabled").notNull().default(true),
  sourceSnsEnabled: boolean("source_sns_enabled").notNull().default(true),
  /** 소스 가중치 0~2 (신규 배치 효과 크기에 곱) */
  sourceNewsWeight: doublePrecision("source_news_weight").notNull().default(1),
  sourceTrendWeight: doublePrecision("source_trend_weight").notNull().default(1),
  sourceSnsWeight: doublePrecision("source_sns_weight").notNull().default(1),
  /** 신호 반영: 추이 차트 y 가 valueAfter↔valueBefore 로 전환 */
  applyToPrediction: boolean("apply_to_prediction").notNull().default(true),
  /** 수집 주기(하드코딩 — 저장만) */
  scheduleEnabled: boolean("schedule_enabled").notNull().default(false),
  scheduleInterval: text("schedule_interval").notNull().default("수동"),
  /** 품질 필터(하드코딩 — 저장만) */
  filterBotRemoval: boolean("filter_bot_removal").notNull().default(true),
  filterDedup: boolean("filter_dedup").notNull().default(true),
  filterMinItems: integer("filter_min_items").notNull().default(50),
  updatedAt: timestamp("updated_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type SignalSettings = typeof signalSettingsTable.$inferSelect;
export type InsertSignalSettings = typeof signalSettingsTable.$inferInsert;
