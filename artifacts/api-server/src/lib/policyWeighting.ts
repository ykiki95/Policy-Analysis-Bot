import type { Survey, SurveyDriver, AgentPolicyStances } from "@workspace/db";
import { reliabilityFromSampleSize } from "./surveyWeighting";

export type PolicyAxisKey = keyof AgentPolicyStances;

export const POLICY_AXIS_KEYS: PolicyAxisKey[] = [
  "governmentTrust",
  "policyAcceptance",
  "taxTolerance",
  "regulationPreference",
  "publicServiceSatisfaction",
];

export const POLICY_AXIS_LABELS: Record<PolicyAxisKey, string> = {
  governmentTrust: "정부신뢰",
  policyAcceptance: "정책수용성",
  taxTolerance: "증세수용",
  regulationPreference: "규제선호",
  publicServiceSatisfaction: "공공서비스만족",
};

const LABEL_TO_KEY: Record<string, PolicyAxisKey> = {
  정부신뢰: "governmentTrust",
  정책수용성: "policyAcceptance",
  증세수용: "taxTolerance",
  규제선호: "regulationPreference",
  공공서비스만족: "publicServiceSatisfaction",
  governmentTrust: "governmentTrust",
  policyAcceptance: "policyAcceptance",
  taxTolerance: "taxTolerance",
  regulationPreference: "regulationPreference",
  publicServiceSatisfaction: "publicServiceSatisfaction",
};

export function policyAxisToKey(issue: string): PolicyAxisKey | null {
  return LABEL_TO_KEY[issue.trim()] ?? null;
}

export type PolicyAdjustment = {
  /** Sum of applied-survey driver weights mapped to this axis (capped). */
  weightSum: number;
  /** Scale on the random noise term (more survey evidence → less noise). */
  noiseScale: number;
  /** Number of applied drivers contributing to this axis. */
  driverCount: number;
  /**
   * Reliability-weighted target mean (0..100) the applied policy surveys imply
   * for this axis, or null when no driver specified a target.
   */
  targetMean: number | null;
  /** How strongly to rake the generated value toward `targetMean` (0..0.85). */
  targetPull: number;
};

export type PolicyAdjustments = Record<PolicyAxisKey, PolicyAdjustment>;

const MAX_WEIGHT = 1.5;
const NOISE_REDUCTION = 0.25; // down to -25% noise at weight >= 1
const MAX_PULL = 0.85;

function emptyAdjustment(): PolicyAdjustment {
  return {
    weightSum: 0,
    noiseScale: 1,
    driverCount: 0,
    targetMean: null,
    targetPull: 0,
  };
}

export function emptyPolicyAdjustments(): PolicyAdjustments {
  return {
    governmentTrust: emptyAdjustment(),
    policyAcceptance: emptyAdjustment(),
    taxTolerance: emptyAdjustment(),
    regulationPreference: emptyAdjustment(),
    publicServiceSatisfaction: emptyAdjustment(),
  };
}

/**
 * Deterministically derive per-axis policy-generation adjustments from the
 * drivers of the `domain === "policy"` surveys marked applied-to-population.
 * Each policy driver supplies a reliability-weighted target (0..100) toward
 * which the demographic base value is raked, and more aggregate survey evidence
 * reduces random noise — mirroring the political/commercial tracks' raking, but
 * on the policy axes used by the Seraph product line.
 */
export function computePolicyAdjustments(
  surveys: Pick<
    Survey,
    "appliedToPopulation" | "drivers" | "sampleSize" | "domain"
  >[],
): PolicyAdjustments {
  const adj = emptyPolicyAdjustments();
  const targetNum: Record<PolicyAxisKey, number> = {
    governmentTrust: 0,
    policyAcceptance: 0,
    taxTolerance: 0,
    regulationPreference: 0,
    publicServiceSatisfaction: 0,
  };
  const targetDen: Record<PolicyAxisKey, number> = {
    governmentTrust: 0,
    policyAcceptance: 0,
    taxTolerance: 0,
    regulationPreference: 0,
    publicServiceSatisfaction: 0,
  };

  for (const survey of surveys) {
    if (survey.domain !== "policy") continue;
    if (!survey.appliedToPopulation) continue;
    const reliability = reliabilityFromSampleSize(survey.sampleSize);
    const drivers: SurveyDriver[] = survey.drivers ?? [];
    for (const d of drivers) {
      const key = policyAxisToKey(d.issue);
      if (!key) continue;
      const w = typeof d.weight === "number" ? d.weight : Number(d.weight);
      if (!Number.isFinite(w) || w <= 0) continue;
      adj[key].weightSum += w * reliability;
      adj[key].driverCount += 1;

      const ts =
        typeof d.targetStance === "number" ? d.targetStance : Number(d.targetStance);
      if (Number.isFinite(ts)) {
        const wgt = w * reliability;
        targetNum[key] += Math.max(0, Math.min(100, ts)) * wgt;
        targetDen[key] += wgt;
      }
    }
  }

  for (const key of POLICY_AXIS_KEYS) {
    const capped = Math.min(adj[key].weightSum, MAX_WEIGHT);
    adj[key].weightSum = Math.round(capped * 100) / 100;
    adj[key].noiseScale =
      Math.round((1 - NOISE_REDUCTION * Math.min(capped, 1)) * 1000) / 1000;
    if (targetDen[key] > 0) {
      adj[key].targetMean = Math.round(targetNum[key] / targetDen[key]);
      adj[key].targetPull =
        Math.round(Math.min(MAX_PULL, targetDen[key] / MAX_WEIGHT) * 1000) / 1000;
    }
  }
  return adj;
}
