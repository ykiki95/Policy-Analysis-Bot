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
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
  completedAt: timestamp("completed_at", { withTimezone: true }),
});

export type Simulation = typeof simulationsTable.$inferSelect;
export type InsertSimulation = typeof simulationsTable.$inferInsert;
