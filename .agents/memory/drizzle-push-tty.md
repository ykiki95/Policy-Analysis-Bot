---
name: drizzle-kit push needs a TTY
description: Why `pnpm --filter @workspace/db run push` can fail in the agent shell, and the workaround.
---

`drizzle-kit push` (drizzle-kit 0.31.x) runs an interactive resolver
(`promptNamedWithSchemasConflict` / `tablesResolver`) when it can't unambiguously
decide create-vs-rename for added tables. In the agent's non-interactive shell
(`process.stdin.isTTY` false) this throws `Error: Interactive prompts require a TTY terminal`
and the push aborts.

**Workaround:** for a brand-new table, create it directly via raw SQL DDL through the
`code_execution` `executeSql` callback, matching the Drizzle schema column-for-column
(snake_case columns, `timestamptz`, `double precision`, defaults). The schema file is
still the source of truth for the ORM types; only the physical `push` is bypassed.

**Why:** the prompt has no default and no `--yes`/non-interactive flag, so it is
unrunnable from the agent shell. Raw DDL via executeSql is deterministic and idempotent
(`CREATE TABLE IF NOT EXISTS`).

**How to apply:** when adding a new table, after writing the schema + index export, run
the equivalent `CREATE TABLE IF NOT EXISTS` via executeSql instead of (or after a failed)
`run push`. Seeding already happens via executeSql in this project, so it fits the flow.
