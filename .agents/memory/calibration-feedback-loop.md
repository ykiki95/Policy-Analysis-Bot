---
name: Calibration feedback loop (two levers)
description: How DEMOS turns validation-event bias into prediction corrections — output (post-hoc) vs input (persona baseline) calibration, and the sign convention.
---

# Calibration feedback loop — two levers

DEMOS reduces error between simulation predictions and reality via two distinct levers driven by the same validation events (`calibrations` table). Both derive `meanBias = mean(actualValue − rawPrediction)` per product.

## Lever 2 — output calibration (always on)
Post-hoc correction of a *completed* simulation's headline numbers. Built per `sim.product`, applied only when ≥2 events exist. Shifts support by `shrinkage·meanBias`, redistributes the delta proportionally across oppose/neutral, renormalizes to 100. Surfaced in the `calibration` object on the simulation-detail response and shown as a 원시 vs 보정 card. Does not touch the population.

## Lever 1 — input calibration (opt-in)
Moves persona *baselines* before generation. Controlled by `calibrationSettings.applyToPopulation` (default false). When on, per-product meanBias is converted to clamped baseline offsets ({political ±25 leaning, consumer/policy ±15 stance}, scaled by shrinkage) and injected into `generateAgents`. **Only takes effect on the NEXT population regeneration** — existing agents and past simulation aggregates are untouched.

**Why the split:** output calibration must be reversible/inspectable per run (you always want to see raw vs corrected), while input calibration is a deliberate, destructive-ish baseline shift the user opts into. Keeping them separate means turning the toggle off never rewrites stored results.

## Sign convention (critical, easy to get backwards)
`actualValue`/`rawPrediction` are the SAME metric the sim predicts (지지·찬성·수용률 %). Dynamo validation events are a **conservative** indicator (matches the conservative election seed), so a positive bias shifts the political-leaning baseline in the **conservative (+)** direction. Lumen → consumer stances +offset; Seraph → policy stances +offset.

**How to apply:** when adding a new product/track, decide which baseline axis its events map to and whether higher actual means + or − on that axis, then extend `computeCalibrationOffsets`. Reuse the existing per-track PRNG streams — offsets are deterministic additions after noise, so they never shift other tracks.
