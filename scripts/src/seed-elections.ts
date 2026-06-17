/**
 * Idempotent seed for REAL past election results used as ground truth for the
 * 실제 선거 검증 (election-grounded calibration) view.
 *
 * Source: 중앙선거관리위원회 제20대 대통령선거(2022-03-09) 공식 시·도별 개표 결과.
 * One row per 시·도, measuring the conservative bloc(국민의힘 윤석열) 득표율 so the
 * synthetic population's turnout-weighted leaning prediction has a comparable
 * real-world target. `regionCode` references regions.code.
 *
 * Idempotent: deletes all rows then re-inserts the canonical set. Safe to run
 * repeatedly (e.g. from the post-merge setup script).
 */
import { db, electionsTable, type InsertElection } from "@workspace/db";

const ELECTION_NAME = "제20대 대통령선거";
const ELECTION_TYPE = "대통령선거";
const ELECTION_DATE = "2022-03-09";
const METRIC = "보수 후보(윤석열) 득표율";

/** 시·도별 윤석열(국민의힘) 공식 득표율 (%). region_code = regions.code. */
const CONSERVATIVE_VOTE_SHARE: Record<string, number> = {
  "11": 50.56, // 서울특별시
  "26": 58.25, // 부산광역시
  "27": 75.14, // 대구광역시
  "28": 47.05, // 인천광역시
  "29": 12.72, // 광주광역시
  "30": 49.55, // 대전광역시
  "31": 54.41, // 울산광역시
  "36": 44.14, // 세종특별자치시
  "41": 45.62, // 경기도
  "43": 50.67, // 충청북도
  "44": 51.08, // 충청남도
  "46": 11.44, // 전라남도
  "47": 72.76, // 경상북도
  "48": 58.24, // 경상남도
  "50": 42.69, // 제주특별자치도
  "51": 54.18, // 강원특별자치도
  "52": 14.42, // 전북특별자치도
};

const elections: InsertElection[] = Object.entries(CONSERVATIVE_VOTE_SHARE).map(
  ([regionCode, actualValue]) => ({
    name: ELECTION_NAME,
    electionType: ELECTION_TYPE,
    electionDate: ELECTION_DATE,
    regionCode,
    metric: METRIC,
    leaning: "conservative",
    actualValue,
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
