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
};

export const surveysTable = pgTable("surveys", {
  id: serial("id").primaryKey(),
  title: text("title").notNull(),
  description: text("description").notNull(),
  methodology: text("methodology").notNull(),
  sampleSize: integer("sample_size").notNull(),
  fieldedDate: text("fielded_date").notNull(),
  status: text("status").notNull(),
  reliability: doublePrecision("reliability").notNull(),
  drivers: jsonb("drivers").$type<SurveyDriver[]>().notNull(),
  appliedToPopulation: boolean("applied_to_population").notNull().default(false),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type Survey = typeof surveysTable.$inferSelect;
export type InsertSurvey = typeof surveysTable.$inferInsert;
