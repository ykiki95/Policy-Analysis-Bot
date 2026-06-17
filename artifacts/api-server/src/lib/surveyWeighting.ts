import type { Survey, SurveyDriver } from "@workspace/db";
import type { AgentIssueStances } from "@workspace/db";

export type IssueKey = keyof AgentIssueStances;

export const ISSUE_KEYS: IssueKey[] = [
  "economy",
  "welfare",
  "security",
  "environment",
  "housing",
];

export const ISSUE_LABELS: Record<IssueKey, string> = {
  economy: "경제",
  welfare: "복지",
  security: "안보",
  environment: "환경",
  housing: "주거",
};

const LABEL_TO_KEY: Record<string, IssueKey> = {
  경제: "economy",
  복지: "welfare",
  안보: "security",
  환경: "environment",
  주거: "housing",
  economy: "economy",
  welfare: "welfare",
  security: "security",
  environment: "environment",
  housing: "housing",
};

export function issueToKey(issue: string): IssueKey | null {
  return LABEL_TO_KEY[issue.trim()] ?? null;
}

export type IssueAdjustment = {
  /** Sum of applied-survey driver weights mapped to this issue (capped). */
  weightSum: number;
  /** Multiplier applied to the issue's baseline ideological coupling. */
  multiplier: number;
  /** Scale on the random noise term (more survey evidence → less noise). */
  noiseScale: number;
  /** Number of applied drivers contributing to this issue. */
  driverCount: number;
  /**
   * Reliability-weighted target mean stance (-100..100) the applied surveys
   * imply for this issue, or null when no driver specified a target stance.
   */
  targetMean: number | null;
  /**
   * How strongly to rake the generated stance toward `targetMean` (0..0.85).
   * Scales with driver weight and survey reliability (sample size).
   */
  targetPull: number;
};

export type SurveyAdjustments = Record<IssueKey, IssueAdjustment>;

const MAX_WEIGHT = 1.5;
const MULTIPLIER_GAIN = 0.5; // up to +75% coupling at MAX_WEIGHT
const NOISE_REDUCTION = 0.25; // down to -25% noise at weight >= 1
const MAX_PULL = 0.85;

/**
 * Map a survey sample size to a 0..1 reliability factor. Larger samples are
 * weighted more strongly (margin-of-error style: reliability ≈ 1 − 1/√n,
 * reaching ~0.97 around n=1000). Returns 0.5 when the sample size is unknown.
 */
export function reliabilityFromSampleSize(sampleSize: number | null | undefined): number {
  const n = typeof sampleSize === "number" && Number.isFinite(sampleSize) ? sampleSize : 0;
  if (n <= 0) return 0.5;
  return Math.max(0, Math.min(1, 1 - 1 / Math.sqrt(n)));
}

function emptyAdjustment(): IssueAdjustment {
  return {
    weightSum: 0,
    multiplier: 1,
    noiseScale: 1,
    driverCount: 0,
    targetMean: null,
    targetPull: 0,
  };
}

export function emptyAdjustments(): SurveyAdjustments {
  return {
    economy: emptyAdjustment(),
    welfare: emptyAdjustment(),
    security: emptyAdjustment(),
    environment: emptyAdjustment(),
    housing: emptyAdjustment(),
  };
}

/**
 * Deterministically derive per-issue persona-generation adjustments from the
 * drivers of the surveys that are marked applied-to-population. Higher aggregate
 * survey weight on an issue amplifies how strongly that issue tracks the agent's
 * political leaning and reduces random noise — i.e. the survey acts as a prior
 * that makes the population's stance on that issue more confident.
 */
export function computeSurveyAdjustments(
  surveys: Pick<
    Survey,
    "appliedToPopulation" | "drivers" | "sampleSize" | "domain"
  >[],
): SurveyAdjustments {
  const adj = emptyAdjustments();
  // Reliability-weighted accumulators for the target stance per issue.
  const targetNum: Record<IssueKey, number> = {
    economy: 0,
    welfare: 0,
    security: 0,
    environment: 0,
    housing: 0,
  };
  const targetDen: Record<IssueKey, number> = {
    economy: 0,
    welfare: 0,
    security: 0,
    environment: 0,
    housing: 0,
  };

  for (const survey of surveys) {
    // Commercial-domain surveys feed agent.consumerStances, not the political issues.
    if (survey.domain === "commercial") continue;
    if (!survey.appliedToPopulation) continue;
    const reliability = reliabilityFromSampleSize(survey.sampleSize);
    const drivers: SurveyDriver[] = survey.drivers ?? [];
    for (const d of drivers) {
      const key = issueToKey(d.issue);
      if (!key) continue;
      const w = typeof d.weight === "number" ? d.weight : Number(d.weight);
      if (!Number.isFinite(w) || w <= 0) continue;
      // Bigger samples contribute more coupling weight.
      adj[key].weightSum += w * reliability;
      adj[key].driverCount += 1;

      const ts =
        typeof d.targetStance === "number" ? d.targetStance : Number(d.targetStance);
      if (Number.isFinite(ts)) {
        const wgt = w * reliability;
        targetNum[key] += Math.max(-100, Math.min(100, ts)) * wgt;
        targetDen[key] += wgt;
      }
    }
  }
  for (const key of ISSUE_KEYS) {
    const capped = Math.min(adj[key].weightSum, MAX_WEIGHT);
    adj[key].weightSum = Math.round(capped * 100) / 100;
    adj[key].multiplier =
      Math.round((1 + MULTIPLIER_GAIN * capped) * 1000) / 1000;
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
