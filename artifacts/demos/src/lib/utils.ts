import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"
import { ApiError } from "@workspace/api-client-react"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

type BudgetDetail = {
  limitUsd: number
  spentUsd: number
  estimateUsd: number
}

/**
 * 실행 실패(error)를 한국어 안내 문구로 변환한다. 402(예산 초과)면 백엔드가
 * 내려준 budget 내역(화면 표시 단위 ×10)을 그대로 보여줘 "왜 막혔는지"와
 * "한도를 얼마로 올려야 하는지"를 명확히 안내한다.
 */
export function runErrorMessage(err: unknown, opts?: { createdPending?: boolean }): string {
  if (err instanceof ApiError && err.status === 402) {
    const budget = (err.data as { budget?: BudgetDetail } | null)?.budget
    if (budget) {
      const total = budget.spentUsd + budget.estimateUsd
      const needed = Math.ceil(total)
      const suffix = opts?.createdPending
        ? " (시뮬레이션은 생성되었으나 대기 상태입니다.)"
        : ""
      return (
        `예산 한도 초과: 현재 한도 $${budget.limitUsd.toFixed(2)} 중 이미 $${budget.spentUsd.toFixed(2)}을 사용했고, ` +
        `이번 실행에 약 $${budget.estimateUsd.toFixed(2)}이 필요해 합계 $${total.toFixed(2)}로 한도를 넘습니다. ` +
        `완료된 시뮬레이션 비용도 누적 한도에 포함됩니다. 관리자 화면에서 한도를 $${needed} 이상으로 올린 뒤 다시 실행하세요.${suffix}`
      )
    }
    const suffix = opts?.createdPending
      ? " (시뮬레이션은 생성되었으나 대기 상태입니다.)"
      : ""
    return `예산 한도를 초과하여 실행할 수 없습니다. 관리자에게 한도 상향을 요청하세요.${suffix}`
  }
  return "실행 요청에 실패했습니다. 잠시 후 다시 시도해 주세요."
}
