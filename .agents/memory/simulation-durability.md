---
name: simulation durability
description: How durable simulation execution works (incremental persistence + boot-time resume) and the constraints behind it.
---

# Durable simulation execution

LLM 시뮬레이션 실행은 fire-and-forget 백그라운드 작업이라 서버 재시작/크래시에 취약했다. 내구성은 두 축으로 보장한다:

- **증분 영속화**: 각 에이전트 응답을 평가 직후 곧바로 `simulation_responses`에 insert (실행 끝에 일괄 저장 X). `(simulation_id, agent_id)` 유니크 인덱스 + `onConflictDoNothing`으로 멱등.
- **부팅 재개**: 부팅 시 `status='running'` 인 시뮬레이션은 직전 프로세스가 죽어 생긴 고아이므로 모두 안전하게 재개 대상. resume 시 이미 응답 있는 에이전트는 skip, 남은 것만 처리.

**Why:** 단일 프로세스 데모라 새 프로세스 부팅 시점에는 진행 중인 실행이 없다 → 'running' = orphaned 라는 단순 불변식이 성립한다. 다중 인스턴스라면 이 불변식이 깨지므로 DB lease 가 필요하다.

**How to apply:**
- 최종 집계는 항상 DB의 전체 응답에서 재계산한다(fresh/resume 동일 경로). 메모리에 모은 rows 로 집계하지 말 것 — resume 시 이전 세션 행이 누락된다.
- **비용 함정**: resume 실행은 이전 세션(크래시 전) 토큰을 복구할 수 없다. 이번 세션 토큰만으로 `costFromUsage` 하면 체계적 과소계상. 전체 에이전트를 이번 세션이 커버한 경우(`alreadyDone===0`)에만 토큰 실비용을 신뢰하고, 아니면 `estimateCost(total)` 추정치로 보정한다.
- 동일 시뮬레이션 중복 실행(`/run` 레이스, 복구+수동 중복)은 인메모리 `activeRuns` Set 가드로 막는다 — DB insert 는 멱등하지만 LLM 호출 중복 비용은 막아야 한다. 다중 인스턴스 배포 시엔 DB lease 로 대체 필요(현재 범위 밖).
- 스키마 변경을 `drizzle push` 로 하면 수동 관리되는 `session` 테이블을 drop 하려 해서 TTY 프롬프트에 막힌다. 인덱스 등 단발 DDL 은 `executeSql` 로 직접 적용하는 편이 안전.
