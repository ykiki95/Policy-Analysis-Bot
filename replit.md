# Synthetic Electorate Intelligence (DEMOS)

Aaru 스타일 합성 인구 시뮬레이션 SaaS. 서울 거주 합성 시민(에이전트)에게 정책·메시지·신제품을 제시해 반응을 LLM으로 예측하고, 과거 가상 이벤트·실제 선거로 보정·검증하는 데모 플랫폼. 제품 라인: Lumen(비즈니스), Seraph(정부), Dynamo(정치).

> 이 문서는 **고수준 안내서**입니다. 구체적 동작은 코드가 source of truth — 여기엔 "어디에 무엇이 있는지"와 "코드만 봐선 알기 어려운 결정·함정"만 적습니다.

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — API 서버
- `pnpm --filter @workspace/demos run dev` — 웹 프런트
- `pnpm run typecheck` — 전체 타입체크 / `pnpm --filter @workspace/demos run typecheck` — 프런트만
- `pnpm --filter @workspace/api-spec run codegen` — OpenAPI → hooks + Zod 재생성
- `pnpm --filter @workspace/db run push` — DB 스키마 push (**dev 전용**)
- Required env: `DATABASE_URL`, `AI_INTEGRATIONS_OPENAI_BASE_URL`, `AI_INTEGRATIONS_OPENAI_API_KEY`
- 선택 env: `DATA_GO_KR_API_KEY` (실제 개표결과 import 시)

### 프로덕션 DB (비자명 — 주의)

- 배포(Autoscale) 앱은 **외부 Neon**을 쓴다. dev DB와 별개라 스키마 변경을 **prod에 직접** 적용해야 한다(post-merge `db push`는 dev만 건드림).
- prod 접속 string은 `PROD_NEON_PASSWORD`로 조립: `postgresql://neondb_owner:<PROD_NEON_PASSWORD>@ep-autumn-mouse-aokb8kk0.c-2.ap-southeast-1.aws.neon.tech/neondb?sslmode=require`.
- `PROD_DATABASE_URL` 환경변수는 표준 postgres URL이 아닌 **불투명 토큰**이라 직접 연결 불가.

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5 / DB: PostgreSQL + Drizzle ORM
- Frontend: React + Vite + wouter + TanStack Query + recharts + shadcn/ui
- Validation: Zod (`zod/v4`) / API codegen: Orval (OpenAPI 기반)
- LLM: OpenAI via Replit AI Integrations proxy (gpt-5 / gpt-5-mini / gpt-5-nano)

## Where things live

소스 오브 트루스:
- DB 스키마: `lib/db/src/schema/*.ts`
- API 계약: `lib/api-spec/openapi.yaml` → `@workspace/api-zod` + `@workspace/api-client-react` 생성
- 백엔드 라우트: `artifacts/api-server/src/routes/*.ts` / 프런트 페이지: `artifacts/demos/src/pages/*`

핵심 엔진·코어(`artifacts/api-server/src/lib/`):
- `agentGenerator.ts` — 결정론적 에이전트 생성(서울 25개 구 중심 + 상관된 태도, mulberry32 PRNG). 정치·소비·정책 태도는 **각자 독립 PRNG 스트림**(XOR seed 분리)이라 트랙 추가가 기존 스트림을 흔들지 않음.
- 설문→페르소나 가중: `surveyWeighting.ts`(정치 5이슈), `consumerWeighting.ts`(Lumen 소비 5축), `policyWeighting.ts`(Seraph 정책 5축). `appliedToPopulation=true`인 설문만 도메인별로 반영.
- `simulationEngine.ts` — LLM 실행 엔진(표본추출·배치 tick·집계) / `pricing.ts` — 실행 전 비용 추정.
- `calibrationModel.ts`(출력 보정 Lever 2) + `calibrationWeighting.ts`(입력 보정 Lever 1) — 보정 피드백 루프.
- `autoLearning.ts` — 자동 자가학습 루프 코어(아래 별도 설명) / `dataGoKr.ts` — 실제 선거 데이터 연동.

프런트 공유 로직:
- `lib/cost.ts` — **화면 비용 표시 배수(×10) 단일 출처**. 모든 비용 표시·입력은 이 헬퍼 경유(직접 `*10` 금지). 실비 원복 = 상수 1로.
- `lib/accuracyTrend.ts` `useAccuracyTrend()` — 대시보드와 보정 페이지가 공유하는 정확도 추이 계산(중복 로직 금지).
- `lib/tracking.ts` — 접속 분석 비콘 / Map: Leaflet + OpenStreetMap(API 키 불필요).

