---
name: Commercial (consumer) track
description: How the Lumen commercial track is wired alongside the political track on the same engine
---

# Commercial (consumer) track

The Lumen product line runs a consumer-attitude track parallel to the political
one, on the same simulation engine and agent population.

- **Routing:** `isCommercialSim(sim)` = `product==='lumen'` ONLY (simulationEngine.ts).
  Do NOT also switch on `audience==='비즈니스'`: product and audience are chosen
  independently in the form, so an audience-based switch would hijack Seraph/
  Dynamo runs whose audience is mis-set onto the consumer track. Audience is
  descriptive; product decides the track. Commercial sims use a consumer persona prompt
  (demographics + consumerStances, NO political leaning) and 수용/거부 summary
  labels; everything else stays on the political prompt. Same JSON output
  contract (stance/score/confidence/reasoning), so downstream aggregation is
  unchanged.
- **5 consumer axes (0..100)** on `agents.consumerStances`: priceSensitivity,
  brandLoyalty, noveltySeeking, ecoConsciousness, digitalConsumption.
  Deterministic demographic base + noise (separate PRNG) + rake toward survey
  targets.
- **Survey domain split:** `surveys.domain` ('political'|'commercial').
  `computeSurveyAdjustments` (political issue raking) skips commercial;
  `computeConsumerAdjustments` reads only commercial+appliedToPopulation. Both
  reuse `reliabilityFromSampleSize` for target pull.
- **Real sources** seeded as domain='commercial', isReal=true (방통위 방송매체
  이용행태, 과기정통부 인터넷이용실태, 한국소비자원 친환경, 한국은행 소비자동향,
  대한상의 소비트렌드) + matching dataSources category '소비자조사'. Seed deletes
  both '여론조사'+'소비자조사' categories before reinsert.
- **Public-data limitation** surfaced in UI (surveys detail + products Lumen):
  brand-level / channel-level behavior needs paid consumer panels; synthetic
  axes are macro-trend approximations, not market-share predictions.
