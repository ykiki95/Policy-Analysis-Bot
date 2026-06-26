# Synthetic Electorate Intelligence (DEMOS)

Aaru 스타일 합성 인구 시뮬레이션 SaaS. 서울 거주 합성 시민 500명(에이전트)에게 정책·메시지·신제품을 제시해 반응을 LLM으로 예측하고, 과거 가상 이벤트로 보정·검증하는 데모 플랫폼. 제품 라인: Lumen(비즈니스), Seraph(정부), Dynamo(정치).

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server
- `pnpm --filter @workspace/demos run dev` — run the web frontend
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm --filter @workspace/demos run typecheck` — typecheck just the frontend
- `pnpm --filter @workspace/api-spec run codegen` — regenerate hooks + Zod from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- 프로덕션 DB는 외부 Neon(배포 Autoscale 앱이 사용). 스키마 변경(raw DDL) 적용은 `lib/db` 디렉터리에서 `pg`로 직접 연결 — connection string은 `PROD_NEON_PASSWORD`로 조립(`postgresql://neondb_owner:<PROD_NEON_PASSWORD>@ep-autumn-mouse-aokb8kk0.c-2.ap-southeast-1.aws.neon.tech/neondb?sslmode=require`). **주의**: `PROD_DATABASE_URL` 환경변수는 표준 postgres URL이 아닌 불투명 토큰이라 직접 연결 불가. dev DDL과 별도로 prod에 직접 적용해야 한다(post-merge `pnpm --filter db push`는 dev만).
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
- 자동 자가학습 루프: `artifacts/api-server/src/lib/autoLearning.ts` (코어) + `routes/learning.ts` (라우트) + `pages/learning/index.tsx` (화면, 네비 "자가학습 루프"/Sparkles). 흐름: 사용자/관리자가 관찰한 현실 신호를 **후보 기여**(`learning_contributions`)로 제출 → 제출 시 자동 사이클(`runLearningCycle`). (1) **정합성 체크**(`anomalyReason`): 표본 0/관찰값 범위 이탈/편향 >40%p/제안 이동량 과대 → `flagged`(관리자 수동 검토 대기). (2) **강건 집계**: 도메인별로 평판(`contributor_reputation`)·신뢰도(`reliability`=√(sampleSize/500))·최신성(`recency`=exp(-ageDays/30)) 가중 + **가중중앙값**(이상치 강건) + clamp(정치 ±25 leaning / 소비·정책 ±15 stance, 누적 ±35/±20). (3) **검증 게이트**: 정치는 실제 선거 ground-truth(`elections`) 대비 `evaluateGlobalError`가 줄 때만(`newError ≤ baseError + GATE_EPSILON`) 승격, 아니면 `quarantined`. 소비/정책은 현실 정답 부재라 **합의(consensus)**(중앙값 동일부호 비율 ≥0.5 & |agg|≥1)로 승격 + 예시지표(`15-|offset|*0.6` clamp 3..15). (4) 승격분을 누적 offset에 반영 → 전역 인구 **고정 시드(GLOBAL_SEED=1234) 재생성**(offset 변화만 정확도에 반영) → `accuracy_snapshots` 기록(`applyOffsetsAndSnapshot`: snapshot insert **먼저**(buildGenerationInputs가 읽음) → 재생성 → 오차 측정 후 update). (5) 평판 갱신(`bumpReputation`, helpful/harmful → reputation=clamp((h+1)/(harm+1),0.2,2)). 관리자는 flagged 소수만 `approveContribution`/`rejectContribution`. 도메인↔제품: political→Dynamo, commercial→Lumen, policy→Seraph. **누적 offset 출처**: 최신 `accuracy_snapshots.offset*` (별도 settings 행 없음) — `populationData.buildGenerationInputs`가 전역(0) 사용자일 때 `loadAutoLearnedOffsets`로 읽어 가산. 시드: `scripts/src/seed-learning.ts`(post-merge canonical, 멱등 — 스냅샷 존재 시 skip). 라우트는 `requireAuth` 뒤, admin 전용은 `requireAdmin`. **데모 주의**: 소비/정책 예시지표·calibratedError(=rawError*0.6)는 illustrative; 정치 오차만 실제 선거 대비 측정.
- 실제 선거 데이터 연동: `artifacts/api-server/src/lib/dataGoKr.ts` (중앙선거관리위원회 투·개표 정보 API / data.go.kr). **3개 선거 타입 지원** — 대통령선거(sgTypecode=1)·지방선거 광역단체장(=3)·국회의원선거 비례대표(=7). 모든 타입이 동일 응답 구조(jd/hbj/dugsu/yutusu)라 단일 일반화 함수 `fetchConservativeShares(sgId)`가 선거별 `sgTypecode`+`conservativeParty`로 처리. 보수 진영 정당명은 선거마다 달라(대선·지방=국민의힘, 비례 22대=국민의미래, 21대=미래한국당) `SUPPORTED_ELECTIONS`에 선거별로 박아둔다(모듈 상수 금지). 관리자가 선거를 골라 실제 시·도별 보수 진영 득표율(dugsuNN/yutusu)을 불러와 해당 선거(electionDate)의 `elections` ground-truth만 교체(타 선거 불간섭). **진영 배지는 `actual_winner`(실제 1위 진영) 기준** — 득표율 임계값(>50%) 금지(강원·울산은 보수 후보가 <50%로 1위). import는 전 후보 dugsuNN 최대 득표수 비교로 winner 판정. **metric 라벨은 시·도 전역에서 참인 정당명만 사용**(지방선거는 시·도마다 후보가 달라 특정 후보명 공통 저장 금지). 제7회(2018) 지방선거는 자유한국당이 광주·전남에 광역단체장 후보를 안 내 17개 시·도 완전성 미달 → 자동 연동 대상 제외. 시드: `scripts/src/seed-elections.ts`(post-merge canonical). numOfRows 100 캡 → 페이지네이션, 17개 시·도 완전성 검증 통과 후에만 교체. 라우트: `admin.ts` GET `/admin/elections/sources`, POST `/admin/elections/import`. 프런트: `admin/index.tsx` 선거 백테스트 탭의 ElectionImportSection.
- 실시간 신호 인제스트(투자자 데모, "데모 · 향후 구현"): 배치 CRUD/영속화는 실제, 효과 수치(sentiment·before/after·summary)는 결정론적 목업(실제 스크래핑/외부 API 없음, 엔진/보정 미수정). 스키마 `lib/db/src/schema/signalBatches.ts`(signal_batches, 전역 공유 userId=0), 목업 `artifacts/api-server/src/lib/signalMock.ts`(FNV-1a+mulberry32, source/product/title 결정론 → userId 무관), 라우트 `artifacts/api-server/src/routes/signals.ts`(GET `learningReadIds` union(0,me) 읽기, POST `/admin/signals` requireAdmin+userId=0), 프런트 `artifacts/demos/src/pages/signals/index.tsx`(KPI+제품별 LineChart+목록+상세 Dialog+관리자 새 배치 Dialog). drizzle push가 비TTY 셸에서 막혀 테이블은 raw DDL(executeSql)로 생성.
- 접속 분석(관리자 전용): 외부 공개 서비스의 접속 현황 집계(비로그인 방문 포함). 스키마 `lib/db/src/schema/analytics.ts`(`access_events` 이벤트 스트림 + `ip_geo` 위치 캐시, drizzle push가 비TTY 셸에서 막혀 dev·prod 모두 raw DDL로 생성). 수집 유틸 `artifacts/api-server/src/lib/analytics.ts`(`parseUserAgent`=ua-parser-js, `getClientIp`=cf-connecting-ip>x-forwarded-for>req.ip, `recordEvent`, `HEARTBEAT_SECONDS=20`). 위치조회 `lib/geoLookup.ts`(ip-api.com **무료 배치 = HTTP only**, 캐시 + 사설IP 스킵, admin 조회 시 미해결 IP만 lazy 배치 해결). 수집 라우트 `routes/track.ts`(POST `/track`, requireAuth **이전** 마운트해 익명 허용, `trackLimiter`로 IP당 60req/분 — 공개 write 엔드포인트 남용/지표오염 방어). 로그인 성공/실패는 `routes/auth.ts`가 `access_events`에 기록. 집계 라우트 `routes/admin.ts` GET `/admin/analytics?days`(requireAdmin) — 세션 CTE 기반 summary/accounts/anonymous/devices/browsers/menus/locations/sessions(최대 200)/daily 반환(login 이벤트는 세션 체류시간 집계에서 제외). 프런트 비콘 `artifacts/demos/src/lib/tracking.ts`(clientId=localStorage / sessionId=sessionStorage, pageview + 20s heartbeat + pagehide sendBeacon), `App.tsx`의 RouteTracker가 wouter 라우트 변경마다 pageview. 관리자 탭 `pages/admin/index.tsx`의 AnalyticsSection(KPI + 일별 AreaChart + 메뉴/위치/계정/세션 테이블). **알려진 한계(데모)**: ip-api 무료티어는 HTTP라 방문자 IP가 평문 전송되며, Replit URL 직접 호출 시 IP 헤더 스푸핑 가능(외부 노출은 Cloudflare Worker 경유라 cf-connecting-ip 신뢰 가능).
- Admin routes: `artifacts/api-server/src/routes/admin.ts` (인구 재생성, 데이터 출처, 설문 업로드, 보정 설정, 선거 데이터 import)
- Frontend pages: `artifacts/demos/src/pages/*` (관리자 페이지: `pages/admin/index.tsx`)
- 정확도 추이 공유 훅: `artifacts/demos/src/lib/accuracyTrend.ts` (`useAccuracyTrend()` — 검증 이벤트를 기준일 오름차순 정렬해 원시·보정 오차/정확도 포인트 + 집계 반환). 대시보드 정확도 추이와 보정 페이지 학습 탭 상단의 "정확도 추이(학습 효과)" 라인차트가 동일 데이터·계산을 공유(중복 로직 금지).
- Map: Leaflet + react-leaflet + OpenStreetMap 타일 (API 키 불필요), `pages/population/index.tsx`의 `CircleMarker` 산점도

