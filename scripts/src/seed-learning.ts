/**
 * Idempotent seed for the 자동 자가학습 루프 (self-learning loop) demo view.
 *
 * Seeds an illustrative accuracy trend (accuracy_snapshots) + sample learning
 * contributions (learning_contributions) + contributor reputation rows so the
 * "전역 합성인구가 얼마나 현실에 가까워졌나" 화면 has a compelling story out of
 * the box. The trend rises from ~78% to ~86% 현실 일치도 over 6 cycles.
 *
 * The latest snapshot keeps offsets at 0 so that a real admin-run cycle
 * (applyOffsetsAndSnapshot) measures continuously around the real election-grounded
 * error (~13.7%p → accuracy 86.3%) without a jarring jump.
 *
 * Idempotent: skips entirely if any accuracy_snapshots already exist, so it is
 * safe to run repeatedly from the post-merge setup script.
 */
import {
  db,
  accuracySnapshotsTable,
  learningContributionsTable,
  contributorReputationTable,
  type InsertAccuracySnapshot,
  type InsertLearningContribution,
} from "@workspace/db";

const GLOBAL_LEARNING_USER_ID = 0;

function daysAgo(n: number): Date {
  return new Date(Date.now() - n * 86_400_000);
}

const SNAPSHOTS: (Omit<InsertAccuracySnapshot, "createdAt"> & { days: number })[] =
  [
    { cycle: 1, rawError: 22.0, calibratedError: 13.2, accuracy: 78.0, politicalError: 22.0, consumerError: 14.0, policyError: 13.5, contributionsApplied: 0, contributionsFlagged: 1, populationSize: 800, offsetPolitical: 0, offsetConsumer: 0, offsetPolicy: 0, days: 30 },
    { cycle: 2, rawError: 19.4, calibratedError: 11.6, accuracy: 80.6, politicalError: 19.4, consumerError: 12.6, policyError: 12.0, contributionsApplied: 2, contributionsFlagged: 1, populationSize: 800, offsetPolitical: 2.5, offsetConsumer: 1.5, offsetPolicy: 1.0, days: 25 },
    { cycle: 3, rawError: 17.1, calibratedError: 10.3, accuracy: 82.9, politicalError: 17.1, consumerError: 10.8, policyError: 10.4, contributionsApplied: 3, contributionsFlagged: 0, populationSize: 800, offsetPolitical: 4.0, offsetConsumer: 3.0, offsetPolicy: 2.5, days: 18 },
    { cycle: 4, rawError: 15.6, calibratedError: 9.4, accuracy: 84.4, politicalError: 15.6, consumerError: 9.2, policyError: 8.9, contributionsApplied: 2, contributionsFlagged: 1, populationSize: 800, offsetPolitical: 5.0, offsetConsumer: 4.5, offsetPolicy: 3.5, days: 11 },
    { cycle: 5, rawError: 14.4, calibratedError: 8.6, accuracy: 85.6, politicalError: 14.4, consumerError: 7.8, policyError: 7.4, contributionsApplied: 4, contributionsFlagged: 0, populationSize: 800, offsetPolitical: 4.0, offsetConsumer: 5.5, offsetPolicy: 4.5, days: 5 },
    { cycle: 6, rawError: 13.7, calibratedError: 8.2, accuracy: 86.3, politicalError: 13.7, consumerError: 6.9, policyError: 6.5, contributionsApplied: 3, contributionsFlagged: 1, populationSize: 800, offsetPolitical: 0, offsetConsumer: 0, offsetPolicy: 0, days: 1 },
  ];

