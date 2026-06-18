import {
  pgTable,
  serial,
  text,
  integer,
  jsonb,
  uniqueIndex,
} from "drizzle-orm/pg-core";
import type { AgentPolicyStances } from "./agents";

export const simulationResponsesTable = pgTable(
  "simulation_responses",
  {
    id: serial("id").primaryKey(),
    simulationId: integer("simulation_id").notNull(),
    agentId: integer("agent_id").notNull(),
    agentName: text("agent_name").notNull(),
    district: text("district").notNull(),
    ageBracket: text("age_bracket").notNull(),
    gender: text("gender").notNull(),
    politicalLeaning: integer("political_leaning").notNull().default(0),
    /**
     * Policy-attitude snapshot (정부신뢰/정책수용성/증세수용/규제선호/공공서비스만족)
     * captured at response time for Seraph (policy) simulations so policy-axis
     * cross-analysis stays stable across population regeneration. Null for
     * non-policy simulations.
     */
    policyStances: jsonb("policy_stances").$type<AgentPolicyStances>(),
    stance: text("stance").notNull(),
    score: integer("score").notNull(),
    confidence: integer("confidence").notNull(),
    reasoning: text("reasoning").notNull(),
  },
  (t) => [
    // 내구성 있는 증분 저장의 핵심: 에이전트별 응답을 실행 중 즉시 insert 하고
    // 재개(resume) 시 onConflictDoNothing 으로 중복을 막는다.
    uniqueIndex("sim_responses_sim_agent_uq").on(t.simulationId, t.agentId),
  ],
);

export type SimulationResponse = typeof simulationResponsesTable.$inferSelect;
export type InsertSimulationResponse =
  typeof simulationResponsesTable.$inferInsert;