## Architecture decisions

- Drizzle returns `Date` objects but generated Zod response schemas expect `string`; routes pass DB rows through `jsonReady()` (`lib/serialize.ts`, a JSON round-trip) before `.parse()`.
- **큐 + 실행 드라이버 분리**: `/simulations/:id/run`은 실행하지 않고 enqueue 만 한다(예산 검사 통과 시 status `queued`로 전환 + 이전 실행의 `simulation_responses`를 비워 깨끗한 (재)시작 보장, 202 반환). 실제 LLM 실행을 진행시키는 드라이버는 배포 모델에 따라 둘이다. 프런트는 `GET /simulations/:id`로 진행률 폴링.
  - **개발(`NODE_ENV!=='production'`)**: 항상 가동되는 워커 폴링 루프(`lib/worker.ts`, 부팅 시 `index.ts`의 `startSimulationWorker()`로 1회 기동)가 `runSimulation(id,{resume:true})`로 끝까지 실행.
  - **프로덕션(Autoscale, B1 = 클라이언트 구동)**: 워커는 꺼진다(`index.ts`가 prod 에서 기동 안 함). 프런트 진행률 화면(`simulations/detail.tsx`)이 살아 있는 동안만 `POST /simulations/:id/tick`을 주기(1.5s) 호출 → `simulationEngine.ts`의 `processSimulationBatch(id,{maxAgents})`가 한 번에 `TICK_MAX_AGENTS`(기본 16, env 조정)만큼만 전진. 탭을 닫으면 일시정지, 다시 열면 resume. Autoscale 은 유휴 시 0으로 축소돼 사용자가 화면을 보는 동안만 비용이 든다.
