import type { Calibration } from "@workspace/db";

/**
 * 출력 보정(Lever 2) — 제품 라인의 과거 검증 이벤트(실제값 vs 원시 예측)에서
 * 평균 편향(meanBias)을 학습해, 새 시뮬레이션의 원시 예측에 같은 부호의
 * 사후 보정을 적용한다.
 *
 * 규약: 검증 이벤트의 actualValue/rawPrediction 은 시뮬레이션이 예측하는
 * 동일 지표(지지·찬성·수용률 %)를 기준으로 한다. 따라서 meanBias 는
 * "현실이 모델 예측보다 평균적으로 얼마나 높았는지(%p)"를 의미하며,
 * 동일 부호로 지지율(supportPct)을 교정한다.
 */
export type OutputCalibrationModel = {
  /** 보정 적용 여부 (이벤트가 충분히 쌓였을 때만 true). */
  applied: boolean;
  /** 보정에 사용한 검증 이벤트 수. */
  eventCount: number;
  /** 평균 부호 편향 mean(actual - raw), %p. */
  meanBias: number;
  /** 적용한 축소 계수(0..1). 편향을 그대로 적용하지 않고 보수적으로 줄인다. */
  shrinkage: number;
};

const MIN_EVENTS = 2;

/** 제품 라인의 검증 이벤트 + 축소 계수로 출력 보정 모델을 만든다. */
export function buildOutputCalibrationModel(
  events: Calibration[],
  shrinkageFactor: number,
): OutputCalibrationModel {
  const eventCount = events.length;
  if (eventCount < MIN_EVENTS) {
    return { applied: false, eventCount, meanBias: 0, shrinkage: shrinkageFactor };
  }
  const meanBias =
    events.reduce((acc, e) => acc + (e.actualValue - e.rawPrediction), 0) /
    eventCount;
  return {
    applied: true,
    eventCount,
    meanBias: Math.round(meanBias * 10) / 10,
    shrinkage: shrinkageFactor,
  };
}

const clamp = (v: number, lo: number, hi: number) =>
  Math.max(lo, Math.min(hi, v));
const round1 = (v: number) => Math.round(v * 10) / 10;

/**
 * 원시 지지/반대/중립(%)에 출력 보정을 적용한다. 지지율을
 * `support + shrinkage * meanBias` 로 교정하고, 변화량(delta)을 반대·중립에
 * 비례 분배해 합이 100 을 유지하도록 재정규화한다.
 */
export function applyOutputCalibration(
  raw: { supportPct: number; opposePct: number; neutralPct: number },
  model: OutputCalibrationModel,
): { supportPct: number; opposePct: number; neutralPct: number } | null {
  if (!model.applied) return null;

  const correction = model.shrinkage * model.meanBias;
  const calibratedSupport = clamp(raw.supportPct + correction, 0, 100);
  const delta = calibratedSupport - raw.supportPct;

  const rest = raw.opposePct + raw.neutralPct;
  let oppose: number;
  let neutral: number;
  if (rest <= 0) {
    oppose = clamp(raw.opposePct - delta / 2, 0, 100);
    neutral = clamp(raw.neutralPct - delta / 2, 0, 100);
  } else {
    oppose = clamp(raw.opposePct - delta * (raw.opposePct / rest), 0, 100);
    neutral = clamp(raw.neutralPct - delta * (raw.neutralPct / rest), 0, 100);
  }

  // Renormalize to sum 100 to absorb any clamping drift.
  const total = calibratedSupport + oppose + neutral;
  const scale = total > 0 ? 100 / total : 1;
  const supportPct = round1(calibratedSupport * scale);
  const opposePct = round1(oppose * scale);
  // 마지막 항목은 잔차로 맞춰 세 값의 합이 정확히 100.0 이 되도록 보정한다.
  const neutralPct = round1(100 - supportPct - opposePct);
  return { supportPct, opposePct, neutralPct };
}
