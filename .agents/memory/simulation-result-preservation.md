---
name: Simulation result preservation
description: Why simulation aggregates must read snapshots, never join the live agents table
---

# Simulation result preservation

Aggregations in `GET /simulations/:id` (byDistrict/byAgeBracket/byGender/byLeaning) must be computed
from columns snapshotted into `simulation_responses` at response time — never from a join to the live
`agents` table.

**Why:** `/admin/population/regenerate` deletes all agents, resets `agents_id_seq`, and recreates them
from id=1. Any aggregate that joins live `agents` would re-bind old responses to unrelated new agents
(or drop rows on inner join), silently corrupting historical results — which the admin UI explicitly
promises are preserved.

**How to apply:** When adding any new per-agent dimension to simulation results, add it as a snapshot
column on `simulation_responses` and have the engine write it at insert time. If you add such a column
to an existing table, backfill it from `agents` *before* any regeneration runs (IDs still match the
original deterministic seed at that point). New NOT NULL columns need `.default(...)` so `drizzle push`
succeeds on the non-empty table.
