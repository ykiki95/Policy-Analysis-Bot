# Synthetic Electorate Intelligence (DEMOS)

Aaru 스타일 합성 인구 시뮬레이션 SaaS. 서울 거주 합성 시민 500명(에이전트)에게 정책·메시지·신제품을 제시해 반응을 LLM으로 예측하고, 과거 가상 이벤트로 보정·검증하는 데모 플랫폼. 제품 라인: Lumen(비즈니스), Seraph(정부), Dynamo(정치).

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server
- `pnpm --filter @workspace/demos run dev` — run the web frontend
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm --filter @workspace/demos run typecheck` — typecheck just the frontend
- `pnpm --filter @workspace/api-spec run codegen` — regenerate hooks + Zod from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL`, `AI_INTEGRATIONS_OPENAI_BASE_URL`, `AI_INTEGRATIONS_OPENAI_API_KEY`
- 선거 데이터 연동 env(선택): `DATA_GO_KR_API_KEY` (공공데이터포털 — 실제 개표결과 import 시 필요)

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5; DB: PostgreSQL + Drizzle ORM
- Frontend: React + Vite + wouter + TanStack Query + recharts + shadcn/ui
- Validation: Zod (`zod/v4`); API codegen: Orval (from OpenAPI spec)
- LLM: OpenAI via Replit AI Integrations proxy (gpt-5 / gpt-5-mini / gpt-5-nano)

## Where things live

- DB schema (source of truth): `lib/db/src/schema/*.ts` (agents, surveys, simulations, simulationResponses, calibrations, dataSources, surveyUploads, calibrationSettings)
- API contract (source of truth): `lib/api-spec/openapi.yaml` → generates `@workspace/api-zod` + `@workspace/api-client-react`
- Backend routes: `artifacts/api-server/src/routes/*.ts`
- Cost estimator: `artifacts/api-server/src/lib/pricing.ts`
- LLM run engine: `artifacts/api-server/src/lib/simulationEngine.ts`
- Deterministic agent generator: `artifacts/api-server/src/lib/agentGenerator.ts` (25 Seoul gu centroids + correlated attitudes, mulberry32 PRNG, optional survey adjustments)
- 설문→페르소나 가중 코어: `artifacts/api-server/src/lib/surveyWeighting.ts` (`appliedToPopulation=true` 설문의 드라이버를 이슈별 {multiplier, noiseScale}로 변환 → generateAgents에 주입. 5개 이슈: 경제/복지/안보/환경/주거). `domain` 이 `commercial`/`policy` 인 설문은 건너뜀.
- 소비 도메인 가중(Lumen): `artifacts/api-server/src/lib/consumerWeighting.ts` (`domain='commercial'` 설문 → consumerStances 5축)
- 정책 도메인 가중(Seraph): `artifacts/api-server/src/lib/policyWeighting.ts` (`domain='policy'` 설문 → policyStances 5축: 정부신뢰/정책수용성/증세수용/규제선호/공공서비스만족). agentGenerator는 정치·소비와 독립된 세 번째 PRNG 스트림(`policyRand = mulberry32(seed ^ 0x85ebca6b)`)으로 노이즈 생성 — 트랙 추가가 기존 스트림을 흔들지 않음.
- 보정 피드백 루프 — 두 레버:
  - 출력 보정(Lever 2): `artifacts/api-server/src/lib/calibrationModel.ts` (`buildOutputCalibrationModel(events, shrinkage)` → meanBias=mean(actual−raw), ≥2 이벤트일 때만 applied; `applyOutputCalibration(raw, model)`는 support를 shrinkage·meanBias만큼 이동 후 delta를 oppose/neutral에 비례 분배, 합 100 재정규화). `simulations.ts` GET /:id가 완료 시뮬레이션에 한해 `sim.product` 이벤트로 모델을 만들어 응답에 `calibration` 객체 추가. 프런트 `simulations/detail.tsx`가 원시 vs 보정 찬성률 비교 카드 표시.
  - 입력 보정(Lever 1): `artifacts/api-server/src/lib/calibrationWeighting.ts` (`computeCalibrationOffsets(events, shrinkage, applyToPopulation)` → 제품별 평균 편향을 {political,consumer,policy} 기준선 이동량으로 환산, clamp(±25 leaning / ±15 stance), 토글 off 또는 <2 이벤트면 0). `calibrationSettings.applyToPopulation` 토글(기본 false)이 켜져 있을 때만 `populationData.buildGenerationInputs`가 offsets를 `generateAgents`에 주입 → 다음 인구 재생성부터 페르소나 기준선 이동. 프런트 `calibration/index.tsx` 상단 루프 허브의 Switch로 제어.
  - 검증 이벤트 규약: `actualValue`/`rawPrediction` = 시뮬레이션이 예측하는 동일 지표(지지·찬성·수용률 %). Dynamo 이벤트=보수 지표(선거 시드와 일치)이므로 양의 편향이면 정치성향 기준선이 보수(+) 방향으로 이동. Lumen→consumer, Seraph→policy 기준선에 +offset.
