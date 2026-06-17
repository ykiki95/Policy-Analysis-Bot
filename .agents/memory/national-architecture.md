---
name: National (17 시도) architecture
description: How DEMOS went from Seoul-25-district to national IPF-raked generation + real election calibration; the data-flow contracts to preserve.
---

# National synthetic-electorate architecture

DEMOS generates a synthetic electorate for all 17 Korean 시도 (or one selected 시도), data-driven from public-statistics margins via IPF raking, and validates predictions against real past election results.

## Source-of-truth tables (lib/db schema)
- `regions` — 17 시도 with lat/lng centroid, leaningBias, macroRegion, displayOrder. Region codes: SEL,BSN,DGU,ICN,GWJ,DJN,USN,SJG,GGD,GWN,CCB,CCN,JLB,JLN,GSB,GSN,JJU.
- `demographic_margins(dimension, key, label, population)` — marginal targets; dimension ∈ region|age|gender (17+6+2 = 25 rows seeded).
- `elections(name, electionType, electionDate, regionCode, metric, actualValue)` — actual results per region×leaning for calibration.

## Generation contract (deterministic)
- `raking.ts` fits the region×age×gender joint distribution from the three marginals via IPF, then allocates integer agent counts with deterministic largest-remainder. Same seed + same margins ⇒ identical population.
- `agentGenerator.ts` is data-driven: takes regions[], marginals, regionScope, and survey adjustments. `agents.district` stores the 시도 NAME (e.g. "서울특별시"), gender is "Male"/"Female". No per-agent region-code column.
- regionScope on regenerate: 전국 (all 17) or a single 시도 code. At 500 agents, the smallest region (세종/SJG) may get 0 — acceptable.

## Election calibration (electionCalibration.ts)
- Per (election, region, leaning): raw prediction = turnout-weighted logistic of live agents' political leaning (LOGISTIC_SCALE=35); calibrated = raw + shrinkage*(actual − raw), shrinkage 0.4 ("베이지안 축소").
- **Reads LIVE agents** (unlike simulation aggregates, which must use snapshots). This is fine because calibration is a current-population diagnostic, not a preserved historical result.
- Endpoint `GET /calibration/elections` returns {method, shrinkageFactor, avgRawError, avgCalibratedError, rows[]}. Seeded with 제20대 대선 → avgRaw 6.9 → avgCal 4.1.

## Frontend
- Calibration page has two tabs: 실제 선거 검증 (election view) + 가상 이벤트 검증 (legacy virtual events).
- Population page: national Leaflet map centered 36.5,127.8 zoom 7.
- Admin: region scope selector + demographic-margins display + 50–5000 agent range.

**Why:** the whole point of Task #1 was to move from a fixed Seoul demo to an Aaru-style national commercial structure grounded in official margins + real election outcomes. Keep generation deterministic and keep simulation_responses snapshot-independent (calibration reading live agents is the deliberate exception).
