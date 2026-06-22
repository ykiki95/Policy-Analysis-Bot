import {
  pgTable,
  serial,
  text,
  integer,
  doublePrecision,
  timestamp,
} from "drizzle-orm/pg-core";

/**
 * 신호 인제스트 배치(데모). 뉴스·검색트렌드·SNS 신호를 배치로 "수집"한 기록.
 * 영속화/CRUD 는 실제이지만 효과 수치(sentiment, valueBefore/After)는
 * 결정론적 목업/시드값이다 — 실제 스크래핑·외부 API 수집은 하지 않는다.
 */
export const signalBatchesTable = pgTable("signal_batches", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull(),
  /** '뉴스' | '검색트렌드' | 'SNS·커뮤니티' */
  source: text("source").notNull(),
  title: text("title").notNull(),
  collectedAt: timestamp("collected_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
  /** 수집 건수 */
  itemCount: integer("item_count").notNull(),
  /** 감성 분포(합 100) */
  sentimentPos: integer("sentiment_pos").notNull(),
  sentimentNeu: integer("sentiment_neu").notNull(),
  sentimentNeg: integer("sentiment_neg").notNull(),
  /** 사전 작성된 LLM풍 요약 2~3문장 */
  summary: text("summary").notNull(),
  /** 'Lumen' | 'Seraph' | 'Dynamo' */
  linkedProduct: text("linked_product").notNull(),
  /** 연결된 시뮬레이션(있을 때만) */
  linkedSimulationId: integer("linked_simulation_id"),
  /** 예: "지지율(%)" */
  metric: text("metric").notNull(),
  /** delta = valueAfter - valueBefore (계산값) */
  valueBefore: doublePrecision("value_before").notNull(),
  valueAfter: doublePrecision("value_after").notNull(),
  /** '수집중' | '완료' (기본 '완료') */
  status: text("status").notNull().default("완료"),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type SignalBatch = typeof signalBatchesTable.$inferSelect;
export type InsertSignalBatch = typeof signalBatchesTable.$inferInsert;
