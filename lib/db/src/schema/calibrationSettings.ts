import {
  pgTable,
  serial,
  text,
  doublePrecision,
  timestamp,
} from "drizzle-orm/pg-core";

export const calibrationSettingsTable = pgTable("calibration_settings", {
  id: serial("id").primaryKey(),
  method: text("method").notNull(),
  benchmarkWeight: doublePrecision("benchmark_weight").notNull(),
  recencyWeight: doublePrecision("recency_weight").notNull(),
  shrinkageFactor: doublePrecision("shrinkage_factor").notNull(),
  outlierTrimPct: doublePrecision("outlier_trim_pct").notNull(),
  description: text("description").notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type CalibrationSettings = typeof calibrationSettingsTable.$inferSelect;
export type InsertCalibrationSettings =
  typeof calibrationSettingsTable.$inferInsert;
