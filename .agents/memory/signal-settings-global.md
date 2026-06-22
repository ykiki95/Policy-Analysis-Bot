---
name: Signal settings global, batches tenant-scoped
description: signal_settings is a shared global resource; signal_batches are per-tenant (corrected from an earlier all-global design).
---

신호 인제스트(signals)는 **두 리소스를 다르게** 다룬다.

## 설정(`signal_settings`) — 전역 공용
- 단일 canonical 행 = **가장 낮은 id 의 행**(`getGlobalSettings()`). 없으면 1행 생성.
- 읽기(GET `/signals/settings`)는 tenant 필터 없음 — 모든 사용자가 같은 설정을 본다.
- 변경은 admin 전용(PUT `/admin/signals/settings` upsert). 비관리자 설정 PUT 없음.
- 스키마의 `signal_settings.userId unique` 는 레거시 흔적 — 런타임은 lowest-id 단일행을 신뢰.

## 배치(`signal_batches`) — 테넌트 스코프 (per-user)
- GET `/signals`(목록)·GET `/signals/:id`(단건)는 `userId = tenantId(req)` 로 필터한다.
- admin reset(POST `/admin/signals/reset`)은 **해당 테넌트의 배치만** 삭제 후 재시드(전체 삭제 아님).
- admin patch/delete(`/admin/signals/:id`)는 `id` + `userId = tenantId(req)` 소유권 조건 필수.
- 다른 per-user 자산(simulations/agents 등)과 동일한 멀티테넌시 패턴: `tenantId(req)` = 세션 userId, admin은 `?accountId` 로 타계정 지정.

**Why:** 초기엔 배치도 "플랫폼 공통 시그널"로 전역 처리했으나, 계정 간 데이터 누수(다른 테넌트 시그널이 섞여 보임)가 발생해 배치는 per-user 격리로 전환. 설정은 데모 단순화를 위해 전역 유지.

**How to apply:** signal_batches 읽기/변경에는 항상 tenant 조건을 건다. signal_settings 는 전역 lowest-id 단일행 모델 유지(여기엔 tenant 필터 넣지 말 것). 데모 시드 배치는 특정 데모 계정(예: test) 소유로 reset 재시드.