- **claim = DB lease (두 드라이버 공통)**: 워커는 `UPDATE simulations ... WHERE id = (SELECT ... FOR UPDATE SKIP LOCKED LIMIT 1) RETURNING id`; tick 경로(`processSimulationBatch`)도 동일 규약의 조건부 `UPDATE ... SET locked_by=TICK_WORKER_ID ... WHERE status='queued' OR (running AND (우리 소유 OR locked_by NULL OR heartbeat 만료)) RETURNING id`로 원자적 claim 후 `running`으로 전환하고 `locked_by/locked_at/heartbeat_at`를 찍는다. claim 대상 = `status='queued'` 신규 OR `status='running'`이지만 heartbeat 만료(STALE_MS=60s)된 고아(크래시/재배포/탭 종료). claim 실패 시 즉시 반환 → Autoscale 다중 인스턴스에서도 한 sim 을 한 인스턴스만 전진(중복 LLM 호출 방지). 배포는 `autoscale` 타입.
- **시뮬레이션 실행 내구성(durable execution)**: 워커는 항상 resume 모드(`runSimulation(id, {resume:true})`)로 실행한다. 각 에이전트 응답을 평가 직후 즉시 `simulation_responses`에 증분 insert(끝에 일괄 저장 X), `(simulation_id, agent_id)` 유니크 인덱스 + `onConflictDoNothing`으로 멱등. 이미 응답 있는 에이전트는 skip, 남은 것만 처리. 최종 집계(`finalizeSimulation`)는 항상 DB 전체 응답에서 재계산하므로 fresh/resume 경로가 동일. resume 비용은 이전 세션 토큰을 복구할 수 없어 `alreadyDone===0`(이번 세션이 전체를 커버)일 때만 토큰 실비용을 쓰고 아니면 추정치로 보정.
- **데이터 공유 모델(역할 기반)**: 합성 학습 인구·학습 입력은 **전역 공유**, 시뮬레이션만 계정별이다.
  - 전역 공유(소유자 `GLOBAL_LEARNING_USER_ID = 0`, sentinel `users.id=0` role `system` 로그인 불가): `agents`(합성 학습 인구), `surveys`, `calibrations`(정확도검증), `calibrationSettings`(단일 0행), `surveyUploads`, `signal_batches`. 관리자가 큐레이션 — **쓰기는 전부 admin 전용**(`routes/admin.ts` 의 population/regenerate·survey-uploads POST·calibration-settings PUT·calibrations POST/DELETE 등에 핸들러별 `requireAdmin`; adminRouter 는 전역 게이트 없이 마운트되므로 새 학습-데이터 mutation 추가 시 requireAdmin 누락 주의). 읽기는 전역(0) 또는 `lib/tenant.ts`의 `learningReadIds(req) = union(0, tenantId)`(본인 입력이 본인 예측에만 반영되는 미래 대비). 전역 자산의 조회/삭제는 `tenantId(req)` 가 아니라 `GLOBAL_LEARNING_USER_ID` 로 필터해야 한다.
  - 계정별(per-user, `userId` FK): `simulations`/`simulation_responses`. 각 시뮬은 전역 인구(0)에서 `totalAgents`(=폼의 sampleSize) 만큼 **결정론적 표본추출**해 실행 — `simulationEngine.ts` `selectSampledAgents(simId, n)`(`ORDER BY md5(id::text || ':' || simId::text) LIMIT n`)가 runSimulation·processSimulationBatch 공통. create 가 sampleSize 를 받아 clamp[1..전역인구]→totalAgents 저장, estimate 도 totalAgents 로 비용 산출.
  - 공용 데이터(regions/demographicMargins/elections/dataSources)는 종전대로 비-테넌트. `tenantId(req)`(세션 userId; admin은 `?accountId`로 타계정 지정)/`isAdmin(req)`로 스코프 결정. 인구 재생성은 전역(0) agents만 삭제·재삽입(글로벌 seq reset 없음). 기존 데이터는 전역(0)으로 백필됨.
