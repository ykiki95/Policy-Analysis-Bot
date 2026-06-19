---
name: Admin vs user feature parity
description: Which DEMOS features are self-service (identical for users & admins) vs admin-only, and why.
---

# Admin vs user feature parity

The `/admin` ("설정" for non-admins) page tabs 인구 구성 → 데이터 출처 → 설문 업로드 → 보정 설정 → 검증 이벤트 are **self-service** and must render **identically** for regular users and admins. Only **계정 관리 (accounts)** is admin-only.

**Rule:** any feature that mutates *shared/global* ground-truth (the `elections` table — real 개표결과 import) stays admin-only and lives inside the admin-only 계정 관리 tab, NOT in a shared tab.

**Why:** election import overwrites the global `elections` ground-truth shared by all tenants, so one user's import would change everyone's validation. Per-user data (agents/surveys/calibrations/calibration events) is genuinely self-service and belongs in the shared tabs. User explicitly confirmed (2026-06) the want for shared-tab parity + keeping election import admin-only.

**How to apply:** when adding a new admin-page feature, ask "does it write per-user data or global/shared data?" Per-user → shared tab (no `isAdmin` gate). Global/shared mutation → admin-only (`{isAdmin && ...}` + a `requireAdmin` backend route).
