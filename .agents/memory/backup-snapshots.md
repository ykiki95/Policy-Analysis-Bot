---
name: Backup snapshot layout
description: How the GitHub DB backup script stores point-in-time snapshots and prunes them
---

The backup script (`scripts/src/backup-to-github.ts`, `backup:db`) writes two things from one dump:

- `db/backup/demos_full_dump.sql` — always the latest pointer (unchanged contract).
- `db/backup/snapshots/demos_YYYY-MM-DD.sql` — date-stamped point-in-time copies for rolling back to a past day.

**Conventions / why:**
- One snapshot per UTC day; running multiple times same day overwrites that day's file (keeps history readable, avoids churn). Date filename sorts lexically = chronologically.
- Retention via `BACKUP_RETENTION` env (default 14, 0=disabled): keep N newest by filename, delete older. `pruneSnapshots` only matches the `demos_YYYY-MM-DD.sql` pattern so it never touches unrelated files.
- `stageAndCommit` stages BOTH `demos_full_dump.sql` and the `snapshots/` dir with `git add --all` so retention deletions are committed too. The "no changes" skip checks the diff across both paths.

**How to apply:** Any future scheduled-backup or auto-restore work should reuse this layout — restore-from-snapshot just needs to pick a `snapshots/demos_*.sql` file. Don't change the latest-pointer filename; downstream restore flows depend on it.
