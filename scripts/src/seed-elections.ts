/**
 * Idempotent seed for REAL past election results used as ground truth for the
 * 실제 선거 검증 (election-grounded calibration) view.
 *
 * Source: 중앙선거관리위원회 제21대 대통령선거(2025-06-03) 공식 시·도별 개표 결과.
 * One row per 시·도, measuring the conservative bloc(국민의힘 김문수) 득표율 so the
 * synthetic population's turnout-weighted leaning prediction has a comparable
 * real-world target. `regionCode` references regions.code. `actualWinner` records
 * the bloc that actually placed first in that region (badges use this, not a
 * vote-share threshold — e.g. 강원·울산 the conservative candidate won with <50%).
 *
 * Idempotent: deletes all rows then re-inserts the canonical set. Safe to run
 * repeatedly (e.g. from the post-merge setup script).
 */
import { db, electionsTable, type InsertElection } from "@workspace/db";

const ELECTION_NAME = "제21대 대통령선거";
const ELECTION_TYPE = "대통령선거";
const ELECTION_DATE = "2025-06-03";
const METRIC = "보수 후보(김문수) 득표율";

/**
 * 시·도별 김문수(국민의힘) 공식 득표율 (%) + 실제 1위 진영. region_code = regions.code.
 */
const RESULTS: Record<string, { share: number; winner: "conservative" | "progressive" }> = {
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
};

const elections: InsertElection[] = Object.entries(RESULTS).map(
  ([regionCode, { share, winner }]) => ({
    name: ELECTION_NAME,
    electionType: ELECTION_TYPE,
    electionDate: ELECTION_DATE,
    regionCode,
    metric: METRIC,
    leaning: "conservative",
    actualValue: share,
    actualWinner: winner,
  }),
);

async function main(): Promise<void> {
  await db.transaction(async (tx) => {
    await tx.delete(electionsTable);
    await tx.insert(electionsTable).values(elections);
  });
  console.log(
    `Seeded ${elections.length} real election results (${ELECTION_NAME}, 시·도별 보수 득표율).`,
  );
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
