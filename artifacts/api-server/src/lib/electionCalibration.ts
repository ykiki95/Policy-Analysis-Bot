import { eq } from "drizzle-orm";
import {
  db,
  agentsTable,
  electionsTable,
  regionsTable,
  calibrationSettingsTable,
  type Agent,
} from "@workspace/db";

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
  actualValue: number;
  rawPrediction: number;
  calibratedPrediction: number;
  rawError: number;
  calibratedError: number;
};

export type ElectionCalibrationResult = {
  method: string;
  shrinkageFactor: number;
  avgRawError: number;
  avgCalibratedError: number;
  rows: ElectionCalibrationRow[];
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
  let rawSum = 0;
  let calSum = 0;

  for (const e of elections) {
    const regionName = regionNameByCode.get(e.regionCode) ?? e.regionCode;
    const acc = byRegion.get(regionName);
    if (!acc || acc.den === 0) continue;
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
      actualValue: round1(e.actualValue),
      rawPrediction: round1(rawPrediction),
      calibratedPrediction: round1(calibratedPrediction),
      rawError: round1(rawError),
      calibratedError: round1(calibratedError),
    });
  }

  const n = rows.length || 1;
  return {
    method,
    shrinkageFactor: shrinkage,
    avgRawError: round1(rawSum / n),
    avgCalibratedError: round1(calSum / n),
    rows,
  };
}

function round1(n: number): number {
  return Math.round(n * 10) / 10;
}
