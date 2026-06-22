import {
  useListCalibrations,
  useGetElectionCalibration,
} from "@workspace/api-client-react";

/** 정확도 추이 1포인트(원시·보정 오차/정확도). 검증 이벤트 또는 선거 백테스트. */
export type AccuracyPoint = {
  name: string;
  date: string;
  rawError: number;
  calibratedError: number;
  rawAccuracy: number;
  calibratedAccuracy: number;
  kind: "event" | "election";
};

export type AccuracyTrend = {
  points: AccuracyPoint[];
  eventCount: number;
  avgRawError: number;
  avgCalibratedError: number;
  isLoading: boolean;
};

/**
 * 검증 이벤트(보정 데이터)를 기준일 오름차순으로 정렬해 정확도 추이 포인트와
 * 집계(평균 원시·보정 오차, 이벤트 수)를 계산한다. 대시보드와 학습 탭이 같은
 * 데이터·계산을 공유하기 위한 단일 소스(중복 로직 금지).
 *
 * `includeElections=true`면 실제 선거 백테스트(제20·21대 대선)를 시간축 위 점으로
 * 함께 병합한다 — 단, 집계(eventCount/avg*)는 검증 이벤트만 대상으로 유지한다(선거는
 * 별도 ground-truth 검증이라 KPI 의미를 흐리지 않도록). 대시보드는 기본값(false)으로
 * 기존 동작을 유지하고, 보정 페이지 학습 탭만 true로 호출한다.
 */
export function useAccuracyTrend(options?: {
  includeElections?: boolean;
}): AccuracyTrend {
  const includeElections = options?.includeElections ?? false;
  const { data, isLoading } = useListCalibrations();
  // 항상 호출하되(훅 규칙) 집계/포인트 병합은 includeElections일 때만 사용한다.
  // 결과는 가벼운 계산(현재 인구 × 시드 선거)이라 미사용 시 부담이 적다.
  const { data: electionData, isLoading: electionsLoading } =
    useGetElectionCalibration();

  const events = (data ?? [])
    .slice()
    .sort(
      (a, b) => new Date(a.targetDate).getTime() - new Date(b.targetDate).getTime(),
    );

  const eventPoints: AccuracyPoint[] = events.map((c) => ({
    name: c.targetDate?.slice(0, 7) ?? c.title,
    date: c.targetDate,
    rawError: c.rawError,
    calibratedError: c.calibratedError,
    rawAccuracy: Math.max(0, 100 - c.rawError),
    calibratedAccuracy: Math.max(0, 100 - c.calibratedError),
    kind: "event",
  }));

  const electionPoints: AccuracyPoint[] = includeElections
    ? (electionData?.elections ?? []).map((e) => ({
        name: e.electionDate.slice(0, 7),
        date: e.electionDate,
        rawError: e.avgRawError,
        calibratedError: e.avgCalibratedError,
        rawAccuracy: Math.max(0, 100 - e.avgRawError),
        calibratedAccuracy: Math.max(0, 100 - e.avgCalibratedError),
        kind: "election",
      }))
    : [];

  const points = [...eventPoints, ...electionPoints].sort(
    (a, b) => new Date(a.date).getTime() - new Date(b.date).getTime(),
  );

  // 집계는 검증 이벤트만 대상(선거 백테스트 제외).
  const eventCount = eventPoints.length;
  const avgRawError = eventCount
    ? eventPoints.reduce((acc, p) => acc + p.rawError, 0) / eventCount
    : 0;
  const avgCalibratedError = eventCount
    ? eventPoints.reduce((acc, p) => acc + p.calibratedError, 0) / eventCount
    : 0;

  return {
    points,
    eventCount,
    avgRawError,
    avgCalibratedError,
    isLoading: isLoading || (includeElections && electionsLoading),
  };
}
