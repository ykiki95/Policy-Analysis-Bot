import type { Calibration } from "@workspace/db";

/**
 * 입력 보정(Lever 1) — 검증 이벤트의 평균 편향을 인구 재생성 시 페르소나
 * 기준선 이동량(offset)으로 환산한다. 출력 보정이 결과를 사후 교정한다면,
 * 입력 보정은 합성 인구 자체를 현실에 맞춰 근본적으로 보정한다.
 *
 * 규약(replit.md 참고):
 * - Dynamo: 보수 지표 기준. 양의 편향(실제>예측)이면 인구가 너무 진보적이라는
 *   뜻 → 정치성향 기준선을 보수(+) 방향으로 이동.
 * - Lumen: 지지/구매/전환 지표. 양의 편향이면 소비 성향(consumer stances)을
 *   상향(+).
 * - Seraph: 수용/찬성 지표. 양의 편향이면 정책 성향(policy stances)을 상향(+).
 *
 * offset = clamp(meanBias * shrinkage, ±limit). 결정론적 가산 이동이므로
 * generateAgents 의 PRNG 스트림을 흔들지 않는다.
 */
export type CalibrationOffsets = {
  /** 정치성향(-100..100) 기준선 이동량. */
  political: number;
  /** 소비 성향(0..100) 기준선 이동량. */
  consumer: number;
  /** 정책 성향(0..100) 기준선 이동량. */
  policy: number;
};

export const ZERO_OFFSETS: CalibrationOffsets = {
  political: 0,
  consumer: 0,
  policy: 0,
};

const MIN_EVENTS = 2;
const LEANING_LIMIT = 25;
const STANCE_LIMIT = 15;

const clamp = (v: number, lo: number, hi: number) =>
  Math.max(lo, Math.min(hi, v));
const round1 = (v: number) => Math.round(v * 10) / 10;

function meanBias(events: Calibration[]): number | null {
  if (events.length < MIN_EVENTS) return null;
  return (
    events.reduce((acc, e) => acc + (e.actualValue - e.rawPrediction), 0) /
    events.length
  );
}

/**
 * 제품별 검증 이벤트에서 인구 기준선 이동량을 계산한다.
 * `applyToPopulation` 이 false 면 모두 0 을 반환한다.
 */
export function computeCalibrationOffsets(
  events: Calibration[],
  shrinkageFactor: number,
  applyToPopulation: boolean,
): CalibrationOffsets {
  if (!applyToPopulation) return { ...ZERO_OFFSETS };

  const dynamoBias = meanBias(events.filter((e) => e.product === "Dynamo"));
  const lumenBias = meanBias(events.filter((e) => e.product === "Lumen"));
  const seraphBias = meanBias(events.filter((e) => e.product === "Seraph"));

  return {
    political:
      dynamoBias === null
        ? 0
        : round1(clamp(dynamoBias * shrinkageFactor, -LEANING_LIMIT, LEANING_LIMIT)),
    consumer:
      lumenBias === null
        ? 0
        : round1(clamp(lumenBias * shrinkageFactor, -STANCE_LIMIT, STANCE_LIMIT)),
    policy:
      seraphBias === null
        ? 0
        : round1(clamp(seraphBias * shrinkageFactor, -STANCE_LIMIT, STANCE_LIMIT)),
  };
}
