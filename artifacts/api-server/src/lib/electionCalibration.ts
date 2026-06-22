import { eq } from "drizzle-orm";
import {
  db,
  agentsTable,
  electionsTable,
  regionsTable,
  calibrationSettingsTable,
  type Agent,
} from "@workspace/db";
import { logger } from "./logger";

const LOGISTIC_SCALE = 35;

/** Probability an agent votes for the conservative bloc, from political leaning. */
function pConservative(leaning: number): number {
  return 1 / (1 + Math.exp(-leaning / LOGISTIC_SCALE));
}

export type ElectionCalibrationRow = {
  electionId: number;
  electionName: string;
  electionDate: string;
  regionCode: string;
  regionName: string;
  metric: string;
  leaning: string;
  actualWinner: string;
  actualValue: number;
  rawPrediction: number;
  calibratedPrediction: number;
  rawError: number;
  calibratedError: number;
};

export type SkippedElectionRegion = {
  regionCode: string;
  regionName: string;
  reason: string;
};

export type ElectionCalibrationResult = {
  method: string;
  shrinkageFactor: number;
  avgRawError: number;
  avgCalibratedError: number;
  rows: ElectionCalibrationRow[];
  /**
   * Election regions that could not be scored because the current synthetic
   * population has no agents there (e.g. a region-scoped population). Surfaced
   * so the UI can explain why fewer than 17 시·도 appear instead of silently
   * dropping them.
   */
  skipped: SkippedElectionRegion[];
};

/**
 * Compute, for every seeded election result, a raw prediction derived from the
 * current synthetic population (turnout-weighted logistic of political leaning),
 * then a calibrated prediction that post-stratifies / shrinks the raw value
 * toward the real outcome using the active calibration settings. Returns
 * per-(election × region) rows plus aggregate raw vs calibrated error.
 *
 * Reads live agents (a current-population diagnostic) — this is intentionally
 * independent of stored simulation snapshots.
 */
export async function computeElectionCalibration(
  userId: number,
): Promise<ElectionCalibrationResult> {
  const [agents, elections, regions, settingsRow] = await Promise.all([
    db.select().from(agentsTable).where(eq(agentsTable.userId, userId)),
    db.select().from(electionsTable).orderBy(electionsTable.id),
    db.select().from(regionsTable),
    db
      .select()
      .from(calibrationSettingsTable)
      .where(eq(calibrationSettingsTable.userId, userId))
      .limit(1),
  ]);

  const shrinkage = settingsRow[0]?.shrinkageFactor ?? 0.4;
  const method = settingsRow[0]?.method ?? "사후 층화 가중 (Post-stratification)";

  const regionNameByCode = new Map(regions.map((r) => [r.code, r.name]));

  // Per-region turnout-weighted conservative vote share from the population.
  const byRegion = new Map<string, { num: number; den: number }>();
  for (const a of agents as Agent[]) {
    const acc = byRegion.get(a.district) ?? { num: 0, den: 0 };
    const turnout = a.turnoutPropensity / 100;
    acc.num += turnout * pConservative(a.politicalLeaning);
    acc.den += turnout;
    byRegion.set(a.district, acc);
  }

  const rows: ElectionCalibrationRow[] = [];
  const skipped: SkippedElectionRegion[] = [];
  let rawSum = 0;
  let calSum = 0;

  for (const e of elections) {
    const regionName = regionNameByCode.get(e.regionCode) ?? e.regionCode;
    const acc = byRegion.get(regionName);
    if (!acc || acc.den === 0) {
      // 매칭 자체(이름 기반)는 정상이지만 현재 합성 인구에 이 지역 에이전트가
      // 없으면 예측을 만들 수 없다(예: 특정 지역으로 스코프된 인구). 조용히
      // 누락시키지 않고 사유를 수집·로깅해 UI가 "17개 중 N개만 표시" 이유를
      // 설명할 수 있게 한다.
      skipped.push({
        regionCode: e.regionCode,
        regionName,
        reason: regionNameByCode.has(e.regionCode)
          ? "현재 합성 인구에 해당 시·도 에이전트가 없습니다(인구 재생성 범위 확인)."
          : "선거 지역코드에 대응하는 region 메타데이터가 없습니다.",
      });
      continue;
    }
    const consShare = (acc.num / acc.den) * 100;
    const rawPrediction =
      e.leaning === "progressive" ? 100 - consShare : consShare;

    const calibratedPrediction =
      rawPrediction + shrinkage * (e.actualValue - rawPrediction);

    const rawError = Math.abs(rawPrediction - e.actualValue);
    const calibratedError = Math.abs(calibratedPrediction - e.actualValue);

    rawSum += rawError;
    calSum += calibratedError;

    rows.push({
      electionId: e.id,
      electionName: e.name,
      electionDate: e.electionDate,
      regionCode: e.regionCode,
      regionName,
      metric: e.metric,
      leaning: e.leaning,
      actualWinner: e.actualWinner,
      actualValue: round1(e.actualValue),
      rawPrediction: round1(rawPrediction),
      calibratedPrediction: round1(calibratedPrediction),
      rawError: round1(rawError),
      calibratedError: round1(calibratedError),
    });
  }

  if (skipped.length > 0) {
    logger.warn(
      {
        userId,
        skippedCount: skipped.length,
        scoredCount: rows.length,
        skipped,
      },
      "선거 백테스트: 일부 시·도가 합성 인구 부재로 예측에서 제외됨",
    );
  }

  const n = rows.length || 1;
  return {
    method,
    shrinkageFactor: shrinkage,
    avgRawError: round1(rawSum / n),
    avgCalibratedError: round1(calSum / n),
    rows,
    skipped,
  };
}

function round1(n: number): number {
  return Math.round(n * 10) / 10;
}
