import { pgTable, serial, text, integer } from "drizzle-orm/pg-core";

export const simulationResponsesTable = pgTable("simulation_responses", {
  id: serial("id").primaryKey(),
  simulationId: integer("simulation_id").notNull(),
  agentId: integer("agent_id").notNull(),
  agentName: text("agent_name").notNull(),
  district: text("district").notNull(),
  ageBracket: text("age_bracket").notNull(),
  gender: text("gender").notNull(),
  politicalLeaning: integer("political_leaning").notNull().default(0),
  stance: text("stance").notNull(),
  score: integer("score").notNull(),
  confidence: integer("confidence").notNull(),
  reasoning: text("reasoning").notNull(),
});

export type SimulationResponse = typeof simulationResponsesTable.$inferSelect;
export type InsertSimulationResponse =
  typeof simulationResponsesTable.$inferInsert;
