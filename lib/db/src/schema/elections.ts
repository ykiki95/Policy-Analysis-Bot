import { pgTable, serial, text, doublePrecision } from "drizzle-orm/pg-core";

/**
 * Real past election results used as ground truth for calibration. One row per
 * (election × region × metric). `regionCode` references regions.code. `leaning`
 * is "conservative" | "progressive" — which bloc the metric measures, so the
 * generator can derive a comparable prediction from the synthetic population.
 * `actualWinner` ("conservative" | "progressive") is the bloc that actually
 * placed first in that region, independent of the metric value — e.g. 강원·울산
 * had the conservative candidate win with under 50%, so a >50% threshold would
 * mislabel them. Badges use `actualWinner`, not a vote-share cutoff.
 */
export const electionsTable = pgTable("elections", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  electionType: text("election_type").notNull(),
  electionDate: text("election_date").notNull(),
  regionCode: text("region_code").notNull(),
  metric: text("metric").notNull(),
  leaning: text("leaning").notNull(),
  actualValue: doublePrecision("actual_value").notNull(),
  actualWinner: text("actual_winner").notNull(),
});

export type Election = typeof electionsTable.$inferSelect;
export type InsertElection = typeof electionsTable.$inferInsert;
