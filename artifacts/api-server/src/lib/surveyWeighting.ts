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
};

export type SurveyAdjustments = Record<IssueKey, IssueAdjustment>;

const MAX_WEIGHT = 1.5;
const MULTIPLIER_GAIN = 0.5; // up to +75% coupling at MAX_WEIGHT
const NOISE_REDUCTION = 0.25; // down to -25% noise at weight >= 1

function emptyAdjustment(): IssueAdjustment {
  return { weightSum: 0, multiplier: 1, noiseScale: 1, driverCount: 0 };
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
  surveys: Pick<Survey, "appliedToPopulation" | "drivers">[],
): SurveyAdjustments {
  const adj = emptyAdjustments();
  for (const survey of surveys) {
    if (!survey.appliedToPopulation) continue;
    const drivers: SurveyDriver[] = survey.drivers ?? [];
    for (const d of drivers) {
      const key = issueToKey(d.issue);
      if (!key) continue;
      const w = typeof d.weight === "number" ? d.weight : Number(d.weight);
      if (!Number.isFinite(w) || w <= 0) continue;
      adj[key].weightSum += w;
      adj[key].driverCount += 1;
    }
  }
  for (const key of ISSUE_KEYS) {
    const capped = Math.min(adj[key].weightSum, MAX_WEIGHT);
    adj[key].weightSum = Math.round(capped * 100) / 100;
    adj[key].multiplier =
      Math.round((1 + MULTIPLIER_GAIN * capped) * 1000) / 1000;
    adj[key].noiseScale =
      Math.round((1 - NOISE_REDUCTION * Math.min(capped, 1)) * 1000) / 1000;
  }
  return adj;
}
