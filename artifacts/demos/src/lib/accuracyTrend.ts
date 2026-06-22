import { useListCalibrations } from "@workspace/api-client-react";

/** 검증 이벤트 1건의 정확도 포인트(원시·보정 오차/정확도). */
export type AccuracyPoint = {
  name: string;
  date: string;
  rawError: number;
  calibratedError: number;
  rawAccuracy: number;
  calibratedAccuracy: number;
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
 */
export function useAccuracyTrend(): AccuracyTrend {
  const { data, isLoading } = useListCalibrations();

  const events = (data ?? [])
    .slice()
    .sort(
      (a, b) => new Date(a.targetDate).getTime() - new Date(b.targetDate).getTime(),
    );

  const points: AccuracyPoint[] = events.map((c) => ({
    name: c.targetDate?.slice(0, 7) ?? c.title,
    date: c.targetDate,
    rawError: c.rawError,
    calibratedError: c.calibratedError,
    rawAccuracy: Math.max(0, 100 - c.rawError),
    calibratedAccuracy: Math.max(0, 100 - c.calibratedError),
  }));

  const eventCount = points.length;
  const avgRawError = eventCount
    ? points.reduce((acc, p) => acc + p.rawError, 0) / eventCount
    : 0;
  const avgCalibratedError = eventCount
    ? points.reduce((acc, p) => acc + p.calibratedError, 0) / eventCount
    : 0;

  return { points, eventCount, avgRawError, avgCalibratedError, isLoading };
}