- 실제 선거 데이터 연동: `artifacts/api-server/src/lib/dataGoKr.ts` (중앙선거관리위원회 투·개표 정보 API / data.go.kr). 관리자가 대선(20·21대)을 골라 실제 시·도별 보수=국민의힘 후보 득표율(dugsuNN/yutusu)을 불러와 `elections` ground-truth를 전체 교체. numOfRows 100 캡 → 페이지네이션, 17개 시·도 완전성 검증 후에만 교체. 라우트: `admin.ts` GET `/admin/elections/sources`, POST `/admin/elections/import`. 프런트: `admin/index.tsx` 보정 설정 탭의 ElectionImportSection.
- Admin routes: `artifacts/api-server/src/routes/admin.ts` (인구 재생성, 데이터 출처, 설문 업로드, 보정 설정, 선거 데이터 import)
- Frontend pages: `artifacts/demos/src/pages/*` (관리자 페이지: `pages/admin/index.tsx`)
- Map: Leaflet + react-leaflet + OpenStreetMap 타일 (API 키 불필요), `pages/population/index.tsx`의 `CircleMarker` 산점도

## Architecture decisions

- Drizzle returns `Date` objects but generated Zod response schemas expect `string`; routes pass DB rows through `jsonReady()` (`lib/serialize.ts`, a JSON round-trip) before `.parse()`.
- **큐 + 실행 드라이버 분리**: `/simulations/:id/run`은 실행하지 않고 enqueue 만 한다(예산 검사 통과 시 status `queued`로 전환 + 이전 실행의 `simulation_responses`를 비워 깨끗한 (재)시작 보장, 202 반환). 실제 LLM 실행을 진행시키는 드라이버는 배포 모델에 따라 둘이다. 프런트는 `GET /simulations/:id`로 진행률 폴링.
  - **개발(`NODE_ENV!=='production'`)**: 항상 가동되는 워커 폴링 루프(`lib/worker.ts`, 부팅 시 `index.ts`의 `startSimulationWorker()`로 1회 기동)가 `runSimulation(id,{resume:true})`로 끝까지 실행.
  - **프로덕션(Autoscale, B1 = 클라이언트 구동)**: 워커는 꺼진다(`index.ts`가 prod 에서 기동 안 함). 프런트 진행률 화면(`simulations/detail.tsx`)이 살아 있는 동안만 `POST /simulations/:id/tick`을 주기(1.5s) 호출 → `simulationEngine.ts`의 `processSimulationBatch(id,{maxAgents})`가 한 번에 `TICK_MAX_AGENTS`(기본 16, env 조정)만큼만 전진. 탭을 닫으면 일시정지, 다시 열면 resume. Autoscale 은 유휴 시 0으로 축소돼 사용자가 화면을 보는 동안만 비용이 든다.
