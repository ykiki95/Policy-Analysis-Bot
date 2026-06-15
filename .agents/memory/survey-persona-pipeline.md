---
name: Survey → persona pipeline (future build decision)
description: User's pre-approved design for connecting survey criteria to agent/persona generation, to implement when requested.
---

# Survey → persona pipeline (deferred, pre-approved design)

Currently surveys and calibrations are **illustrative only** — agents are generated
deterministically by `agentGenerator` from age + district + PRNG. Surveys are NOT
wired into generation. The user reviewed this and pre-decided how to connect them
**when they later ask to build it**. Implement per this decision without re-litigating:

**Scope:** do BOTH — (1) survey CRUD (add/delete survey criteria), and (2) make
surveys actually influence persona generation.

**Architecture:** core = **free-form storage + weighting**. Store the survey, derive
its distributions, and use them as **priors/weights** on agent attitude generation.
The final persona reflection must stay **deterministic** (same input → same agents).

**LLM parsing is auxiliary only:** use an LLM to read arbitrary/messy upload formats
and propose a 1st-pass mapping to standard dimensions (age, region, political leaning,
issue stances), but treat its output as a **draft suggestion** that a human confirms.
Never let LLM output feed generation non-deterministically.

**Why:** DEMOS's core value is the calibration/validation loop, so reproducibility
and transparency (auditable "this survey distribution shifted attitudes by X") rank
above raw format flexibility. The hybrid keeps free-form's determinism while gaining
LLM's input flexibility.

**How to apply:** when the user asks to "connect surveys to personas" / "implement the
survey decision", build CRUD first, then the deterministic weighting layer, with LLM
parsing as an optional assisted-mapping step on upload.
