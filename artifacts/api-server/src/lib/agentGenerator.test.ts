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