## 주요 서브시스템

### 자동 자가학습 루프 (`autoLearning.ts` + `routes/learning.ts` + `pages/learning/index.tsx`)

사용자/관리자가 관찰한 현실 신호를 **기여**로 제출 → 제출 시 자동 사이클:
1. **정합성 체크** — 표본 0·관찰값 범위 이탈·과대 편향 등은 `flagged`(관리자 검토 대기).
2. **강건 집계** — 평판·신뢰도·최신성 가중 + 가중중앙값(이상치 강건) + clamp.
3. **검증 게이트** — 정치는 실제 선거 ground-truth(`elections`) 대비 오차가 줄 때만 승격, 아니면 `quarantined`. 소비/정책은 현실 정답이 없어 **합의(consensus)** 기준으로 승격(예시지표는 illustrative).
4. 승격분을 누적 offset에 반영 → 전역 인구 **고정 시드 재생성**(offset 변화만 정확도에 반영) → `accuracy_snapshots` 기록.
5. 평판 갱신. 관리자는 flagged 소수만 수동 결정.

- 관리자 결정: `approve` / `reject` / `requeue`(실수로 기각한 rejected를 검토 큐로 되돌림 — rejected만 대상, 전역 인구 불간섭).
- **누적 offset 출처**: 최신 `accuracy_snapshots.offset*` (별도 settings 행 없음). 전역(0) 사용자 인구 생성 시 가산.
- 도메인↔제품: political→Dynamo, commercial→Lumen, policy→Seraph.
- 시드: `scripts/src/seed-learning.ts`(post-merge canonical, 멱등).
- **데모 주의**: 정치 오차만 실제 선거 대비 측정. 소비/정책 지표는 illustrative.

### 실제 선거 데이터 연동 (`dataGoKr.ts`)

- 중앙선관위 투·개표 API(data.go.kr). 대선·지방(광역단체장)·총선(비례) 3타입을 단일 함수로 처리.
- 보수 진영 정당명은 **선거마다 다르다**(대선·지방=국민의힘, 비례 22대=국민의미래, 21대=미래한국당) → `SUPPORTED_ELECTIONS`에 선거별로 박아둠(모듈 상수 금지).
- **진영 판정은 `actual_winner`(실제 1위) 기준** — 득표율 임계값(>50%) 금지(강원·울산은 보수가 <50%로 1위).
- 17개 시·도 완전성 검증 통과 후에만 ground-truth 교체. numOfRows 100 캡 → 페이지네이션. 제7회 지방선거는 일부 시·도 후보 미출마로 제외.
- 시드: `scripts/src/seed-elections.ts`. 라우트: `admin.ts` elections sources/import.

### 보조 데모 기능

- **실시간 신호 인제스트**(투자자 데모): 배치 CRUD는 실제, 효과 수치는 결정론적 목업(`signalMock.ts`). 엔진/보정 미수정. 전역 공유(userId=0).
- **접속 분석**(관리자 전용): `analytics.ts` + `routes/track.ts`(익명 허용, IP rate-limit) + admin `/admin/analytics`. 위치조회는 ip-api 무료(HTTP). **데모 한계**: 무료티어 HTTP·IP 헤더 스푸핑 가능(외부는 Cloudflare Worker 경유라 cf-connecting-ip 신뢰).
- **데모용 평문 비밀번호 미러**(`users.passwordPlain`): admin 화면에서 계정 비밀번호 표시용. **프로덕션 안전하지 않음 — 데모 전용**.

> 신호·분석 테이블은 drizzle push가 비TTY 셸에서 막혀 **raw DDL(executeSql)**로 생성했다(dev·prod 모두).

## Architecture decisions (코드만 봐선 모를 결정)

- **Date 직렬화**: Drizzle는 `Date`를 반환하나 생성된 Zod 응답 스키마는 `string` 기대 → 라우트가 `jsonReady()`(`lib/serialize.ts`)로 JSON 라운드트립 후 `.parse()`.
- **큐 + 실행 드라이버 분리**: `/simulations/:id/run`은 실행하지 않고 enqueue만(202). 진행은 배포 모델에 따라 둘:
  - dev: 상시 워커 폴링 루프가 끝까지 실행.
  - prod(Autoscale): 워커 꺼짐. 프런트 진행률 화면이 열려 있는 동안만 `POST /tick`으로 소량씩 전진(탭 닫으면 일시정지, 다시 열면 resume). 유휴 시 0으로 축소돼 화면 보는 동안만 비용.
