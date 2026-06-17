import { pgTable, serial, text, integer } from "drizzle-orm/pg-core";

/**
 * Official public-statistics marginal distributions used as IPF/raking targets.
 * Stored per dimension so the generator can fit a (region × age × gender) joint
 * from the marginals. `dimension` ∈ {region, age, gender}; `key` is the category
 * value (region code, age bracket label, or "Male"/"Female").
 */
export const demographicMarginsTable = pgTable("demographic_margins", {
  id: serial("id").primaryKey(),
  dimension: text("dimension").notNull(),
  key: text("key").notNull(),
  label: text("label").notNull(),
  population: integer("population").notNull(),
});

export type DemographicMargin = typeof demographicMarginsTable.$inferSelect;
export type InsertDemographicMargin =
  typeof demographicMarginsTable.$inferInsert;
