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
