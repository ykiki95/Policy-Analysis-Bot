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

/** Policy/government attitude axes (0..100) used by the Seraph product line. */
export type AgentPolicyStances = {
  /** 정부신뢰 — higher = more trust in government/public institutions. */
  governmentTrust: number;
  /** 정책수용성 — higher = more willing to accept/comply with new policy. */
  policyAcceptance: number;
  /** 증세수용 — higher = more willing to pay higher taxes for public services. */
  taxTolerance: number;
  /** 규제선호 — higher = prefers stronger government regulation over deregulation. */
  regulationPreference: number;
  /** 공공서비스만족 — higher = more satisfied with public services. */
  publicServiceSatisfaction: number;
};

export const DEFAULT_POLICY_STANCES: AgentPolicyStances = {
  governmentTrust: 50,
  policyAcceptance: 50,
  taxTolerance: 50,
  regulationPreference: 50,
  publicServiceSatisfaction: 50,
};

export const agentsTable = pgTable("agents", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull(),
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
  policyStances: jsonb("policy_stances")
    .$type<AgentPolicyStances>()
    .notNull()
    .default(DEFAULT_POLICY_STANCES),
  mediaDiet: text("media_diet").notNull(),
  values: text("values").array().notNull(),
  personaSummary: text("persona_summary").notNull(),
});

export type Agent = typeof agentsTable.$inferSelect;
export type InsertAgent = typeof agentsTable.$inferInsert;
