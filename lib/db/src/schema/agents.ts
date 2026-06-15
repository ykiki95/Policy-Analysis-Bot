import {
  pgTable,
  serial,
  text,
  integer,
  doublePrecision,
  jsonb,
} from "drizzle-orm/pg-core";

export type AgentIssueStances = {
  economy: number;
  welfare: number;
  security: number;
  environment: number;
  housing: number;
};

export const agentsTable = pgTable("agents", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  age: integer("age").notNull(),
  ageBracket: text("age_bracket").notNull(),
  gender: text("gender").notNull(),
  district: text("district").notNull(),
  lat: doublePrecision("lat").notNull(),
  lng: doublePrecision("lng").notNull(),
  education: text("education").notNull(),
  incomeBracket: text("income_bracket").notNull(),
  occupation: text("occupation").notNull(),
  householdType: text("household_type").notNull(),
  politicalLeaning: integer("political_leaning").notNull(),
  partyAffinity: text("party_affinity").notNull(),
  turnoutPropensity: integer("turnout_propensity").notNull(),
  issueStances: jsonb("issue_stances").$type<AgentIssueStances>().notNull(),
  mediaDiet: text("media_diet").notNull(),
  values: text("values").array().notNull(),
  personaSummary: text("persona_summary").notNull(),
});

export type Agent = typeof agentsTable.$inferSelect;
export type InsertAgent = typeof agentsTable.$inferInsert;
