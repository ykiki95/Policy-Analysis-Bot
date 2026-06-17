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
- Admin routes: `artifacts/api-server/src/routes/admin.ts` (인구 재생성, 데이터 출처, 설문 업로드, 보정 설정)
- Frontend pages: `artifacts/demos/src/pages/*` (관리자 페이지: `pages/admin/index.tsx`)
- Map: Leaflet + react-leaflet + OpenStreetMap 타일 (API 키 불필요), `pages/population/index.tsx`의 `CircleMarker` 산점도

## Architecture decisions

- Drizzle returns `Date` objects but generated Zod response schemas expect `string`; routes pass DB rows through `jsonReady()` (`lib/serialize.ts`, a JSON round-trip) before `.parse()`.
- Simulation runs are fire-and-forget: `/simulations/:id/run` sets status `running`, kicks off `runSimulation()` un-awaited, returns 202; frontend polls `GET /simulations/:id` for progress.
- Agent attitudes are synthetic but correlated: political leaning derived from age + district bias + noise; issue stances derived from leaning. Seeded deterministically (PRNG) — not random per boot.
- Cost shown BEFORE running via `/simulations/estimate` (token-count × per-model price). gpt-5-mini ≈ $0.29, gpt-5-nano ≈ $0.06, gpt-5 ≈ $1.44 for a 500-agent run.
- Calibration data is illustrative: calibrated error is consistently lower than raw error to demonstrate the validation loop.
- **시뮬레이션 결과 보존**: `simulation_responses`는 `district/ageBracket/gender/politicalLeaning`을 응답 시점에 스냅샷으로 저장한다. `GET /simulations/:id` 집계는 절대 라이브 `agents` 테이블과 조인하지 않는다 — 그래야 인구 재생성(`/admin/population/regenerate`, agents 전체 교체 + id 시퀀스 리셋) 후에도 과거 시뮬레이션 집계가 변하지 않는다. 새 `politicalLeaning` 컬럼 추가 시 기존 행은 agents에서 백필했다.
- 인구 재생성은 단일 트랜잭션에서 agents 삭제 → `agents_id_seq` 리셋 → `generateAgents(count)` 재삽입으로 원자적으로 수행한다. count 범위 50~5000.
- 관리자 라우트(`/api/admin/*`)에는 인증이 없다 — 전체 앱이 사용자 계정/세션이 없는 데모이기 때문. 실서비스 배포 시 admin 인증 추가 필요(현재 범위 외).

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
