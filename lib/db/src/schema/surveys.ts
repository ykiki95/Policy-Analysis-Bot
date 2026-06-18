import {
  pgTable,
  serial,
  text,
  integer,
  boolean,
  doublePrecision,
  jsonb,
  timestamp,
} from "drizzle-orm/pg-core";

export type SurveyDriver = {
  factor: string;
  issue: string;
  weight: number;
  direction: string;
  /**
   * Optional target stance (-100..100) the survey distribution implies for this
   * issue. When present, generation rakes the population's mean stance on the
   * issue toward this value (pull strength scales with weight × reliability).
   */
  targetStance?: number;
};

export const surveysTable = pgTable("surveys", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull(),
  title: text("title").notNull(),
  description: text("description").notNull(),
  methodology: text("methodology").notNull(),
  sampleSize: integer("sample_size").notNull(),
  fieldedDate: text("fielded_date").notNull(),
  status: text("status").notNull(),
  reliability: doublePrecision("reliability").notNull(),
  drivers: jsonb("drivers").$type<SurveyDriver[]>().notNull(),
  appliedToPopulation: boolean("applied_to_population").notNull().default(false),
  /**
   * Attitude domain this survey informs:
   * - "political": the 5 political issues (경제/복지/안보/환경/주거) → agent.issueStances
   * - "commercial": the 5 consumer axes (가격민감도/브랜드충성도/신제품수용/친환경소비/디지털소비) → agent.consumerStances
   * - "policy": the 5 policy axes (정부신뢰/정책수용성/증세수용/규제선호/공공서비스만족) → agent.policyStances
   */
  domain: text("domain").notNull().default("political"),
  /** True when the survey is a real published aggregate (vs. synthetic/illustrative). */
  isReal: boolean("is_real").notNull().default(false),
  /** Source attribution (real published surveys): publishing org. */
  sourceAgency: text("source_agency"),
  /** Source attribution: the published survey/report title. */
  sourceTitle: text("source_title"),
  /** Source attribution: fieldwork period, e.g. "2024-07-01 ~ 2024-07-23". */
  fieldPeriod: text("field_period"),
  /** Source attribution: public URL of the published aggregate. */
  sourceUrl: text("source_url"),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type Survey = typeof surveysTable.$inferSelect;
export type InsertSurvey = typeof surveysTable.$inferInsert;
