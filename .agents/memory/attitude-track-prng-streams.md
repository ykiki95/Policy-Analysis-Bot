---
name: Attitude-track PRNG stream isolation
description: How DEMOS keeps agent generation deterministic + non-interfering as new attitude domains (political/commercial/policy) are added.
---

# Attitude-track PRNG stream isolation

Each agent-attitude domain in `agentGenerator.ts` draws its random noise from its
OWN `mulberry32` stream, seeded by XOR-ing the base `seed` with a distinct
constant:
- political/base demographics → `rand = mulberry32(seed)`
- commercial → `consumerRand = mulberry32(seed ^ 0x6d2b79f5)`
- policy → `policyRand = mulberry32(seed ^ 0x85ebca6b)`

**Why:** adding a new attitude track must NOT shift the random draws of existing
tracks. If a new domain consumed the same stream, every previously-generated
agent's political/consumer fields would change for the same seed, breaking
determinism and reproducibility. Independent streams keep each track
byte-identical regardless of which other tracks exist.

**How to apply:** when adding the next attitude domain, allocate a NEW XOR
constant + a NEW stream; never reuse or interleave an existing stream. Mirror the
`*Weighting.ts` + `compute*Adjustments` (domain filter + applied flag + rake
toward `targetStance`) pattern, and add the domain to the skip list in
`surveyWeighting.computeSurveyAdjustments` so it doesn't pollute political
issues.

Product→track routing lives in `simulationEngine.ts` and is keyed strictly on
`sim.product` (lumen→commercial, seraph→policy, else political); `audience` is
descriptive only and never switches the track.
