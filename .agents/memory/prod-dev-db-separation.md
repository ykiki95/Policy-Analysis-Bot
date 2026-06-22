---
name: prod vs dev DB are separate
description: The deployed (Autoscale) app uses a DIFFERENT Postgres database than the dev environment — do not assume they share data.
---

# Production and development databases are SEPARATE

The published Autoscale deployment runs against its **own** Postgres, distinct from the dev `DATABASE_URL`. They are NOT the same database.

**Why this matters:** An earlier session note claimed "prod DB == dev DB (executeSql reflects prod)" — that is WRONG and caused a misdiagnosis. Example seen: admin raised the `test` account budget in production (PUT → 200); the value persisted as `budget_limit_usd=2` in **prod** but dev still showed `1`. Querying dev to "verify prod state" gives stale/wrong answers.

**How to apply:**
- To inspect real production data, query the prod replica explicitly: `executeSql({ environment: "production", sqlQuery: ... })` (SELECT-only). Default `executeSql` hits dev.
- To confirm whether a production action took effect, read prod via `environment: "production"` and/or read the **deployment** logs (`fetch_deployment_logs`), never the dev DB.
- Schema changes reach prod only via the Publish flow (diff dev→prod at publish time), so prod schema can lag dev until republish.

## Writing directly to the prod (Replit-managed Neon) DB from the dev shell

Replit tooling gives only READ-ONLY prod access (`executeSql environment:"production"`). There is no sanctioned write tool. A direct `psql` write is possible but only with the **external Neon** connection string:
- A user-set `PROD_DATABASE_URL` secret copied from the Replit DB pane is the **internal proxy** string: user + host are a 64-char hex, psql routes it to internal host `helium` (172.24.0.x), and it fails ("database ... does not exist" / not reachable from the dev container). Unusable for direct writes.
- The working endpoint is the **external** Neon host (e.g. `ep-xxxx.<region>.aws.neon.tech`), user `neondb_owner`, db `neondb`, `?sslmode=require`. It IS reachable from the dev container. The internal-proxy password does NOT work on it — auth fails.
- Get the real `neondb_owner` password (PGPASSWORD) from the Replit **production database settings pane** (NOT the Neon console — a Replit-managed Neon DB does not appear in the user's personal Neon account; console.neon.tech will only offer to create a NEW unrelated project). Request just the password as a secret, then assemble the URL in-shell without printing it.
- Bash/workflow env DOES reflect the current secret value (it is not stale across turns); read a live process's `/proc/<pid>/environ` only to confirm what's actually stored. The earlier "helium vs neon" confusion was the user repeatedly copying the internal string, not a stale shell.

**Copy whole dev DB → prod:** `pg_dump "$DATABASE_URL" --no-owner --no-privileges --clean --if-exists --exclude-table-data='session'` then apply with `psql "$EXTERNAL_PROD_URL" --single-transaction -v ON_ERROR_STOP=1 -f dump.sql` (atomic: rolls back on any error). Always exclude `session` data (login state, environment-specific) — a post-load per-table count diff will then show only `session` differing, which is expected.
