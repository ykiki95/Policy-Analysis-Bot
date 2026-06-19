export type ModelPricing = {
  inputPerMillion: number;
  outputPerMillion: number;
  secondsPerCall: number;
};

export const DEFAULT_TOTAL_AGENTS = 500;

export const INPUT_TOKENS_PER_AGENT = 700;
// gpt-5 계열은 추론 토큰(reasoning_tokens)이 completion 에 포함된다. 실측상 에이전트당
// 추론 ~800 + 실제 답변 ~100 ≈ 900 토큰이 소비되므로 추정치도 이를 반영한다(과소 추정 시
// 예산 한도 검사가 헐거워지고 표시 비용이 비현실적으로 낮아진다).
export const OUTPUT_TOKENS_PER_AGENT = 900;

export const DEFAULT_MODEL = "gpt-5-mini";

const PRICING: Record<string, ModelPricing> = {
  "gpt-5": { inputPerMillion: 1.25, outputPerMillion: 10, secondsPerCall: 2.4 },
  "gpt-5-mini": {
    inputPerMillion: 0.25,
    outputPerMillion: 2,
    secondsPerCall: 1.6,
  },
  "gpt-5-nano": {
    inputPerMillion: 0.05,
    outputPerMillion: 0.4,
    secondsPerCall: 1.0,
  },
};

const CONCURRENCY = 8;

export function isSupportedModel(model: string): boolean {
  return model in PRICING;
}

export function resolvePricing(model: string): ModelPricing {
  return PRICING[model] ?? PRICING[DEFAULT_MODEL]!;
}

export type EstimateResult = {
  model: string;
  totalAgents: number;
  inputTokensPerAgent: number;
  outputTokensPerAgent: number;
  estimatedCostUsd: number;
  estimatedLowUsd: number;
  estimatedHighUsd: number;
  estimatedSeconds: number;
};

function round(n: number, places = 4): number {
  const f = 10 ** places;
  return Math.round(n * f) / f;
}

export function estimateCost(
  model: string,
  totalAgents = DEFAULT_TOTAL_AGENTS,
): EstimateResult {
  const pricing = resolvePricing(model);
  const inputTokens = totalAgents * INPUT_TOKENS_PER_AGENT;
  const outputTokens = totalAgents * OUTPUT_TOKENS_PER_AGENT;

  const cost =
    (inputTokens / 1_000_000) * pricing.inputPerMillion +
    (outputTokens / 1_000_000) * pricing.outputPerMillion;

  const estimatedSeconds = Math.ceil(
    (totalAgents / CONCURRENCY) * pricing.secondsPerCall,
  );

  return {
    model: isSupportedModel(model) ? model : DEFAULT_MODEL,
    totalAgents,
    inputTokensPerAgent: INPUT_TOKENS_PER_AGENT,
    outputTokensPerAgent: OUTPUT_TOKENS_PER_AGENT,
    estimatedCostUsd: round(cost),
    estimatedLowUsd: round(cost * 0.75),
    estimatedHighUsd: round(cost * 1.25),
    estimatedSeconds,
  };
}

export function costFromUsage(
  model: string,
  promptTokens: number,
  completionTokens: number,
): number {
  const pricing = resolvePricing(model);
  return round(
    (promptTokens / 1_000_000) * pricing.inputPerMillion +
      (completionTokens / 1_000_000) * pricing.outputPerMillion,
  );
}

export const RUN_CONCURRENCY = CONCURRENCY;
