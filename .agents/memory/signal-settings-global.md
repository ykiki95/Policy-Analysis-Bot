---
name: Signal ingest settings are global
description: Signal settings/batches are a shared global resource, not per-tenant, despite a per-user schema column.
---

신호 인제스트(signals)는 다른 per-user 데이터와 달리 **전역 공용** 리소스다.
- 설정(`signal_settings`)은 단일 canonical 행을 쓴다 = **가장 낮은 id 의 행**(`getGlobalSettings()`). 없으면 1행 생성.
- 읽기(GET settings/list/:id)는 tenant 필터를 걸지 않는다 — 모든 사용자가 같은 신호를 본다.
- 변경은 admin 전용(PUT `/admin/signals/settings` upsert, 자동수집/리셋). 비관리자 설정 PUT 은 없다.
- `reset`은 **전체** `signal_batches`를 지우고 재시드한다(테넌트 스코프 아님).

**Why:** 투자자 데모에서 신호 인제스트는 "플랫폼 공통 시그널" 컨셉이라 계정별로 갈라지면 안 됨. 시뮬레이션/agents 등 진짜 per-user 자산과는 다른 모델.

**How to apply:** signals 라우트에 tenant 필터를 다시 넣지 말 것. 스키마의 `signal_settings.userId unique` 는 레거시 흔적 — 런타임은 lowest-id 단일행을 신뢰한다. 정규화(단일 전역 레코드 마이그레이션)는 미적용 상태로, 다중 행이 생기면 lowest-id 가 기준이 된다.