const CONTRIBUTIONS: (Omit<
  InsertLearningContribution,
  "createdAt" | "evaluatedAt"
> & { createdDays: number; evalDays: number | null })[] = [
  { userId: 1, domain: "political", product: "Dynamo", title: "21대 대선 서울 보수 득표율 백테스트", observedValue: 50.6, predictedValue: 48.9, bias: 1.7, proposedOffset: 2.4, sampleSize: 1500, status: "promoted", qualityScore: 0.96, accuracyDelta: -1.8, decidedBy: "auto", flagReason: null, createdDays: 26, evalDays: 25 },
  { userId: GLOBAL_LEARNING_USER_ID, domain: "commercial", product: "Lumen", title: "신제품 구매의향 조사(서울 2030)", observedValue: 41.2, predictedValue: 38.5, bias: 2.7, proposedOffset: 2.7, sampleSize: 900, status: "promoted", qualityScore: 0.93, accuracyDelta: -1.2, decidedBy: "auto", flagReason: null, createdDays: 19, evalDays: 18 },
  { userId: 1, domain: "policy", product: "Seraph", title: "기본소득 정책 수용도 패널", observedValue: 36.0, predictedValue: 33.4, bias: 2.6, proposedOffset: 2.6, sampleSize: 1100, status: "promoted", qualityScore: 0.94, accuracyDelta: -0.9, decidedBy: "auto", flagReason: null, createdDays: 12, evalDays: 11 },
  { userId: 1, domain: "commercial", product: "Lumen", title: "프리미엄 요금제 전환의향(소표본)", observedValue: 28.0, predictedValue: 24.0, bias: 4.0, proposedOffset: 4.0, sampleSize: 220, status: "promoted", qualityScore: 0.7, accuracyDelta: -0.4, decidedBy: "admin", flagReason: null, createdDays: 6, evalDays: 5 },
  { userId: 1, domain: "political", product: "Dynamo", title: "단일 동(洞) 출구조사(표본 과소)", observedValue: 71.0, predictedValue: 49.0, bias: 22.0, proposedOffset: 25, sampleSize: 35, status: "flagged", qualityScore: 0.1, accuracyDelta: null, decidedBy: null, flagReason: "예측 대비 편향이 과도합니다(>40%p) — 이상치 의심.", createdDays: 3, evalDays: 2 },
  { userId: GLOBAL_LEARNING_USER_ID, domain: "political", product: "Dynamo", title: "커뮤니티 여론 스크랩(편향 의심)", observedValue: 44.0, predictedValue: 49.0, bias: -5.0, proposedOffset: -7.0, sampleSize: 600, status: "quarantined", qualityScore: 0.5, accuracyDelta: null, decidedBy: "auto", flagReason: "검증 게이트에서 정확도를 개선하지 못했습니다.", createdDays: 2, evalDays: 1 },
  { userId: 1, domain: "policy", product: "Seraph", title: "규제 신설 찬반 설문(진행 중)", observedValue: 47.5, predictedValue: 45.0, bias: 2.5, proposedOffset: 2.5, sampleSize: 800, status: "candidate", qualityScore: 0.9, accuracyDelta: null, decidedBy: null, flagReason: null, createdDays: 31, evalDays: null },
];

async function main() {
  const existing = await db.select().from(accuracySnapshotsTable).limit(1);
  if (existing.length > 0) {
    console.log("자가학습 스냅샷이 이미 존재합니다 — 시드 건너뜀.");
    return;
  }

  for (const { days, ...snap } of SNAPSHOTS) {
    await db
      .insert(accuracySnapshotsTable)
      .values({ ...snap, createdAt: daysAgo(days) });
  }

  for (const { createdDays, evalDays, ...c } of CONTRIBUTIONS) {
    await db.insert(learningContributionsTable).values({
      ...c,
      createdAt: daysAgo(createdDays),
      evaluatedAt: evalDays == null ? null : daysAgo(evalDays),
    });
  }

  await db
    .insert(contributorReputationTable)
    .values([
      { userId: 1, contributions: 5, helpful: 3, harmful: 1, reputation: 1.4 },
      { userId: 0, contributions: 3, helpful: 2, harmful: 1, reputation: 1.2 },
    ])
    .onConflictDoNothing();

  console.log(
    `자가학습 시드 완료: 스냅샷 ${SNAPSHOTS.length}개, 기여 ${CONTRIBUTIONS.length}개.`,
  );
}

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
