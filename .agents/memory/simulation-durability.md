---
name: simulation durability
description: How durable simulation execution works (queue + two execution drivers + DB lease + incremental persistence) and the constraints behind it.
---

# Durable simulation execution

LLM 시뮬레이션 실행은 비싸고 오래 걸리는 백그라운드 작업이라 서버 재시작/크래시에 취약했다. 내구성은 세 축으로 보장한다:

- **큐 + 실행 드라이버 분리**: API의 `/simulations/:id/run` 은 작업을 큐에 넣기만 한다(status='queued', enqueue 시 예산 검사 통과 필수 + 이전 실행의 `simulation_responses` 를 비워 깨끗한 시작 보장). 실제 LLM 실행을 진행시키는 드라이버는 **배포 모델에 따라 둘**이다:
  - **개발(NODE_ENV!=='production')**: 항상 가동되는 워커 폴링 루프(`startSimulationWorker()`)가 `runSimulation(id,{resume:true})` 로 끝까지 실행.
  - **프로덕션(Autoscale, B1 = client-driven)**: 워커는 꺼진다. 프런트 진행률 화면이 살아 있는 동안만 `POST /simulations/:id/tick` 를 주기 호출 → `processSimulationBatch(id,{maxAgents})` 가 한 번에 TICK_MAX_AGENTS(기본 16, env 조정) 만큼만 전진. 탭 닫으면 일시정지, 다시 열면 resume. **Why Autoscale**: 유휴 시 0 스케일이라 사용자가 볼 때만 비용 발생.
- **DB lease 로 원자적 claim (두 드라이버 모두)**: 워커는 `UPDATE ... WHERE id = (SELECT ... FOR UPDATE SKIP LOCKED LIMIT 1) RETURNING id`; tick 경로(`processSimulationBatch`)도 동일 규약의 조건부 `UPDATE ... SET locked_by=TICK_WORKER_ID ... WHERE status='queued' OR (running AND (우리 소유 OR locked_by NULL OR heartbeat 만료)) RETURNING id` 로 claim. claim 실패 시 즉시 반환 → **Autoscale 다중 인스턴스에서 같은 sim 을 두 인스턴스가 동시에 전진시켜 중복 LLM 호출 하는 것을 막는다**(인메모리 activeRuns 가드만으로는 부족).
- **증분 영속화**: 각 에이전트 응답을 평가 직후 곧바로 `simulation_responses` 에 insert. `(simulation_id, agent_id)` 유니크 인덱스 + `onConflictDoNothing` 으로 멱등.

**Why:** 예전엔 fire-and-forget + 부팅 시 'running' = orphaned 라는 단일프로세스 불변식에 의존했다. 이제는 lease/heartbeat 모델이라 그 불변식에 기대지 않는다 — heartbeat 만료가 고아 판정 기준이라 워커/탭이 죽어도 다른/재시작 드라이버가 STALE_MS(60s) 후 이어받는다.

**How to apply:**
- 모든 실행은 **resume 의미**(이미 응답 있는 에이전트 skip, 남은 것만 처리). "깨끗한 재실행" 은 워커가 아니라 `/run` 이 응답을 비워서 보장한다 — 인구 재생성 후 재실행 시 과거+신규 응답이 섞여 집계가 오염되는 것을 막는다.
- 최종 집계(`finalizeSimulation`)는 항상 DB 전체 응답에서 재계산한다(fresh/resume/tick 동일 경로). 메모리에 모은 rows 로 집계하지 말 것 — resume 시 이전 세션 행이 누락된다.
- **비용 함정**: resume/tick 실행은 이전 세션 토큰을 복구할 수 없다. 전체 에이전트를 이번 세션이 커버한 경우(`alreadyDone===0`)에만 토큰 실비용을 신뢰하고, 아니면 `estimateCost(total)` 추정치로 보정한다. tick 경로는 항상 추정치 보정(다중 요청 세션).
- 한 tick 배치가 Autoscale 요청 타임아웃 안에 끝나야 하므로 TICK_MAX_AGENTS 는 작게(동시성 8의 배수, 기본 16). 잘려도 증분+멱등이라 다음 tick 이 이어받음.
- 스키마 변경을 `drizzle push` 로 하면 수동 관리되는 `session` 테이블을 drop 하려 해 TTY 프롬프트에 막힌다. 단발 DDL 은 `executeSql` 로 직접 적용.
