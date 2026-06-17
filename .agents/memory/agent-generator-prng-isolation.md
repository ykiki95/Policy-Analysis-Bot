---
name: agentGenerator PRNG isolation
description: Why new deterministic agent fields must use a separate PRNG stream, not the shared rand
---

# agentGenerator PRNG isolation

When adding a new deterministically-generated attribute to `generateAgents`
(agentGenerator.ts), do NOT draw its randomness from the shared `rand`
(mulberry32) stream that already drives the political attributes. Allocate an
independent PRNG instead, e.g. `mulberry32(seed ^ <constant>)`.

**Why:** a single `rand` stream is consumed sequentially across all agents. Any
extra `rand()`/`gaussian(rand)` draw inserted mid-loop shifts the stream for
every subsequent agent, silently changing their existing attributes. Adding the
commercial consumer-stances axes this way would have altered the political track
output (Seraph/Dynamo), breaking determinism and the "don't overlap the
political track" requirement.

**How to apply:** consumer-axis noise uses `consumerRand = mulberry32(seed ^ 0x6d2b79f5)`.
Reading already-drawn values (age, eduIdx, incomeIdx) to build a base is fine —
only *new draws* shift the stream. Verify after any such change: regenerate and
confirm political aggregates (avg leaning, issue means) are unchanged.