- **claim = DB lease**: 워커·tick 모두 조건부 `UPDATE ... RETURNING`로 원자적 claim(`FOR UPDATE SKIP LOCKED` / heartbeat 만료 고아 회수). claim 실패 시 즉시 반환 → 다중 인스턴스에서도 한 sim을 한 인스턴스만 전진(중복 LLM 호출 방지). 모든 post-claim tick write는 **lease-conditional**(stop이 원자적으로 이김).
- **내구성 실행**: 항상 resume 모드. 에이전트 응답을 평가 즉시 증분 insert + `(simulation_id, agent_id)` 유니크 + `onConflictDoNothing`으로 멱등. 최종 집계는 항상 DB 전체에서 재계산.
- **데이터 공유 모델(역할 기반)**: 합성 학습 인구·학습 입력은 **전역 공유**(소유자 `GLOBAL_LEARNING_USER_ID=0`, 로그인 불가 sentinel), 시뮬레이션만 **계정별**.
  - 전역 자산 쓰기는 전부 admin 전용. `adminRouter`는 전역 게이트 없이 마운트되므로 **새 학습-데이터 mutation 추가 시 핸들러별 `requireAdmin` 누락 주의**.
  - 전역 자산 조회/삭제는 `tenantId(req)`가 아니라 `GLOBAL_LEARNING_USER_ID`로 필터.
  - 각 시뮬은 전역 인구(0)에서 sampleSize만큼 **결정론적 표본추출**(`md5` 정렬)해 실행.
- **예산 한도**(`lib/budget.ts`): enqueue 시 트랜잭션 안에서 사용자 행 `FOR UPDATE` 잠그고 "확약 지출"(완료=실비, 대기/실행=`max(actual,estimate)` 예약분) 합산 검사. 초과 시 402. 서버·DB·API는 **항상 실비만** 반환(표시 배수는 프런트 `cost.ts`에서만).
- **시뮬레이션 결과 보존**: `simulation_responses`는 district/age/gender/leaning을 **응답 시점 스냅샷**으로 저장. `GET /simulations/:id` 집계는 라이브 `agents`와 조인하지 않음 → 인구 재생성 후에도 과거 집계 불변.
- **인구 재생성**: 단일 트랜잭션에서 **해당 user의 agents만** 삭제 → 재삽입(글로벌 `agents_id_seq` 리셋 없음 — 멀티테넌시). count 50~5000.
- **인증/인가**: 커스텀 express-session(Clerk 아님, `lib/tenant.ts`). `/api/admin/*`는 `requireAdmin`. connect-pg-simple은 `createTableIfMissing:false` + 수동 `session` 테이블 필요.
- **관리자 "계정 보기 전환"(view-as)**: UI 게이팅은 `isAdmin && selectedAccountId==null`. **UI 편의일 뿐, 백엔드 인가는 그대로 `requireAdmin`** — 전환해도 admin 세션은 admin.
- **합성 태도**: synthetic이나 상관됨(정치성향=나이+지역편향+노이즈, 이슈는 성향에서 파생). PRNG 시드 결정론 — 부팅마다 랜덤 아님.
- **보정 데이터는 illustrative**: 보정 오차가 항상 원시보다 낮게 나오도록 설계(루프 시연용). 단 선거 검증 ground-truth는 admin import로 실제 개표결과 대체 가능.

## Product (화면)

- 대시보드 / 합성 인구(서울 지도 + 인구통계) / 설문·태도 / 시뮬레이션(비용추정→실행→결과) / 보정·검증 / 자가학습 루프 / 제품 라인업(Lumen·Seraph·Dynamo)

## User preferences

- 모든 UI 카피는 한국어로 작성한다.
- 사용자에게는 한국어로 응답한다.

## Gotchas

- `audience` 값은 한국어("비즈니스"/"정부"/"정치"), `product`는 영문("Lumen"/"Seraph"/"Dynamo") — 시드/폼 일치.
- 시드 데이터는 `code_execution` 샌드박스 `executeSql`로 생성. text[]는 배열 리터럴 + `::text[]`, jsonb는 `JSON.stringify` + `::jsonb`.
- 실제 500콜 LLM 실행은 비용 발생 → 테스트는 estimate + 시드된 완료 시뮬레이션으로 검증.
- OpenAPI 요청 바디 컴포넌트는 `XxxInput`으로 명명(`XxxBody`는 zod const ↔ TS interface 충돌 TS2308).
- rate limiter는 **라우트별로** 스코프(경로 없는 `router.use(limiter, ...)`는 전체 /api를 throttle해 prod 폴링/tick에서 429 폭주).

## Pointers

- 워크스페이스 구조·TypeScript·패키지는 `pnpm-workspace` 스킬 참고.
