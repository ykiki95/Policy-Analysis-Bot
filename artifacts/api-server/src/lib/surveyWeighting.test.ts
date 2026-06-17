import { describe, it, expect } from "vitest";
import type { Survey, SurveyDriver } from "@workspace/db";
import {
  computeSurveyAdjustments,
  reliabilityFromSampleSize,
} from "./surveyWeighting";
import { computeConsumerAdjustments } from "./consumerWeighting";
import { computePolicyAdjustments } from "./policyWeighting";

type SurveyInput = Pick<
  Survey,
  "appliedToPopulation" | "drivers" | "sampleSize" | "domain"
>;

function survey(
  domain: string,
  drivers: SurveyDriver[],
  opts: { applied?: boolean; sampleSize?: number } = {},
): SurveyInput {
  return {
    domain,
    drivers,
    appliedToPopulation: opts.applied ?? true,
    sampleSize: opts.sampleSize ?? 1000,
  };
}

function driver(
  issue: string,
  weight: number,
  targetStance?: number,
): SurveyDriver {
  return {
    factor: `${issue}-factor`,
    issue,
    weight,
    direction: "positive",
    ...(targetStance === undefined ? {} : { targetStance }),
  };
}

describe("computeSurveyAdjustments (political track)", () => {
  it("reflects only political-domain drivers and ignores commercial/policy surveys", () => {
    const adj = computeSurveyAdjustments([
      survey("political", [driver("경제", 1)]),
      // These must not leak into the political issue weighting.
      survey("commercial", [driver("가격민감도", 1)]),
      survey("policy", [driver("정부신뢰", 1)]),
      // A commercial driver whose label collides with nothing political stays out;
      // even a political-looking label on a non-political survey is skipped.
      survey("commercial", [driver("경제", 1)]),
      survey("policy", [driver("경제", 1)]),
    ]);

    expect(adj.economy.driverCount).toBe(1);
    expect(adj.economy.multiplier).toBeGreaterThan(1);
    // Untouched issues remain at their identity defaults.
    expect(adj.welfare.driverCount).toBe(0);
    expect(adj.welfare.multiplier).toBe(1);
    expect(adj.welfare.noiseScale).toBe(1);
  });

  it("ignores surveys not applied to the population", () => {
    const adj = computeSurveyAdjustments([
      survey("political", [driver("복지", 1)], { applied: false }),
    ]);
    expect(adj.welfare.driverCount).toBe(0);
    expect(adj.welfare.weightSum).toBe(0);
    expect(adj.welfare.multiplier).toBe(1);
    expect(adj.welfare.targetMean).toBeNull();
  });

  it("reflects targetStance into targetMean as a reliability-weighted average", () => {
    // Two drivers on the same issue with different reliabilities (sample sizes):
    // the higher-reliability target pulls the mean toward itself, so the result
    // differs from a naive arithmetic mean of 60.
    const rA = reliabilityFromSampleSize(100); // 0.9
    const rB = reliabilityFromSampleSize(400); // 0.95
    const expected = Math.round((40 * rA + 80 * rB) / (rA + rB));

    const adj = computeSurveyAdjustments([
      survey("political", [driver("경제", 1, 40)], { sampleSize: 100 }),
      survey("political", [driver("경제", 1, 80)], { sampleSize: 400 }),
    ]);

    expect(adj.economy.targetMean).toBe(expected);
    expect(adj.economy.targetMean).not.toBe(60); // not the naive mean
    expect(adj.economy.targetPull).toBeGreaterThan(0);
  });

  it("leaves targetMean null when no driver supplies a targetStance", () => {
    const adj = computeSurveyAdjustments([
      survey("political", [driver("안보", 1)]),
    ]);
    expect(adj.security.driverCount).toBe(1);
    expect(adj.security.targetMean).toBeNull();
    expect(adj.security.targetPull).toBe(0);
  });
});

describe("computeConsumerAdjustments (Lumen track)", () => {
  it("reflects only commercial-domain drivers and ignores political/policy surveys", () => {
    const adj = computeConsumerAdjustments([
      survey("commercial", [driver("가격민감도", 1)]),
      survey("political", [driver("경제", 1)]),
      survey("policy", [driver("정부신뢰", 1)]),
      // default-domain (political) survey must not leak into consumer axes
      survey("political", [driver("가격민감도", 1)]),
    ]);

    expect(adj.priceSensitivity.driverCount).toBe(1);
    expect(adj.brandLoyalty.driverCount).toBe(0);
    expect(adj.brandLoyalty.noiseScale).toBe(1);
  });

  it("ignores surveys not applied to the population", () => {
    const adj = computeConsumerAdjustments([
      survey("commercial", [driver("브랜드충성도", 1, 70)], { applied: false }),
    ]);
    expect(adj.brandLoyalty.driverCount).toBe(0);
    expect(adj.brandLoyalty.targetMean).toBeNull();
  });

  it("reflects targetStance into targetMean as a reliability-weighted average", () => {
    const rA = reliabilityFromSampleSize(100);
    const rB = reliabilityFromSampleSize(400);
    const expected = Math.round((30 * rA + 90 * rB) / (rA + rB));

    const adj = computeConsumerAdjustments([
      survey("commercial", [driver("친환경소비", 1, 30)], { sampleSize: 100 }),
      survey("commercial", [driver("친환경소비", 1, 90)], { sampleSize: 400 }),
    ]);

    expect(adj.ecoConsciousness.targetMean).toBe(expected);
    expect(adj.ecoConsciousness.targetMean).not.toBe(60);
    expect(adj.ecoConsciousness.targetPull).toBeGreaterThan(0);
  });
});

describe("computePolicyAdjustments (Seraph track)", () => {
  it("reflects only policy-domain drivers and ignores political/commercial surveys", () => {
    const adj = computePolicyAdjustments([
      survey("policy", [driver("정부신뢰", 1)]),
      survey("political", [driver("경제", 1)]),
      survey("commercial", [driver("가격민감도", 1)]),
      // political-domain survey carrying a policy label must not leak in
      survey("political", [driver("정부신뢰", 1)]),
    ]);

    expect(adj.governmentTrust.driverCount).toBe(1);
    expect(adj.policyAcceptance.driverCount).toBe(0);
    expect(adj.policyAcceptance.noiseScale).toBe(1);
  });

  it("ignores surveys not applied to the population", () => {
    const adj = computePolicyAdjustments([
      survey("policy", [driver("증세수용", 1, 55)], { applied: false }),
    ]);
    expect(adj.taxTolerance.driverCount).toBe(0);
    expect(adj.taxTolerance.targetMean).toBeNull();
  });

  it("reflects targetStance into targetMean as a reliability-weighted average", () => {
    const rA = reliabilityFromSampleSize(100);
    const rB = reliabilityFromSampleSize(400);
    const expected = Math.round((20 * rA + 80 * rB) / (rA + rB));

    const adj = computePolicyAdjustments([
      survey("policy", [driver("규제선호", 1, 20)], { sampleSize: 100 }),
      survey("policy", [driver("규제선호", 1, 80)], { sampleSize: 400 }),
    ]);

    expect(adj.regulationPreference.targetMean).toBe(expected);
    expect(adj.regulationPreference.targetMean).not.toBe(50);
    expect(adj.regulationPreference.targetPull).toBeGreaterThan(0);
  });
});
