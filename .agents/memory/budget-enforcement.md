---
name: budget enforcement
description: How per-account LLM spend caps are enforced at enqueue time, and the display-units contract.
---

# Budget enforcement (per-account LLM spend cap)

각 계정(users.budgetLimitUsd, 실제 USD)에 LLM 실행 비용 한도가 있다. 검사는 **enqueue 시점**(`/simulations/:id/run`)에만 한다 — 워커는 큐에 들어온 작업을 무조건 실행한다.

**핵심 불변식:**
- 한도 검사는 `db.transaction` 안에서 사용자 행을 `FOR UPDATE` 로 잠그고 수행한다(`assertWithinBudgetTx`). 같은 사용자의 동시 enqueue 가 직렬화되어 한도 우회 불가.
- "확약(committed) 지출" = 완료/실패 행의 `costActualUsd` + 대기열/실행중 행의 예약분. 대기열/실행중은 `max(actual, estimate)` 로 집계 → 과거 완료 sim 재실행(rerun, status→queued)시에도 이미 발생한 실비 아래로 떨어지지 않음.
- estimate 는 생성 시점 값을 신뢰하지 말고 **enqueue 시점에 현재 스코프 에이전트 수로 재계산**한다(`countAgents(uid)` + `estimateCost`). 재계산값으로 `totalAgents/costEstimateUsd` 도 갱신.

**Why:** 초기 버전은 (1) 완료된 실비만 합산해 동시 enqueue 가 한도를 우회했고 (2) 생성 시점 stale estimate 를 썼다. 둘 다 architect 가 SEVERE 로 지적 → 위 불변식으로 해결.

**디스플레이 단위 계약:** 화면 표기 금액 = 실제 USD × `DISPLAY_MULTIPLIER`(=10). `/budget` 응답과 402 over-limit 응답 둘 다 limit/spent/remaining/estimate 를 ×10 한 값 + `multiplier:10` 필드로 반환한다 — 프런트는 곱하지 말고 그대로 표시. 한도 변경 admin 엔드포인트 입력도 화면 단위이므로 저장 시 ÷10.

**누적(평생) 캡이라는 점이 사용자를 혼란시킨다:** 완료된 sim 의 실비가 한도에 영구히 누적되므로, "한도 $20 인데 $14 짜리 한 건이 왜 안 돌지?" 같은 상황이 정상 동작으로 발생한다(이미 $5.84 썼으면 $20.22 > $20 으로 402). 따라서 402 메시지는 반드시 **한도/이미사용/이번추정/합계/권장한도(≥ceil(합계))** 를 구체적으로 보여줘야 한다 — 일반 "한도 초과" 문구만 주면 사용자가 한도를 올려도 또 막혀 좌절한다. 프런트 헬퍼 `runErrorMessage()`(demos `lib/utils.ts`)가 402 의 `err.data.budget` 으로 이 문구를 만든다.
