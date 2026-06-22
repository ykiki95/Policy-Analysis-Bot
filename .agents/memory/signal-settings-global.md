---
name: Signals & learning data are globally shared (admin-curated)
description: signal_settings AND signal_batches (and all learning inputs) are global at userId=0; reads union(0,me); writes admin-only. Corrected from an earlier per-tenant signal_batches design.
---

신호(signals)·합성 학습 인구·학습 입력은 **전역 공유** 모델이다. 전역 소유자 = `GLOBAL_LEARNING_USER_ID = 0`(sentinel `users.id=0`, role `system`, 로그인 불가).

## 전역 공유 대상 (userId=0)
- 합성 학습 인구 `agents`, 설문 `surveys`, 정확도검증 `calibrations`, 보정설정 `calibration_settings`(단일 0행), 설문업로드 `survey_uploads`, 신호배치 `signal_batches`.
- **읽기**: 전역(0) 또는 `learningReadIds(req) = union(0, tenantId)`(본인 입력이 본인 예측에만 반영되는 미래 대비). 현재는 user-create 경로가 없어 사실상 전부 0.
- **쓰기**: 전부 admin 전용. 관리자가 ?accountId 로 무엇을 보든 학습 데이터는 항상 0 소유로 교체.

## 설정(`signal_settings`) — 전역 공용 (변경 없음)
- 단일 canonical 행 = 가장 낮은 id 행(`getGlobalSettings()`). 읽기 tenant 필터 없음, 변경 admin 전용.

## 시뮬레이션 — 계정별 + 표본추출
- `simulations`/`simulation_responses` 는 계정별(테넌트) 유지.
- 각 시뮬은 전역 인구(0)에서 `totalAgents`(=폼의 sampleSize) 만큼 **결정론적 표본추출**: `ORDER BY md5(id::text || ':' || simId::text) LIMIT n`. 헬퍼 `selectSampledAgents(simId,n)` 가 runSimulation·processSimulationBatch 양 경로 공통.
- create 가 sampleSize 를 받아 clamp[1..전역인구]→totalAgents 저장. estimate 도 totalAgents 로 비용 산출. 출력 보정 calibrations 읽기는 union(0,uid).

## 권한 가드 규약 (중요)
- adminRouter 는 전역 /admin 게이트 없이 마운트 — **각 핸들러에 `requireAdmin` 직접** 부착. 전역 학습 데이터를 쓰는 admin 라우트(population/regenerate, survey-uploads POST, calibration-settings PUT, calibrations POST/DELETE, elections/*)는 **반드시 requireAdmin**. 빠지면 비관리자가 플랫폼 전역 학습 데이터를 변조 가능(실제 누락 사고 있었음).
- 전역 자산을 다루는 read/delete 경로는 `tenantId(req)` 가 아니라 `GLOBAL_LEARNING_USER_ID` 로 필터해야 한다(create 가 0 으로 쓰는데 delete 가 tenant 로 필터하면 영원히 못 지움; survey-impact 도 0 으로 읽어야 백필 후 정상).

**Why:** 데모 제품 모델 = 관리자가 큰 합성 학습 인구·검증셋을 큐레이션하고, 모든 계정이 같은 인구를 공유하되 시뮬레이션만 계정별로 표본추출해 실행. 초기엔 per-tenant agents/signal_batches 였으나 "역할기반 데이터 공유 전면 정합"으로 전역화.

**How to apply:** 새 학습-데이터 mutation 라우트 추가 시 항상 requireAdmin + userId=0. 전역 자산 조회/삭제는 0 으로 필터. 시뮬 인구 선택은 selectSampledAgents 만 사용(agents 라이브 조인 금지 — 집계는 응답 스냅샷 기반). userId=0 sentinel user 행은 FK 무결성 운영 전제(없으면 학습 데이터 insert 실패).

**파생 계산 함수 주의(라이브 agents/settings 읽는 것 전부):** `computeElectionCalibration` 처럼 라이브 `agents`·`calibration_settings` 를 읽어 진단/보정 산출하는 함수는 **반드시 GLOBAL_LEARNING_USER_ID 로 읽어야** 한다 — tenantId 로 읽으면 전역화 이후 비-admin 계정은 0행 → 선거 백테스트 전 시·도 skip(오차·시·도별 예측 전부 사라짐). 전역화로 마이그레이션할 때 이런 read-path 가 라우트뿐 아니라 lib 계산 함수에도 숨어 있으니 같이 바꿀 것.
