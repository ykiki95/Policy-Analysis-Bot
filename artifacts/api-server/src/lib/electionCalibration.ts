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
import { GLOBAL_LEARNING_USER_ID } from "./tenant";

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

/**
 * 한 선거(예: 제21대 대선)에 대한 백테스트 결과 묶음. 시·도별 행 + 그 선거의 평균
 * 원시·보정 오차 + 합성 인구 부재로 제외된 시·도 목록을 담는다. 프런트는 선거별로
 * 선택/비교한다.
 */
export type ElectionCalibrationGroup = {
  /** 대표 election 행 id(해당 선거 첫 행) — React key 등 식별용. */
  electionId: number;
  electionName: string;
  electionDate: string;
  avgRawError: number;
  avgCalibratedError: number;
  rows: ElectionCalibrationRow[];
  skipped: SkippedElectionRegion[];
};

export type ElectionCalibrationResult = {
  method: string;
  shrinkageFactor: number;
  /** 선거별 백테스트 묶음. 최신 선거가 먼저 오도록 electionDate 내림차순 정렬. */
  elections: ElectionCalibrationGroup[];
};

/**
 * 시드된 모든 실제 선거 결과에 대해, 현재 합성 인구로부터 원시 예측(투표 의향 가중
 * 로지스틱)을 만들고, 활성 보정 설정으로 실제 결과 쪽으로 축소(shrinkage)한 보정
 * 예측을 함께 계산한다. 결과를 선거별로 묶어 시·도 행 + 평균 원시/보정 오차를 반환한다.
 *
 * 라이브 agents(현재 인구 진단)를 읽는다 — 저장된 시뮬레이션 스냅샷과 의도적으로 독립.
 */
export async function computeElectionCalibration(): Promise<ElectionCalibrationResult> {
  const [agents, elections, regions, settingsRow] = await Promise.all([
    db
      .select()
      .from(agentsTable)
      .where(eq(agentsTable.userId, GLOBAL_LEARNING_USER_ID)),
    db.select().from(electionsTable).orderBy(electionsTable.id),
    db.select().from(regionsTable),
    db
      .select()
      .from(calibrationSettingsTable)
      .where(eq(calibrationSettingsTable.userId, GLOBAL_LEARNING_USER_ID))
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

  // 선거(electionDate)별로 시·도 행을 묶는다.
  const grouped = new Map<string, typeof elections>();
  for (const e of elections) {
    const arr = grouped.get(e.electionDate) ?? [];
    arr.push(e);
    grouped.set(e.electionDate, arr);
  }

  const groups: ElectionCalibrationGroup[] = [];

  for (const [electionDate, electionRows] of grouped) {
    const rows: ElectionCalibrationRow[] = [];
    const skipped: SkippedElectionRegion[] = [];
    let rawSum = 0;
    let calSum = 0;
    const electionName = electionRows[0]?.name ?? "";
    const electionId = electionRows[0]?.id ?? 0;

    for (const e of electionRows) {
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
          userId: GLOBAL_LEARNING_USER_ID,
          electionDate,
          skippedCount: skipped.length,
          scoredCount: rows.length,
          skipped,
        },
        "선거 백테스트: 일부 시·도가 합성 인구 부재로 예측에서 제외됨",
      );
    }

    const n = rows.length || 1;
    groups.push({
      electionId,
      electionName,
      electionDate,
      avgRawError: round1(rawSum / n),
      avgCalibratedError: round1(calSum / n),
      rows,
      skipped,
    });
  }

  // 최신 선거가 먼저(화면 기본 선택).
  groups.sort(
    (a, b) =>
      new Date(b.electionDate).getTime() - new Date(a.electionDate).getTime(),
  );

  return {
    method,
    shrinkageFactor: shrinkage,
    elections: groups,
  };
}

function round1(n: number): number {
  return Math.round(n * 10) / 10;
}
