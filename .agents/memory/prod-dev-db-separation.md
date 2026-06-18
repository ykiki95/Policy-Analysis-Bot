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
