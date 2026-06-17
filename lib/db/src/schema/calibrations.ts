import { pgTable, serial, text, doublePrecision } from "drizzle-orm/pg-core";

export const calibrationsTable = pgTable("calibrations", {
  id: serial("id").primaryKey(),
  title: text("title").notNull(),
  // 제품 라인: 'Lumen' | 'Seraph' | 'Dynamo'. 기존 행 백필용 기본값 Dynamo.
  product: text("product").notNull().default("Dynamo"),
  eventType: text("event_type").notNull(),
  targetDate: text("target_date").notNull(),
  metric: text("metric").notNull(),
  actualValue: doublePrecision("actual_value").notNull(),
  rawPrediction: doublePrecision("raw_prediction").notNull(),
  calibratedPrediction: doublePrecision("calibrated_prediction").notNull(),
  rawError: doublePrecision("raw_error").notNull(),
  calibratedError: doublePrecision("calibrated_error").notNull(),
  method: text("method").notNull(),
});

export type Calibration = typeof calibrationsTable.$inferSelect;
export type InsertCalibration = typeof calibrationsTable.$inferInsert;
