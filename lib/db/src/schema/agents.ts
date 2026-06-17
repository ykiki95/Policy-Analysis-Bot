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

/** Consumer/commercial attitude axes (0..100) used by the Lumen product line. */
export type AgentConsumerStances = {
  /** 가격민감도 — higher = more price-sensitive / deal-seeking. */
  priceSensitivity: number;
  /** 브랜드충성도 — higher = more loyal to known brands. */
  brandLoyalty: number;
  /** 신제품수용 — higher = quicker to adopt new products/tech. */
  noveltySeeking: number;
  /** 친환경소비 — higher = prioritizes eco-friendly consumption. */
  ecoConsciousness: number;
  /** 디지털소비 — higher = shops/consumes more via digital channels. */
  digitalConsumption: number;
};

export const DEFAULT_CONSUMER_STANCES: AgentConsumerStances = {
  priceSensitivity: 50,
  brandLoyalty: 50,
  noveltySeeking: 50,
  ecoConsciousness: 50,
  digitalConsumption: 50,
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
  consumerStances: jsonb("consumer_stances")
    .$type<AgentConsumerStances>()
    .notNull()
    .default(DEFAULT_CONSUMER_STANCES),
  mediaDiet: text("media_diet").notNull(),
  values: text("values").array().notNull(),
  personaSummary: text("persona_summary").notNull(),
});

export type Agent = typeof agentsTable.$inferSelect;
export type InsertAgent = typeof agentsTable.$inferInsert;
