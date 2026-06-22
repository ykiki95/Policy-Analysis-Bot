/**
 * 비용 표시 일원화 — 단일 소스(single source of truth).
 *
 * 서버·DB·API 는 항상 실제 LLM 실비(USD) 만 다룬다. 데모에서는 화면에만
 * 배수를 곱해 크게 보여준다. **실제 비용으로 되돌리려면 아래 상수 하나만
 * 1 로 바꾸면** 모든 화면(예산 배지/대시보드/시뮬레이션/관리자/오류 안내)에
 * 일괄 반영된다. 화면에서 비용을 표시하거나 입력받는 모든 곳은 반드시
 * 이 파일의 헬퍼를 거쳐야 한다(직접 `* 10` 금지).
 */
export const COST_DISPLAY_MULTIPLIER = 10;

/** 실비(USD) → 화면 표시 금액(숫자, 소수 2자리 반올림). */
export function toDisplayCost(actualUsd: number): number {
  return Math.round(actualUsd * COST_DISPLAY_MULTIPLIER * 100) / 100;
}

/** 화면 표시 금액 → 실비(USD). 관리자 한도 입력을 저장할 때 사용. */
export function toActualCost(displayUsd: number): number {
  return displayUsd / COST_DISPLAY_MULTIPLIER;
}

/** 실비(USD)를 화면 표시 통화 문자열($X,XXX.XX)로 포맷. */
export function formatCost(actualUsd: number): string {
  return `$${toDisplayCost(actualUsd).toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
}
