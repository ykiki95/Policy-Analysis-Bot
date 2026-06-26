import {
  pgTable,
  serial,
  integer,
  doublePrecision,
  timestamp,
} from "drizzle-orm/pg-core";

/**
 * 자가학습 사이클마다 기록하는 전역 합성인구의 "현실 일치도" 스냅샷.
 * 시간에 따라 현실(선거 ground-truth) 대비 오차가 줄고 정확도가 오르는 추이를
 * 화면에 그리기 위한 시계열. 누적 auto offset도 함께 저장해 buildGenerationInputs가
 * 전역 인구 재생성 시 반영한다.
 */
export const accuracySnapshotsTable = pgTable("accuracy_snapshots", {
  id: serial("id").primaryKey(),
  /** 사이클 번호(1부터 증가). */
  cycle: integer("cycle").notNull(),
  /** 선거 ground-truth 대비 평균 원시 오차(%p). */
  rawError: doublePrecision("raw_error").notNull(),
  /** 보정 후 평균 오차(%p). */
  calibratedError: doublePrecision("calibrated_error").notNull(),
  /** 현실 일치도(=100-rawError, clamp). */
  accuracy: doublePrecision("accuracy").notNull(),
  /** 도메인별 오차(%p). 정치는 선거 ground-truth, 소비·정책은 합의 기반 추정. */
  politicalError: doublePrecision("political_error").notNull(),
  consumerError: doublePrecision("consumer_error").notNull(),
  policyError: doublePrecision("policy_error").notNull(),
  /** 이 사이클에 자동 승격된 기여 수. */
  contributionsApplied: integer("contributions_applied").notNull().default(0),
  /** 이 사이클에 격리/플래그된 기여 수. */
  contributionsFlagged: integer("contributions_flagged").notNull().default(0),
  /** 평가 시점 전역 인구 규모. */
  populationSize: integer("population_size").notNull().default(0),
  /** 누적 auto offset(전역 인구 기준선 이동량). */
  offsetPolitical: doublePrecision("offset_political").notNull().default(0),
  offsetConsumer: doublePrecision("offset_consumer").notNull().default(0),
  offsetPolicy: doublePrecision("offset_policy").notNull().default(0),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type AccuracySnapshot = typeof accuracySnapshotsTable.$inferSelect;
export type InsertAccuracySnapshot = typeof accuracySnapshotsTable.$inferInsert;
