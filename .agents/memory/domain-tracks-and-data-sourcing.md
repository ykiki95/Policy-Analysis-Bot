---
name: Domain tracks roadmap & survey data sourcing
description: Confirmed product-track expansion plan and what real-world survey/calibration data is realistically obtainable per domain.
---

# Domain tracks roadmap

User confirmed (June 2026): after the political track lands (nationwide raking + election-result calibration), expand to two more tracks on the SAME engine, changing only the domain inputs:
- **Lumen (commercial/business)** — consumer/market surveys for personas; calibrate against real market outcomes (sales, adoption rates).
- **Seraph (policy/government)** — policy-perception surveys for personas; calibrate against real policy outcomes (referenda, votes, uptake).

**Why:** calibration is domain-specific. A population calibrated on elections is validated only for political prediction; commercial/policy questions asked of it are uncalibrated estimates. Survey domain ↔ question domain ↔ calibration target must match. This is the reason the Lumen/Seraph/Dynamo product split exists.

**How to apply:** when the political track task is done, plan the commercial + policy tracks as follow-on work (in Plan mode → project tasks). Reuse the raking/generation engine; swap in domain-matched surveys + domain-matched ground-truth calibration data.

# Survey/calibration data sourcing reality

- **Current demo surveys are SYNTHETIC** (illustrative, made up) — not scraped real opinion polls.
- The political track's "real data" = public **demographic marginals** (KOSIS-type, 시도×연령×성별) + real past **election results** as ground truth. These are public facts seeded by the executor.
- **Published aggregate survey results** (e.g., 한국갤럽 정당지지율, 통계청 사회조사, 한국행정연구원 사회통합실태조사, KGSS aggregate tables) are publicly available and can be sourced via web search and seeded with attribution.
- **Respondent-level microdata** (KOSSDA, 통계청 MDIS) usually requires registration/licensing/agreement — NOT freely scrapable; respect terms.
- **Commercial/consumer microdata** is mostly proprietary/paid (Nielsen, Kantar, 오픈서베이). Free public consumer sources are limited (통계청 가계동향, 소비자행태조사). Set expectations accordingly when building Lumen.

# User directive (June 2026)

- For ALL three tracks (political/commercial/policy), source **real published survey aggregates from the internet** as much as possible to build personas — replace synthetic opinion surveys with real numbers where feasible. Includes retrofitting the political track (its opinion surveys are currently synthetic; demographics + election results are already real).
- Paid/licensed surveys are out of reach for now → build a **user-upload path** so users can supply paid survey data later.
- Sequencing constraint: the political-track task is running in an isolated task-agent Repl and cannot take mid-flight changes; real-survey sourcing must be organized as follow-on tasks (political retrofit + Lumen + Seraph + upload feature), planned after it merges to avoid editing the same files on main concurrently.
