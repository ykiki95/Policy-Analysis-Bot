import {
  pgTable,
  integer,
  doublePrecision,
  timestamp,
} from "drizzle-orm/pg-core";

/**
 * 기여자 평판. 과거 기여가 현실 정확도를 높였으면 가중치를 더, 오염원이면 덜 준다.
 * 강건 집계 시 reputation 을 가중치로 사용해 악의적/부정확한 기여의 영향을 자동 축소.
 */
export const contributorReputationTable = pgTable("contributor_reputation", {
  userId: integer("user_id").primaryKey(),
  /** 총 평가된 기여 수. */
  contributions: integer("contributions").notNull().default(0),
  /** 정확도를 높인(유익) 기여 수. */
  helpful: integer("helpful").notNull().default(0),
  /** 정확도를 낮춘(유해) 기여 수. */
  harmful: integer("harmful").notNull().default(0),
  /** 집계 가중 배수(0.2..2.0). 기본 1.0. */
  reputation: doublePrecision("reputation").notNull().default(1),
  updatedAt: timestamp("updated_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type ContributorReputation =
  typeof contributorReputationTable.$inferSelect;
export type InsertContributorReputation =
  typeof contributorReputationTable.$inferInsert;
