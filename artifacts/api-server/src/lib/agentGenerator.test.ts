import { describe, it, expect } from "vitest";
import { generateAgents, type GenerationInputs } from "./agentGenerator";
import { emptyPolicyAdjustments } from "./policyWeighting";

const SEED = 20260615;

function baseInputs(): GenerationInputs {
  return {
    count: 240,
    seed: SEED,
    regions: [
      { code: "11", name: "서울", lat: 37.5665, lng: 126.978, leaningBias: -8 },
      { code: "26", name: "부산", lat: 35.1796, lng: 129.0756, leaningBias: 12 },
      { code: "41", name: "경기", lat: 37.4138, lng: 127.5183, leaningBias: -3 },
    ],
    regionMarginals: [
      { key: "11", population: 950 },
      { key: "26", population: 330 },
      { key: "41", population: 1350 },
    ],
    ageMarginals: [
      { bracket: "18-29", population: 600 },
      { bracket: "30-39", population: 500 },
      { bracket: "40-49", population: 520 },
      { bracket: "50-59", population: 480 },
      { bracket: "60-69", population: 320 },
      { bracket: "70+", population: 210 },
    ],
    genderMarginals: [
      { key: "남성", population: 1300 },
      { key: "여성", population: 1330 },
    ],
  };
}

/**
 * A strongly non-empty policy adjustment so the Seraph policy track is forced to
 * draw from its PRNG stream and rake toward distinct targets. If the policy
 * track shared a stream with (or otherwise perturbed) the political/consumer
 * streams, turning these adjustments on would shift those fields too.
 */
function strongPolicyAdjustments() {
  const adj = emptyPolicyAdjustments();
  for (const key of Object.keys(adj) as (keyof typeof adj)[]) {
    adj[key] = {
      weightSum: 1.5,
      noiseScale: 0.5,
      driverCount: 3,
      targetMean: 95,
      targetPull: 0.85,
    };
  }
  return adj;
}

/** Everything an agent carries except its policy (Seraph) axes. */
function withoutPolicy(agents: ReturnType<typeof generateAgents>) {
  return agents.map(({ policyStances, ...rest }) => {
    void policyStances;
    return rest;
  });
}

describe("generateAgents determinism", () => {
  it("is byte-identical across two runs with the same seed + inputs", () => {
    const a = generateAgents(baseInputs());
    const b = generateAgents(baseInputs());
    expect(b).toEqual(a);
  });

  it("keeps political + consumer fields identical regardless of the policy track", () => {
    const withoutPolicyAdj = generateAgents(baseInputs());
    const withPolicyAdj = generateAgents({
      ...baseInputs(),
      policyAdjustments: strongPolicyAdjustments(),
    });

    // Same number of agents in both populations.
    expect(withPolicyAdj.length).toBe(withoutPolicyAdj.length);
    expect(withPolicyAdj.length).toBeGreaterThan(0);

    // Every field EXCEPT policyStances (incl. politicalLeaning, issueStances,
    // consumerStances, names, geo) must be byte-identical — proving the policy
    // PRNG stream is isolated and never perturbs the other tracks.
    expect(withoutPolicy(withPolicyAdj)).toEqual(withoutPolicy(withoutPolicyAdj));
  });

  it("actually moves the policy axes when policy adjustments are applied", () => {
    const withoutPolicyAdj = generateAgents(baseInputs());
    const withPolicyAdj = generateAgents({
      ...baseInputs(),
      policyAdjustments: strongPolicyAdjustments(),
    });

    // Guards against a false pass above: if the policy adjustments had no
    // effect, the isolation assertion would be trivially true. With targets at
    // 95 + strong pull, the mean governmentTrust must rise meaningfully.
    const mean = (xs: number[]) => xs.reduce((s, x) => s + x, 0) / xs.length;
    const trust = (agents: ReturnType<typeof generateAgents>) =>
      mean(agents.map((a) => a.policyStances?.governmentTrust ?? 0));
    const baseTrust = trust(withoutPolicyAdj);
    const rakedTrust = trust(withPolicyAdj);
    expect(rakedTrust).toBeGreaterThan(baseTrust + 10);
  });
});

/** Tally how many agents fall into each bucket of a categorical field. */
function tally<T>(agents: T[], pick: (a: T) => string): Map<string, number> {
  const out = new Map<string, number>();
  for (const a of agents) {
    const k = pick(a);
    out.set(k, (out.get(k) ?? 0) + 1);
  }
  return out;
}

/** Expected proportion of a marginal entry within its own dimension. */
function shareOf(marginals: { population: number }[], population: number) {
  const total = marginals.reduce((s, m) => s + m.population, 0);
  return population / total;
}

describe("generateAgents marginal matching", () => {
  it("produces exactly the requested agent count", () => {
    for (const count of [50, 240, 1000, 5000]) {
      const agents = generateAgents({ ...baseInputs(), count });
      expect(agents.length).toBe(count);
    }
  });

  it("matches the region marginal proportions within integer-allocation error", () => {
    const inputs = baseInputs();
    const count = 5000;
    const agents = generateAgents({ ...inputs, count });

    // Map region code -> name so we can compare the generated `district`
    // (which carries the region name) back to the official region marginal key.
    const nameByCode = new Map(inputs.regions.map((r) => [r.code, r.name]));
    const counts = tally(agents, (a) => a.district);

    for (const m of inputs.regionMarginals) {
      const name = nameByCode.get(m.key)!;
      const expected = shareOf(inputs.regionMarginals, m.population) * count;
      const actual = counts.get(name) ?? 0;
      // Largest-remainder allocation across region×age×gender cells can drift by
      // at most one agent per cell; allow a small absolute tolerance.
      const cells = inputs.ageMarginals.length * inputs.genderMarginals.length;
      expect(Math.abs(actual - expected)).toBeLessThanOrEqual(cells);
    }
  });

  it("matches the age marginal proportions within integer-allocation error", () => {
    const inputs = baseInputs();
    const count = 5000;
    const agents = generateAgents({ ...inputs, count });
    const counts = tally(agents, (a) => a.ageBracket);

    for (const m of inputs.ageMarginals) {
      const expected =
        shareOf(inputs.ageMarginals, m.population) * count;
      const actual = counts.get(m.bracket) ?? 0;
      const cells =
        inputs.regionMarginals.length * inputs.genderMarginals.length;
      expect(Math.abs(actual - expected)).toBeLessThanOrEqual(cells);
    }
  });

  it("matches the gender marginal proportions within integer-allocation error", () => {
    const inputs = baseInputs();
    const count = 5000;
    const agents = generateAgents({ ...inputs, count });
    const counts = tally(agents, (a) => a.gender);

    for (const m of inputs.genderMarginals) {
      const expected = shareOf(inputs.genderMarginals, m.population) * count;
      const actual = counts.get(m.key) ?? 0;
      const cells =
        inputs.regionMarginals.length * inputs.ageMarginals.length;
      expect(Math.abs(actual - expected)).toBeLessThanOrEqual(cells);
    }
  });

  it("places every agent in the single region when region scope collapses to one", () => {
    const inputs = baseInputs();
    // Collapse the region marginal to a single region code (mirrors what
    // buildGenerationInputs does for a non-national regionScope).
    const scoped = inputs.regionMarginals.filter((m) => m.key === "41");
    const agents = generateAgents({
      ...inputs,
      count: 500,
      regionMarginals: scoped,
    });

    expect(agents.length).toBe(500);
    const districts = new Set(agents.map((a) => a.district));
    expect([...districts]).toEqual(["경기"]);
  });
});
