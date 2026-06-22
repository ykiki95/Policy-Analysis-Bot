import { describe, it, expect } from "vitest";
import type { Agent, Simulation } from "@workspace/db";
import { buildPrompt, isCommercialSim, isPolicySim } from "./prompts";

function makeAgent(): Agent {
  return {
    id: 1,
    userId: 1,
    name: "김민준",
    age: 34,
    ageBracket: "30-39",
    gender: "남성",
    district: "서울",
    lat: 37.5665,
    lng: 126.978,
    education: "대학교 졸",
    incomeBracket: "350-500만원",
    occupation: "사무직",
    householdType: "1인 가구",
    politicalLeaning: -12,
    partyAffinity: "중도 무당층",
    turnoutPropensity: 62,
    issueStances: {
      economy: 10,
      welfare: -20,
      security: 5,
      environment: -15,
      housing: -8,
    },
    consumerStances: {
      priceSensitivity: 70,
      brandLoyalty: 40,
      noveltySeeking: 65,
      ecoConsciousness: 55,
      digitalConsumption: 80,
    },
    policyStances: {
      governmentTrust: 48,
      policyAcceptance: 52,
      taxTolerance: 44,
      regulationPreference: 58,
      publicServiceSatisfaction: 56,
    },
    mediaDiet: "유튜브",
    values: ["안정", "공정", "혁신"],
    personaSummary: "서울에 거주하는 30-39 사무직.",
  };
}

function makeSim(overrides: Partial<Simulation>): Simulation {
  return {
    id: 1,
    userId: 1,
    title: "테스트 시뮬레이션",
    audience: "정치",
    product: "Dynamo",
    policyText: "평가 대상 정책 본문",
    model: "gpt-5-mini",
    status: "pending",
    progress: 0,
    totalAgents: 500,
    costEstimateUsd: 0.29,
    costActualUsd: null,
    overallSupport: null,
    supportPct: null,
    opposePct: null,
    neutralPct: null,
    summary: null,
    predictionLockedAt: null,
    predictionValue: null,
    actualValue: null,
    actualMetric: null,
    actualEnteredAt: null,
    predictionError: null,
    learnedAt: null,
    lockedBy: null,
    lockedAt: null,
    heartbeatAt: null,
    lastError: null,
    createdAt: new Date("2026-06-15T00:00:00Z"),
    completedAt: null,
    ...overrides,
  };
}

describe("track routing predicates", () => {
  it("classifies Lumen as the commercial track only", () => {
    expect(isCommercialSim(makeSim({ product: "Lumen" }))).toBe(true);
    expect(isPolicySim(makeSim({ product: "Lumen" }))).toBe(false);
  });

  it("classifies Seraph as the policy track only", () => {
    expect(isPolicySim(makeSim({ product: "Seraph" }))).toBe(true);
    expect(isCommercialSim(makeSim({ product: "Seraph" }))).toBe(false);
  });

  it("classifies Dynamo as neither commercial nor policy (political fallback)", () => {
    expect(isCommercialSim(makeSim({ product: "Dynamo" }))).toBe(false);
    expect(isPolicySim(makeSim({ product: "Dynamo" }))).toBe(false);
  });

  it("matches the product case-insensitively", () => {
    expect(isCommercialSim(makeSim({ product: "lumen" }))).toBe(true);
    expect(isPolicySim(makeSim({ product: "SERAPH" }))).toBe(true);
  });
});

describe("buildPrompt track selection", () => {
  const agent = makeAgent();

  it("routes Lumen to the consumer persona prompt", () => {
    const prompt = buildPrompt(agent, makeSim({ product: "Lumen" }));
    expect(prompt).toContain("소비자 페르소나");
    expect(prompt).toContain("소비 성향(0~100)");
    expect(prompt).not.toContain("정치성향");
    expect(prompt).not.toContain("정책 성향(0~100)");
  });

  it("routes Seraph to the policy persona prompt", () => {
    const prompt = buildPrompt(agent, makeSim({ product: "Seraph" }));
    expect(prompt).toContain("정부 정책/제도/행정 서비스");
    expect(prompt).toContain("정책 성향(0~100)");
    expect(prompt).not.toContain("소비 성향(0~100)");
    expect(prompt).not.toContain("정치성향");
  });

  it("routes Dynamo to the political persona prompt", () => {
    const prompt = buildPrompt(agent, makeSim({ product: "Dynamo" }));
    expect(prompt).toContain("정치성향");
    expect(prompt).toContain("이슈별 입장(0~100)");
    expect(prompt).not.toContain("소비 성향(0~100)");
    expect(prompt).not.toContain("정책 성향(0~100)");
  });

  it("keys the track strictly on product, never on audience", () => {
    // Audience deliberately mismatched against the product. Product must win.
    const seraphWithBizAudience = buildPrompt(
      agent,
      makeSim({ product: "Seraph", audience: "비즈니스" }),
    );
    expect(seraphWithBizAudience).toContain("정책 성향(0~100)");

    const dynamoWithGovAudience = buildPrompt(
      agent,
      makeSim({ product: "Dynamo", audience: "정부" }),
    );
    expect(dynamoWithGovAudience).toContain("정치성향");
    expect(dynamoWithGovAudience).not.toContain("정책 성향(0~100)");
  });
});
