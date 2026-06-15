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

- DB schema (source of truth): `lib/db/src/schema/*.ts` (agents, surveys, simulations, simulationResponses, calibrations)
- API contract (source of truth): `lib/api-spec/openapi.yaml` → generates `@workspace/api-zod` + `@workspace/api-client-react`
- Backend routes: `artifacts/api-server/src/routes/*.ts`
- Cost estimator: `artifacts/api-server/src/lib/pricing.ts`
- LLM run engine: `artifacts/api-server/src/lib/simulationEngine.ts`
- Frontend pages: `artifacts/demos/src/pages/*`

## Architecture decisions

- Drizzle returns `Date` objects but generated Zod response schemas expect `string`; routes pass DB rows through `jsonReady()` (`lib/serialize.ts`, a JSON round-trip) before `.parse()`.
- Simulation runs are fire-and-forget: `/simulations/:id/run` sets status `running`, kicks off `runSimulation()` un-awaited, returns 202; frontend polls `GET /simulations/:id` for progress.
- Agent attitudes are synthetic but correlated: political leaning derived from age + district bias + noise; issue stances derived from leaning. Seeded deterministically (PRNG) — not random per boot.
- Cost shown BEFORE running via `/simulations/estimate` (token-count × per-model price). gpt-5-mini ≈ $0.29, gpt-5-nano ≈ $0.06, gpt-5 ≈ $1.44 for a 500-agent run.
- Calibration data is illustrative: calibrated error is consistently lower than raw error to demonstrate the validation loop.

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
