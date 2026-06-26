---
name: Auto self-learning loop concurrency
description: Why the learning cycle claims candidates and why approve must guard status — concurrency/idempotency rules for the 자가학습 루프.
---

# Auto self-learning loop — concurrency & idempotency

The 자가학습 루프 promotes user "contributions" into the **global** synthetic
population baseline (cumulative offsets stored on the latest `accuracy_snapshots`
row, read back by `populationData.buildGenerationInputs` for user 0). Two paths
mutate that shared baseline: the auto-cycle and admin approve.

## Rule 1 — claim candidates atomically before processing
`runLearningCycle()` must select-and-claim in a **single** `UPDATE ... SET
status='processing' WHERE status='candidate' RETURNING *`, not a plain SELECT.

**Why:** every `POST /learning/contributions` triggers an inline auto-cycle, so
two near-simultaneous submissions race. With a plain SELECT both cycles see the
same candidate set → double-promote (offset counted twice) and both call
`applyOffsetsAndSnapshot` → duplicate `cycle` numbers. The atomic claim means the
loser claims 0 rows and falls into the empty-branch early return (no snapshot, no
offset change). `status` is a free string in the OpenAPI schema (`{type: string}`),
so the transient `processing` value does not break Zod response parsing; every
claimed row is reassigned a terminal status (promoted/quarantined/flagged) by
cycle end.

## Rule 2 — approve must guard status (idempotency)
`approveContribution(id)` must do a conditional `UPDATE ... WHERE id=? AND status
IN ('flagged','quarantined') RETURNING *` and bail (return null → route 404) when
0 rows match. **Why:** the offset is re-accumulated every approve; re-approving an
already-`promoted` row would shift the global baseline twice on an admin retry.
Only flagged/quarantined are eligible for manual review per the product contract.

## Known demo limitation (not fixed)
Concurrent **admin** actions (manual run + approve at the same instant) can still
collide on `cycle` numbering — there is no unique index on `accuracy_snapshots.cycle`.
Acceptable for a single-operator demo; if it ever becomes multi-admin, add a unique
index + transactional cycle assignment.

## Prod DDL/seed operational note
prod Neon is a separate DB; `executeSql` in code_execution is dev-only and the
sandbox root has no `pg`. Run prod DDL/seed via a node CJS script placed **inside
`lib/db/`** (CJS `require('pg')` resolves from the script's own dir, and only
`lib/db` declares `pg`). Connection string assembled from `PROD_NEON_PASSWORD`.
Canonical seed is idempotent: `scripts/src/seed-learning.ts` (post-merge), skips
when any `accuracy_snapshots` exist.
