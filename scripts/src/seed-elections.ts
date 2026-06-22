/**
 * Idempotent seed for REAL past election results used as ground truth for the
 * 실제 선거 검증 (election-grounded calibration) view.
 *
 * Source: 중앙선거관리위원회 공식 시·도별 개표 결과 (data.go.kr 투·개표 API).
 * 두 대선을 백테스트 ground-truth로 시드한다:
 *   - 제21대 대통령선거 (2025-06-03) — 보수 = 국민의힘 김문수
 *   - 제20대 대통령선거 (2022-03-09) — 보수 = 국민의힘 윤석열
 * One row per 시·도 per election, measuring the conservative bloc 득표율 so the
 * synthetic population's turnout-weighted leaning prediction has a comparable
 * real-world target. `regionCode` references regions.code. `actualWinner` records
 * the bloc that actually placed first in that region (badges use this, not a
 * vote-share threshold — e.g. 강원·울산·대전 the conservative candidate placed
 * first with <50%).
 *
 * Idempotent: deletes all rows then re-inserts the canonical set. Safe to run
 * repeatedly (e.g. from the post-merge setup script).
 */
import { db, electionsTable, type InsertElection } from "@workspace/db";

type RegionResult = { share: number; winner: "conservative" | "progressive" };
type ElectionSeed = {
  name: string;
  electionType: string;
  electionDate: string;
  metric: string;
  results: Record<string, RegionResult>;
};

const ELECTIONS: ElectionSeed[] = [
  {
    name: "제21대 대통령선거",
    electionType: "대통령선거",
    electionDate: "2025-06-03",
    metric: "보수 후보(김문수) 득표율",
    // 시·도별 김문수(국민의힘) 공식 득표율 (%) + 실제 1위 진영.
    results: {
      "11": { share: 41.56, winner: "progressive" }, // 서울특별시
      "26": { share: 51.4, winner: "conservative" }, // 부산광역시
      "27": { share: 67.63, winner: "conservative" }, // 대구광역시
      "28": { share: 38.45, winner: "progressive" }, // 인천광역시
      "29": { share: 8.02, winner: "progressive" }, // 광주광역시
      "30": { share: 40.59, winner: "progressive" }, // 대전광역시
      "31": { share: 47.57, winner: "conservative" }, // 울산광역시
      "36": { share: 33.22, winner: "progressive" }, // 세종특별자치시
      "41": { share: 37.95, winner: "progressive" }, // 경기도
      "43": { share: 43.22, winner: "progressive" }, // 충청북도
      "44": { share: 43.27, winner: "progressive" }, // 충청남도
      "46": { share: 8.54, winner: "progressive" }, // 전라남도
      "47": { share: 66.87, winner: "conservative" }, // 경상북도
      "48": { share: 51.99, winner: "conservative" }, // 경상남도
      "50": { share: 34.79, winner: "progressive" }, // 제주특별자치도
      "51": { share: 47.31, winner: "conservative" }, // 강원특별자치도
      "52": { share: 10.9, winner: "progressive" }, // 전북특별자치도
    },
  },
  {
    name: "제20대 대통령선거",
    electionType: "대통령선거",
    electionDate: "2022-03-09",
    metric: "보수 후보(윤석열) 득표율",
    // 시·도별 윤석열(국민의힘) 공식 득표율 (%) + 실제 1위 진영 (data.go.kr).
    results: {
      "11": { share: 50.56, winner: "conservative" }, // 서울특별시
      "26": { share: 58.26, winner: "conservative" }, // 부산광역시
      "27": { share: 75.14, winner: "conservative" }, // 대구광역시
      "28": { share: 47.06, winner: "progressive" }, // 인천광역시
      "29": { share: 12.72, winner: "progressive" }, // 광주광역시
      "30": { share: 49.56, winner: "conservative" }, // 대전광역시 (1위, <50%)
      "31": { share: 54.41, winner: "conservative" }, // 울산광역시
      "36": { share: 44.15, winner: "progressive" }, // 세종특별자치시
      "41": { share: 45.62, winner: "progressive" }, // 경기도
      "43": { share: 50.67, winner: "conservative" }, // 충청북도
      "44": { share: 51.08, winner: "conservative" }, // 충청남도
      "46": { share: 11.45, winner: "progressive" }, // 전라남도
      "47": { share: 72.76, winner: "conservative" }, // 경상북도
      "48": { share: 58.25, winner: "conservative" }, // 경상남도
      "50": { share: 42.69, winner: "progressive" }, // 제주특별자치도
      "51": { share: 54.18, winner: "conservative" }, // 강원도
      "52": { share: 14.43, winner: "progressive" }, // 전라북도
    },
  },
];

const elections: InsertElection[] = ELECTIONS.flatMap((e) =>
  Object.entries(e.results).map(([regionCode, { share, winner }]) => ({
    name: e.name,
    electionType: e.electionType,
    electionDate: e.electionDate,
    regionCode,
    metric: e.metric,
    leaning: "conservative",
    actualValue: share,
    actualWinner: winner,
  })),
);

async function main(): Promise<void> {
  await db.transaction(async (tx) => {
    await tx.delete(electionsTable);
    await tx.insert(electionsTable).values(elections);
  });
  console.log(
    `Seeded ${elections.length} real election results across ${ELECTIONS.length} elections ` +
      `(${ELECTIONS.map((e) => e.name).join(", ")}).`,
  );
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
