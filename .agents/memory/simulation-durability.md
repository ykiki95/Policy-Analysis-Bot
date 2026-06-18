---
name: simulation durability
description: How durable simulation execution works (queue + DB-lease worker loop + incremental persistence) and the constraints behind it.
---

# Durable simulation execution

LLM 시뮬레이션 실행은 비싸고 오래 걸리는 백그라운드 작업이라 서버 재시작/크래시에 취약했다. 내구성은 세 축으로 보장한다:

- **큐 + 워커 분리**: API의 `/simulations/:id/run` 은 작업을 큐에 넣기만 한다(status='queued', enqueue 시 예산 검사 통과 필수). 실제 LLM 실행은 항상 가동되는 워커 폴링 루프(부팅 시 `startSimulationWorker()` 1회 기동)가 담당한다.
- **DB lease 로 원자적 claim**: 워커는 `UPDATE ... WHERE id = (SELECT ... FOR UPDATE SKIP LOCKED LIMIT 1) RETURNING id` 로 한 작업을 한 워커만 집어 `running` 으로 전환하고 `locked_by/locked_at/heartbeat_at` 를 찍는다. claim 대상 = `status='queued'` 신규 작업 OR `status='running'` 이지만 heartbeat 만료된 고아(직전 프로세스 크래시/재배포). `SKIP LOCKED` 라 다중 인스턴스에서도 안전.
- **증분 영속화**: 각 에이전트 응답을 평가 직후 곧바로 `simulation_responses` 에 insert. `(simulation_id, agent_id)` 유니크 인덱스 + `onConflictDoNothing` 으로 멱등.

**Why:** 예전엔 fire-and-forget + 부팅 시 'running' = orphaned 라는 단일프로세스 불변식에 의존했다. 이제는 lease/heartbeat 모델이라 그 불변식에 기대지 않는다 — heartbeat 만료가 고아 판정 기준이라 워커가 죽어도 다른/재시작 워커가 STALE_MS(60s) 후 이어받는다.

**How to apply:**
- 워커 실행은 **항상 resume 모드**(`runSimulation(id, {resume:true})`). 이미 응답 있는 에이전트는 skip, 남은 것만 처리.
- 최종 집계(`finalizeSimulation`)는 항상 DB 전체 응답에서 재계산한다(fresh/resume 동일 경로). 메모리에 모은 rows 로 집계하지 말 것 — resume 시 이전 세션 행이 누락된다.
- **비용 함정**: resume 실행은 이전 세션(크래시 전) 토큰을 복구할 수 없다. 전체 에이전트를 이번 세션이 커버한 경우(`alreadyDone===0`)에만 토큰 실비용을 신뢰하고, 아니면 `estimateCost(total)` 추정치로 보정한다.
- 스키마 변경을 `drizzle push` 로 하면 수동 관리되는 `session` 테이블을 drop 하려 해 TTY 프롬프트에 막힌다. 단발 DDL 은 `executeSql` 로 직접 적용.