- **claim = DB lease (두 드라이버 공통)**: 워커는 `UPDATE simulations ... WHERE id = (SELECT ... FOR UPDATE SKIP LOCKED LIMIT 1) RETURNING id`; tick 경로(`processSimulationBatch`)도 동일 규약의 조건부 `UPDATE ... SET locked_by=TICK_WORKER_ID ... WHERE status='queued' OR (running AND (우리 소유 OR locked_by NULL OR heartbeat 만료)) RETURNING id`로 원자적 claim 후 `running`으로 전환하고 `locked_by/locked_at/heartbeat_at`를 찍는다. claim 대상 = `status='queued'` 신규 OR `status='running'`이지만 heartbeat 만료(STALE_MS=60s)된 고아(크래시/재배포/탭 종료). claim 실패 시 즉시 반환 → Autoscale 다중 인스턴스에서도 한 sim 을 한 인스턴스만 전진(중복 LLM 호출 방지). 배포는 `autoscale` 타입.
- **시뮬레이션 실행 내구성(durable execution)**: 워커는 항상 resume 모드(`runSimulation(id, {resume:true})`)로 실행한다. 각 에이전트 응답을 평가 직후 즉시 `simulation_responses`에 증분 insert(끝에 일괄 저장 X), `(simulation_id, agent_id)` 유니크 인덱스 + `onConflictDoNothing`으로 멱등. 이미 응답 있는 에이전트는 skip, 남은 것만 처리. 최종 집계(`finalizeSimulation`)는 항상 DB 전체 응답에서 재계산하므로 fresh/resume 경로가 동일. resume 비용은 이전 세션 토큰을 복구할 수 없어 `alreadyDone===0`(이번 세션이 전체를 커버)일 때만 토큰 실비용을 쓰고 아니면 추정치로 보정.
- **멀티테넌시**: per-user 데이터(agents/simulations/surveys/surveyUploads/calibrations/calibrationSettings, `userId` FK), 공용 데이터(regions/demographicMargins/elections/dataSources). `lib/tenant.ts`의 `tenantId(req)`(세션 userId; admin은 `?accountId`로 타계정 지정)/`isAdmin(req)`로 스코프 결정. 인구 재생성은 해당 user의 agents만 삭제(글로벌 seq reset 없음). 기존 데이터는 `test` 계정 소유로 백필, 신규 가입은 빈 상태.
- **예산 한도**: `lib/budget.ts`. 계정당 `users.budgetLimitUsd`(실제 USD). enqueue 시 `db.transaction` 안에서 사용자 행을 `FOR UPDATE` 잠그고 `assertWithinBudgetTx`로 검사 — "확약 지출"(완료=costActualUsd, 대기열/실행중=`max(actual,estimate)` 예약분)에 enqueue 시점 재계산 estimate(`countAgents`+`estimateCost`)를 더해 한도 초과면 402. 화면 표기 금액 = 실제 USD × `DISPLAY_MULTIPLIER`(=10); `/budget`·402 응답 모두 ×10 + `multiplier:10` 필드(프런트는 곱하지 말 것), admin 한도 입력은 화면 단위라 저장 시 ÷10.
- Agent attitudes are synthetic but correlated: political leaning derived from age + district bias + noise; issue stances derived from leaning. Seeded deterministically (PRNG) — not random per boot.
- Cost shown BEFORE running via `/simulations/estimate` (token-count × per-model price). gpt-5-mini ≈ $0.29, gpt-5-nano ≈ $0.06, gpt-5 ≈ $1.44 for a 500-agent run.
- Calibration data is illustrative: calibrated error is consistently lower than raw error to demonstrate the validation loop. 단, 선거 검증(electionCalibration)의 ground-truth(`elections`)는 관리자 import를 통해 data.go.kr 실제 개표결과로 대체 가능하다 — 합성 인구 예측 vs 실제 선거결과 비교는 실데이터 기반.
- **시뮬레이션 결과 보존**: `simulation_responses`는 `district/ageBracket/gender/politicalLeaning`을 응답 시점에 스냅샷으로 저장한다. `GET /simulations/:id` 집계는 절대 라이브 `agents` 테이블과 조인하지 않는다 — 그래야 인구 재생성(해당 user agents 교체) 후에도 과거 시뮬레이션 집계가 변하지 않는다. 새 `politicalLeaning` 컬럼 추가 시 기존 행은 agents에서 백필했다.
- 인구 재생성은 단일 트랜잭션에서 **해당 user의 agents만** 삭제 → `generateAgents(count)` 재삽입으로 원자적으로 수행한다(글로벌 `agents_id_seq` 리셋 없음 — 멀티테넌시 때문). count 범위 50~5000.
- **인증/인가**: 커스텀 express-session(Clerk 아님, `lib/tenant.ts`). 관리자 라우트(`/api/admin/*`)는 `routes/index.ts`에서 `requireAdmin` 미들웨어로 보호한다. 인구 생성/설문 업로드/검증 이벤트 등 자기서비스 기능은 인증 사용자 본인 스코프; admin은 `?accountId`로 임의 계정 대상 가능. 회원가입/과금 UI는 향후 범위.

## Product

- 대시보드: KPI 요약(에이전트 수, 시뮬레이션 수, 보정 정확도, 총 비용) + 최근 시뮬레이션
- 합성 인구: 서울 지도(lat/lng SVG 산점도, 정치성향 색상) + 인구통계 분포 + 에이전트 탐색/상세
- 설문·태도: 합성 인구 태도의 근거가 되는 (합성) 설문 데이터 + 드라이버
- 시뮬레이션: 생성 폼(모델 선택 + 실행 전 비용 추정) → 실행(진행률 폴링) → 자치구/연령/성별/성향별 결과 + 개별 응답
- 보정 및 검증: 원시 예측 vs 보정 예측 오차 비교
- 제품 라인업: Lumen / Seraph / Dynamo

## User preferences

- 모든 UI 카피는 한국어로 작성한다.
- 사용자에게는 한국어로 응답한다.

## Gotchas

- `audience` 값은 한국어("비즈니스"/"정부"/"정치"), `product`는 영문("Lumen"/"Seraph"/"Dynamo")로 시드/폼이 일치해야 한다.
- 시드 데이터는 `code_execution` 샌드박스에서 `executeSql`로 생성한다. text[] 컬럼은 Postgres 배열 리터럴 문자열 + `::text[]`, jsonb는 `JSON.stringify` + `::jsonb`로 바인딩.
- 실제 500콜 LLM 실행은 비용이 발생하므로 테스트 시 estimate + 시드된 완료 시뮬레이션으로 검증한다.

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
