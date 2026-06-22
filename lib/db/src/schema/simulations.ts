import {
  pgTable,
  serial,
  text,
  integer,
  doublePrecision,
  timestamp,
} from "drizzle-orm/pg-core";

export const simulationsTable = pgTable("simulations", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull(),
  title: text("title").notNull(),
  audience: text("audience").notNull(),
  product: text("product").notNull(),
  policyText: text("policy_text").notNull(),
  model: text("model").notNull(),
  status: text("status").notNull().default("pending"),
  progress: integer("progress").notNull().default(0),
  totalAgents: integer("total_agents").notNull(),
  costEstimateUsd: doublePrecision("cost_estimate_usd").notNull(),
  costActualUsd: doublePrecision("cost_actual_usd"),
  overallSupport: doublePrecision("overall_support"),
  supportPct: doublePrecision("support_pct"),
  opposePct: doublePrecision("oppose_pct"),
  neutralPct: doublePrecision("neutral_pct"),
  summary: text("summary"),
  // 예측→실제→학습 라이프사이클.
  // 완료(finalize) 시 자동 기록: predictionLockedAt(예측 확정 시각), predictionValue(이 시뮬레이션이
  // 예측하는 핵심 지표 = supportPct, 잠금 후 불변). 이후 관리자/사용자가 actualValue(실제 관측치)를
  // 입력하면 predictionError=|prediction−actual|. learn 실행 시 calibration 이벤트 생성 + learnedAt 기록.
  predictionLockedAt: timestamp("prediction_locked_at", { withTimezone: true }),
  predictionValue: doublePrecision("prediction_value"),
  actualValue: doublePrecision("actual_value"),
  actualMetric: text("actual_metric"),
  actualEnteredAt: timestamp("actual_entered_at", { withTimezone: true }),
  predictionError: doublePrecision("prediction_error"),
  learnedAt: timestamp("learned_at", { withTimezone: true }),
  // 워커 분리(durable job): 단일 active 러너 보장을 위한 DB lease.
  // status='queued' 작업을 워커가 원자적으로 claim(lockedBy/lockedAt 설정)→running,
  // 실행 중 heartbeatAt 주기 갱신. heartbeat 만료(stale) 시 다른 워커가 회수한다.
  lockedBy: text("locked_by"),
  lockedAt: timestamp("locked_at", { withTimezone: true }),
  heartbeatAt: timestamp("heartbeat_at", { withTimezone: true }),
  lastError: text("last_error"),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
  completedAt: timestamp("completed_at", { withTimezone: true }),
});

export type Simulation = typeof simulationsTable.$inferSelect;
export type InsertSimulation = typeof simulationsTable.$inferInsert;