- **예산 한도**: `lib/budget.ts`. 계정당 `users.budgetLimitUsd`(실제 USD). enqueue 시 `db.transaction` 안에서 사용자 행을 `FOR UPDATE` 잠그고 `assertWithinBudgetTx`로 검사 — "확약 지출"(완료=costActualUsd, 대기열/실행중=`max(actual,estimate)` 예약분)에 enqueue 시점 재계산 estimate(`countAgents`+`estimateCost`)를 더해 한도 초과면 402. **비용 표시 일원화**: 서버·DB·API 는 항상 실비(실제 USD)만 반환(`/budget`·402·admin 응답 모두 실비, `multiplier` 필드 없음). 화면 표시 배수(×10)는 프런트 단일 파일 `artifacts/demos/src/lib/cost.ts`(`COST_DISPLAY_MULTIPLIER`=10, `formatCost`/`toDisplayCost`/`toActualCost`)에서만 적용 — 모든 비용 표시·입력은 이 헬퍼를 거친다(직접 `*10` 금지). 실제 비용 원복 = 상수 1로. admin 한도 입력은 화면 단위를 `toActualCost`로 실비 환산 후 전송.
- Agent attitudes are synthetic but correlated: political leaning derived from age + district bias + noise; issue stances derived from leaning. Seeded deterministically (PRNG) — not random per boot.
- Cost shown BEFORE running via `/simulations/estimate` (token-count × per-model price). gpt-5-mini ≈ $0.29, gpt-5-nano ≈ $0.06, gpt-5 ≈ $1.44 for a 500-agent run.
- Calibration data is illustrative: calibrated error is consistently lower than raw error to demonstrate the validation loop. 단, 선거 검증(electionCalibration)의 ground-truth(`elections`)는 관리자 import를 통해 data.go.kr 실제 개표결과로 대체 가능하다 — 합성 인구 예측 vs 실제 선거결과 비교는 실데이터 기반.
- **시뮬레이션 결과 보존**: `simulation_responses`는 `district/ageBracket/gender/politicalLeaning`을 응답 시점에 스냅샷으로 저장한다. `GET /simulations/:id` 집계는 절대 라이브 `agents` 테이블과 조인하지 않는다 — 그래야 인구 재생성(해당 user agents 교체) 후에도 과거 시뮬레이션 집계가 변하지 않는다. 새 `politicalLeaning` 컬럼 추가 시 기존 행은 agents에서 백필했다.
- 인구 재생성은 단일 트랜잭션에서 **해당 user의 agents만** 삭제 → `generateAgents(count)` 재삽입으로 원자적으로 수행한다(글로벌 `agents_id_seq` 리셋 없음 — 멀티테넌시 때문). count 범위 50~5000.
- **인증/인가**: 커스텀 express-session(Clerk 아님, `lib/tenant.ts`). 관리자 라우트(`/api/admin/*`)는 `routes/index.ts`에서 `requireAdmin` 미들웨어로 보호한다. 인구 생성/설문 업로드/검증 이벤트 등 자기서비스 기능은 인증 사용자 본인 스코프; admin은 `?accountId`로 임의 계정 대상 가능. 회원가입/과금 UI는 향후 범위.
- **관리자 "계정 보기 전환"(view-as)**: 상단 `AccountSwitcher`(`use-account-switcher.tsx`의 `selectedAccountId`)로 admin이 다른 계정 관점으로 데이터·UI를 본다. 프런트 UI 게이팅은 `isAdmin && selectedAccountId==null`로 계산 — `layout.tsx`는 `effectiveIsAdmin`(좌측 메뉴 "관리자"↔"설정"·`ViewAsBanner`), `admin/index.tsx`는 같은 식으로 `isAdmin`을 섀도잉(관리자 전용 탭 signals/accounts/analytics 숨김). Admin 탭은 controlled(`activeTab` state)라 전환으로 탭이 사라지면 `population`으로 폴백. **이는 UI 편의일 뿐, 백엔드 인가는 그대로 `requireAdmin` — 전환해도 admin 세션은 admin**. 스위처는 본인·id≤0·role=system 제외. 시스템 sentinel은 테넌트 스코프(`withTenant`가 `accountId>0`만 적용) 밖이라 전환 대상이 아님.
- **데모용 평문 비밀번호 미러**: `users.passwordPlain`(nullable). signup(`auth.ts`)·admin reset(`admin.ts`, "1111")·profile change-password(`profile.ts`)가 해시와 함께 평문도 기록. GET `/admin/accounts`가 `password`(평문 or null) 반환 → `admin/index.tsx` AccountRow가 초기화 버튼 옆에 표시(없으면 "초기화 후 표시"). 기존 가입자(평문 미보유)는 null. reset 라우트는 `id≤0`/`role=system` 거부. **데모 전용 — 프로덕션 안전하지 않음**.

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
