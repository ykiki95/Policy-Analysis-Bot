import {
  pgTable,
  serial,
  text,
  integer,
  boolean,
  doublePrecision,
  timestamp,
} from "drizzle-orm/pg-core";

export const calibrationSettingsTable = pgTable("calibration_settings", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull(),
  method: text("method").notNull(),
  benchmarkWeight: doublePrecision("benchmark_weight").notNull(),
  recencyWeight: doublePrecision("recency_weight").notNull(),
  shrinkageFactor: doublePrecision("shrinkage_factor").notNull(),
  outlierTrimPct: doublePrecision("outlier_trim_pct").notNull(),
  // 입력 보정(Lever 1) 토글: true 면 인구 재생성 시 검증 이벤트 편향을
  // 페르소나 기준선에 반영한다. 기존 행 백필 기본값 false.
  applyToPopulation: boolean("apply_to_population").notNull().default(false),
  description: text("description").notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type CalibrationSettings = typeof calibrationSettingsTable.$inferSelect;
export type InsertCalibrationSettings =
  typeof calibrationSettingsTable.$inferInsert;
