---
name: Seed-data reproducibility
description: Reference/seed tables (regions, demographic_margins, real surveys) must be codified in a seed script, not one-off SQL, or fresh/prod environments break.
---

# Seed-data reproducibility

DB rows that the app *requires to function* must be created by a version-controlled
seed script, not by ad-hoc `executeSql` in the dev DB. Otherwise the data exists
only in the environment where it was typed and silently disappears on a fresh
checkout, a merge into a clean env, or production deploy.

**Why:** `regions` and `demographic_margins` were populated via one-off SQL when the
nationwide-raking work was built, but never codified. In a later session both tables
were empty, so `POST /admin/population/regenerate` returned `{total:0}` with **no
error** — `generateAgents` just produces nothing when `regionMarginals` is empty.
The whole app (dashboard, map, calibration) was effectively broken with no obvious cause.

**How to apply:**
- Anything used as a generation input or raking target (region metadata, demographic
  marginals, the canonical/real surveys + their data-source rows) belongs in a seed
  script under `scripts/src/` and should be wired into `scripts/post-merge.sh` so it
  runs after every merge.
- Make seeds **idempotent and scoped**: delete-then-insert only the canonical rows
  (e.g. surveys `WHERE is_real=true`, data_sources `WHERE category='여론조사'`) so
  user-created rows survive re-runs.
- The real-survey + data-source seed is codified (`scripts/src/seed-surveys.ts`,
  `pnpm --filter @workspace/scripts run seed:surveys`). `regions` /
  `demographic_margins` / `elections` are still NOT codified — if you touch
  population generation, codify those too.
