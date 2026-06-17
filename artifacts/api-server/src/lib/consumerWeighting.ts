import type { Survey, SurveyDriver, AgentConsumerStances } from "@workspace/db";
import { reliabilityFromSampleSize } from "./surveyWeighting";

export type ConsumerAxisKey = keyof AgentConsumerStances;

export const CONSUMER_AXIS_KEYS: ConsumerAxisKey[] = [
  "priceSensitivity",
  "brandLoyalty",
  "noveltySeeking",
  "ecoConsciousness",
  "digitalConsumption",
];

export const CONSUMER_AXIS_LABELS: Record<ConsumerAxisKey, string> = {
  priceSensitivity: "가격민감도",
  brandLoyalty: "브랜드충성도",
  noveltySeeking: "신제품수용",
  ecoConsciousness: "친환경소비",
  digitalConsumption: "디지털소비",
};

const LABEL_TO_KEY: Record<string, ConsumerAxisKey> = {
  가격민감도: "priceSensitivity",
  브랜드충성도: "brandLoyalty",
  신제품수용: "noveltySeeking",
  친환경소비: "ecoConsciousness",
  디지털소비: "digitalConsumption",
  priceSensitivity: "priceSensitivity",
  brandLoyalty: "brandLoyalty",
  noveltySeeking: "noveltySeeking",
  ecoConsciousness: "ecoConsciousness",
  digitalConsumption: "digitalConsumption",
};

export function consumerAxisToKey(issue: string): ConsumerAxisKey | null {
  return LABEL_TO_KEY[issue.trim()] ?? null;
}

export type ConsumerAdjustment = {
  /** Sum of applied-survey driver weights mapped to this axis (capped). */
  weightSum: number;
  /** Scale on the random noise term (more survey evidence → less noise). */
  noiseScale: number;
  /** Number of applied drivers contributing to this axis. */
  driverCount: number;
  /**
   * Reliability-weighted target mean (0..100) the applied commercial surveys
   * imply for this axis, or null when no driver specified a target.
   */
  targetMean: number | null;
  /** How strongly to rake the generated value toward `targetMean` (0..0.85). */
  targetPull: number;
};

export type ConsumerAdjustments = Record<ConsumerAxisKey, ConsumerAdjustment>;

const MAX_WEIGHT = 1.5;
const NOISE_REDUCTION = 0.25; // down to -25% noise at weight >= 1
const MAX_PULL = 0.85;

function emptyAdjustment(): ConsumerAdjustment {
  return {
    weightSum: 0,
    noiseScale: 1,
    driverCount: 0,
    targetMean: null,
    targetPull: 0,
  };
}

export function emptyConsumerAdjustments(): ConsumerAdjustments {
  return {
    priceSensitivity: emptyAdjustment(),
    brandLoyalty: emptyAdjustment(),
    noveltySeeking: emptyAdjustment(),
    ecoConsciousness: emptyAdjustment(),
    digitalConsumption: emptyAdjustment(),
  };
}

/**
 * Deterministically derive per-axis consumer-generation adjustments from the
 * drivers of the `domain === "commercial"` surveys marked applied-to-population.
 * Each commercial driver supplies a reliability-weighted target (0..100) toward
 * which the demographic base value is raked, and more aggregate survey evidence
 * reduces random noise — mirroring the political track's raking, but on the
 * consumer axes used by the Lumen product line.
 */
export function computeConsumerAdjustments(
  surveys: Pick<
    Survey,
    "appliedToPopulation" | "drivers" | "sampleSize" | "domain"
  >[],
): ConsumerAdjustments {
  const adj = emptyConsumerAdjustments();
  const targetNum: Record<ConsumerAxisKey, number> = {
    priceSensitivity: 0,
    brandLoyalty: 0,
    noveltySeeking: 0,
    ecoConsciousness: 0,
    digitalConsumption: 0,
  };
  const targetDen: Record<ConsumerAxisKey, number> = {
    priceSensitivity: 0,
    brandLoyalty: 0,
    noveltySeeking: 0,
    ecoConsciousness: 0,
    digitalConsumption: 0,
  };

  for (const survey of surveys) {
    if (survey.domain !== "commercial") continue;
    if (!survey.appliedToPopulation) continue;
    const reliability = reliabilityFromSampleSize(survey.sampleSize);
    const drivers: SurveyDriver[] = survey.drivers ?? [];
    for (const d of drivers) {
      const key = consumerAxisToKey(d.issue);
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

  for (const key of CONSUMER_AXIS_KEYS) {
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
