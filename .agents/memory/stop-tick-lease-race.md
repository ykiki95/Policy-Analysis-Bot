---
name: Stop vs in-flight tick lease race
description: Why every post-claim write in the tick batch driver must be lease-conditional, and why stop must not clear costActualUsd.
---

# Stop vs in-flight tick lease race

In the B1 client-driven tick model a user can stop a simulation (reset to
`pending`, release the lease) while a `processSimulationBatch` is mid-flight. The
batch's heavy LLM work happens between claim and the final DB writes.

**Rule: every DB write a tick batch makes *after* claiming the lease must be
lease-conditional** (`WHERE id AND lockedBy = TICK_WORKER_ID`): the pre-batch
metadata update, the post-batch progress update, the completion/finalize update,
and the failure-catch update. A bare re-`SELECT` check is not enough — there is a
check-then-write gap. Make the writes themselves conditional and treat 0 rows
affected as "lease lost → stop won, exit without writing".

**Why:** an unconditional `UPDATE ... WHERE id` can resurrect a just-stopped
(`pending`) sim into `running`/`completed`/`failed`, or leave a `pending` sim with
stale progress/heartbeat. "Stop wins" must be atomic at every write site.

**How to apply:** `finalizeSimulation` is shared with the always-on worker
(`runSimulation`); give it an optional `requireLockedBy` param — tick passes
`TICK_WORKER_ID`, worker omits it (unconditional, unchanged). Don't bake the lease
condition into finalize's WHERE unconditionally or you break the worker path.

**Budget invariant:** stop (and run) must NOT clear `costActualUsd`. That field is
written only at completion (never partially mid-run), so it represents confirmed
lifetime spend. Clearing it on a completed→rerun(queued)→stop path erases history
and bypasses the cumulative budget cap (committedSpend sums actual for non
queued/running, and max(actual,estimate) for queued/running).
