import {
  pgTable,
  serial,
  text,
  integer,
  doublePrecision,
  timestamp,
} from "drizzle-orm/pg-core";

/**
 * 자동 자가학습 루프의 "후보 학습 기여".
 * 사용자(또는 관리자)가 관찰한 현실 신호(설문·백테스트·시장 관찰)를 제출하면 후보로
 * 쌓이고, 자동 게이트가 강건 집계 + 현실(선거) ground-truth 검증으로 승격/격리한다.
 *
 * status:
 *  - candidate   : 제출됨, 아직 평가 전
 *  - promoted    : 자동 게이트 통과 → 전역 합성인구 기준선에 반영됨
 *  - quarantined : 검증에서 오차를 늘려 자동 격리(전역 반영 안 됨)
 *  - flagged     : 정합성 이상치 → 관리자 수동 검토 대기
 *  - rejected    : 관리자가 거부
 */
export const learningContributionsTable = pgTable("learning_contributions", {
  id: serial("id").primaryKey(),
  /** 기여자 userId. 전역(관리자 큐레이션)은 0. */
  userId: integer("user_id").notNull(),
  /** 'political' | 'commercial' | 'policy' */
  domain: text("domain").notNull(),
  /** 'Dynamo' | 'Lumen' | 'Seraph' (domain 파생, 표시용) */
  product: text("product").notNull(),
  title: text("title").notNull(),
  /** 사용자가 관찰한 현실 값(지지·찬성·수용률 %). */
  observedValue: doublePrecision("observed_value").notNull(),
  /** 제출 시점 합성인구의 예측 값(%). */
  predictedValue: doublePrecision("predicted_value").notNull(),
  /** observed - predicted. */
  bias: doublePrecision("bias").notNull(),
  /** 이 기여가 함의하는 기준선 이동 후보(정치=leaning 단위, 소비·정책=stance 단위). */
  proposedOffset: doublePrecision("proposed_offset").notNull(),
  /** 신뢰도 가중용 표본 크기. */
  sampleSize: integer("sample_size").notNull().default(0),
  status: text("status").notNull().default("candidate"),
  /** 0..1 정합성/합의 점수. */
  qualityScore: doublePrecision("quality_score").notNull().default(0),
  /** 검증 후 측정된 ground-truth 오차 변화(음수=개선). null=미평가. */
  accuracyDelta: doublePrecision("accuracy_delta"),
  /** 'auto' | 'admin' | null */
  decidedBy: text("decided_by"),
  /** 격리/플래그 사유. */
  flagReason: text("flag_reason"),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
  evaluatedAt: timestamp("evaluated_at", { withTimezone: true }),
});

export type LearningContribution =
  typeof learningContributionsTable.$inferSelect;
export type InsertLearningContribution =
  typeof learningContributionsTable.$inferInsert;
