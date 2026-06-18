import { eq } from "drizzle-orm";
import { db, simulationsTable, usersTable } from "@workspace/db";

/**
 * 화면 표시 배수. 내부적으로는 실제 LLM 실비(USD)로 저장/계산하되, 사용자에게
 * 보여줄 때는 ×10 한 금액을 표시한다(기본 실비 $1 = 화면 $10).
 */
export const DISPLAY_MULTIPLIER = 10;

export type BudgetStatus = {
  limitUsd: number;
  spentUsd: number;
  remainingUsd: number;
};

export type BudgetExceededDetail = BudgetStatus & { estimateUsd: number };

export class BudgetExceededError extends Error {
  detail: BudgetExceededDetail;
  constructor(detail: BudgetExceededDetail) {
    super("계정 예산 한도를 초과하여 시뮬레이션을 실행할 수 없습니다.");
    this.name = "BudgetExceededError";
    this.detail = detail;
  }
}

/** drizzle 트랜잭션 콜백이 받는 핸들 타입(db 와 동일 쿼리 빌더 API). */
type Tx = Parameters<Parameters<typeof db.transaction>[0]>[0];

/** 계정의 누적 실비 지출(완료된 시뮬레이션 costActualUsd 합). 표시용. */
export async function getSpend(userId: number): Promise<number> {
  const rows = await db
    .select({ cost: simulationsTable.costActualUsd })
    .from(simulationsTable)
    .where(eq(simulationsTable.userId, userId));
  return rows.reduce((acc, r) => acc + (r.cost ?? 0), 0);
}

/**
 * 예산 집행용 "확약(committed)" 지출.
 * 완료/실패 시뮬레이션은 실비(costActualUsd)를, 대기열/실행중 시뮬레이션은
 * 추정 예약분(costEstimateUsd)을 합산한다. 이렇게 해야 동시 enqueue 시
 * 이미 예약된 비용을 포함해 한도 초과를 막을 수 있다.
 *
 * 단, 과거에 완료되었던 시뮬레이션을 재실행(rerun)하면 status 가 queued/running
 * 으로 바뀌면서 이미 발생한 실비(actual)가 누락될 수 있다. 이를 막기 위해
 * 대기열/실행중 행은 max(이미 발생한 실비, 이번 추정 예약분)으로 보수적으로
 * 집계한다 — 재실행 중에도 과거 실비 아래로 떨어지지 않는다.
 */
function committedSpend(
  rows: { status: string; actual: number | null; estimate: number | null }[],
): number {
  return rows.reduce((acc, r) => {
    if (r.status === "queued" || r.status === "running") {
      return acc + Math.max(r.actual ?? 0, r.estimate ?? 0);
    }
    return acc + (r.actual ?? 0);
  }, 0);
}

/** 계정 한도 + 누적 지출 + 잔여(모두 실제 USD). */
export async function getBudgetStatus(userId: number): Promise<BudgetStatus> {
  const [user] = await db
    .select({ limit: usersTable.budgetLimitUsd })
    .from(usersTable)
    .where(eq(usersTable.id, userId));
  const limitUsd = user?.limit ?? 0;
  const spentUsd = await getSpend(userId);
  return {
    limitUsd,
    spentUsd: Math.round(spentUsd * 10000) / 10000,
    remainingUsd: Math.max(0, Math.round((limitUsd - spentUsd) * 10000) / 10000),
  };
}

/**
 * 트랜잭션 안에서 호출하는 예산 검사(enqueue 시).
 * 1) 사용자 행을 FOR UPDATE 로 잠가 계정당 동시 enqueue 를 직렬화한다.
 * 2) 확약 지출(완료 실비 + 대기열/실행중 추정 예약분)을 합산해 검사한다.
 * 한도를 넘으면 BudgetExceededError 를 던진다(트랜잭션 롤백).
 */
export async function assertWithinBudgetTx(
  tx: Tx,
  userId: number,
  estimateUsd: number,
): Promise<void> {
  const [user] = await tx
    .select({ limit: usersTable.budgetLimitUsd })
    .from(usersTable)
    .where(eq(usersTable.id, userId))
    .for("update");
  const limitUsd = user?.limit ?? 0;

  const rows = await tx
    .select({
      status: simulationsTable.status,
      actual: simulationsTable.costActualUsd,
      estimate: simulationsTable.costEstimateUsd,
    })
    .from(simulationsTable)
    .where(eq(simulationsTable.userId, userId));
  const spentUsd = Math.round(committedSpend(rows) * 10000) / 10000;

  if (spentUsd + estimateUsd > limitUsd + 1e-9) {
    throw new BudgetExceededError({
      limitUsd,
      spentUsd,
      remainingUsd: Math.max(0, Math.round((limitUsd - spentUsd) * 10000) / 10000),
      estimateUsd,
    });
  }
}
