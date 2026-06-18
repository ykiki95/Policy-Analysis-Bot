import type {
  InsertAgent,
  AgentIssueStances,
  AgentConsumerStances,
  AgentPolicyStances,
} from "@workspace/db";
import {
  emptyAdjustments,
  type SurveyAdjustments,
  type IssueKey,
} from "./surveyWeighting";
import {
  emptyConsumerAdjustments,
  type ConsumerAdjustments,
  type ConsumerAxisKey,
} from "./consumerWeighting";
import {
  emptyPolicyAdjustments,
  type PolicyAdjustments,
  type PolicyAxisKey,
} from "./policyWeighting";
import { fitJoint, allocate, type Marginal } from "./raking";

export type RegionMeta = {
  code: string;
  name: string;
  lat: number;
  lng: number;
  leaningBias: number;
};

export type AgeMarginal = {
  bracket: string;
  population: number;
};

export type GenerationInputs = {
  count: number;
  seed?: number;
  /** 생성되는 모든 에이전트의 소유자(테넌트) userId. */
  userId: number;
  /** Region geo + political metadata for every region in scope. */
  regions: RegionMeta[];
  /** Official region marginal (population per region code). */
  regionMarginals: Marginal[];
  /** Official age marginal (population per age bracket). */
  ageMarginals: AgeMarginal[];
  /** Official gender marginal (population per gender: Male/Female). */
  genderMarginals: Marginal[];
  adjustments?: SurveyAdjustments;
  /** Consumer-axis raking adjustments derived from commercial-domain surveys. */
  consumerAdjustments?: ConsumerAdjustments;
  /** Policy-axis raking adjustments derived from policy-domain surveys. */
  policyAdjustments?: PolicyAdjustments;
  /**
   * 입력 보정(Lever 1) 기준선 이동량. 검증 이벤트의 평균 편향에서 환산된
   * 결정론적 가산 이동 — political 은 정치성향(leaning), consumer/policy 는
   * 각 성향 축의 최종값에 더해진다. PRNG 스트림은 건드리지 않는다.
   */
  calibrationOffsets?: {
    political: number;
    consumer: number;
    policy: number;
  };
};

const AGE_RANGES: Record<string, { min: number; max: number }> = {
  "18-29": { min: 18, max: 29 },
  "30-39": { min: 30, max: 39 },
  "40-49": { min: 40, max: 49 },
  "50-59": { min: 50, max: 59 },
  "60-69": { min: 60, max: 69 },
  "70+": { min: 70, max: 84 },
};

const EDUCATIONS = ["고졸 이하", "전문대 졸", "대학교 졸", "대학원 졸"];
const INCOME_BRACKETS = [
  "200만원 미만",
  "200-350만원",
  "350-500만원",
  "500-700만원",
  "700만원 이상",
];
const HOUSEHOLD_TYPES = ["1인 가구", "부부 가구", "자녀 양육 가구", "다세대 가구"];
const OCCUPATIONS = [
  "사무직",
  "전문직",
  "자영업",
  "서비스직",
  "생산직",
  "공무원",
  "학생",
  "주부",
  "은퇴",
  "프리랜서",
];
const MEDIA_DIETS = [
  "지상파/종편 뉴스",
  "포털 뉴스",
  "유튜브",
  "SNS",
  "신문/팟캐스트",
];
const VALUE_POOL = [
  "안정",
  "성장",
  "공정",
  "자유",
  "공동체",
  "전통",
  "혁신",
  "환경",
  "안전",
  "다양성",
];
const SURNAMES = "김이박최정강조윤장임한오서신권황안송류전홍".split("");
const GIVEN = [
  "민준",
  "서연",
  "도윤",
  "지우",
  "예준",
  "하은",
  "주원",
  "지호",
  "수아",
  "지민",
  "현우",
  "서윤",
  "건우",
  "민서",
  "유준",
  "채원",
  "준서",
  "지아",
  "은우",
  "다은",
  "영수",
  "정희",
  "순자",
  "철수",
  "미경",
  "성호",
  "경숙",
  "동현",
  "혜진",
  "광수",
];

function mulberry32(seed: number): () => number {
  let a = seed >>> 0;
  return () => {
    a |= 0;
    a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v));
}

function gaussian(rand: () => number): number {
  const u = 1 - rand();
  const v = rand();
  return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * v);
}

function partyFromLeaning(leaning: number): string {
  if (leaning <= -45) return "진보 정당 지지";
  if (leaning <= -15) return "진보 성향 무당층";
  if (leaning < 15) return "중도 무당층";
  if (leaning < 45) return "보수 성향 무당층";
  return "보수 정당 지지";
}

function buildPersona(a: {
  ageBracket: string;
  district: string;
  occupation: string;
  leaning: number;
  values: string[];
}): string {
  const lean = a.leaning <= -34 ? "진보" : a.leaning >= 34 ? "보수" : "중도";
  return `${a.district}에 거주하는 ${a.ageBracket} ${a.occupation}. 정치 성향은 ${lean}이며 ${a.values.join(
    ", ",
  )} 가치를 중시한다.`;
}

/**
 * Deterministically generate a synthetic population whose region × age × gender
 * marginals match the supplied official statistics (via IPF raking + integer
 * allocation). Within each fitted cell, attributes are drawn from a seeded PRNG.
 * Same inputs + same seed always produce an identical population.
 */
export function generateAgents(inputs: GenerationInputs): InsertAgent[] {
  const {
    count,
    seed = 20260615,
    userId,
    regions,
    regionMarginals,
    ageMarginals,
    genderMarginals,
    adjustments = emptyAdjustments(),
    consumerAdjustments = emptyConsumerAdjustments(),
    policyAdjustments = emptyPolicyAdjustments(),
    calibrationOffsets = { political: 0, consumer: 0, policy: 0 },
  } = inputs;

  const regionByCode = new Map(regions.map((r) => [r.code, r]));
  const ageByBracket = new Map(ageMarginals.map((a) => [a.bracket, a]));

  const joint = fitJoint(
    regionMarginals.filter((m) => regionByCode.has(m.key)),
    ageMarginals.map((a) => ({ key: a.bracket, population: a.population })),
    genderMarginals,
  );
  const allocated = allocate(joint, count);

  const rand = mulberry32(seed);
  // Independent PRNG stream for consumer-axis noise. Kept separate from `rand`
  // so adding the commercial track does NOT shift the political stream — agents'
  // political attributes stay byte-identical whether or not consumer stances are
  // generated, preserving determinism + non-overlap with the Seraph/Dynamo track.
  const consumerRand = mulberry32(seed ^ 0x6d2b79f5);
  // Third independent PRNG stream for policy-axis noise, seeded with a distinct
  // constant (≠ rand and ≠ consumerRand) so adding the Seraph policy track does
  // NOT shift the political or consumer streams — agents' political + consumer
  // attributes stay byte-identical whether or not policy stances are generated.
  const policyRand = mulberry32(seed ^ 0x85ebca6b);
  const agents: InsertAgent[] = [];

  for (const cell of allocated) {
    if (cell.count <= 0) continue;
    const region = regionByCode.get(cell.region);
    if (!region) continue;
    const range = AGE_RANGES[cell.age] ?? { min: 18, max: 84 };
    const gender = cell.gender;
    void ageByBracket; // marginals validated upstream

    for (let n = 0; n < cell.count; n++) {
      const age = range.min + Math.floor(rand() * (range.max - range.min + 1));

      const lat = region.lat + (rand() - 0.5) * 0.16;
      const lng = region.lng + (rand() - 0.5) * 0.2;

      const ageLeaning = (age - 45) * 0.9;
      const leaning = Math.round(
        clamp(
          ageLeaning +
            region.leaningBias +
            gaussian(rand) * 22 +
            calibrationOffsets.political,
          -100,
          100,
        ),
      );

      const turnoutBase = 45 + (age - 18) * 0.7;
      const turnoutPropensity = Math.round(
        clamp(turnoutBase + gaussian(rand) * 12, 5, 99),
      );

      const eduIdx = clamp(
        Math.round((age < 35 ? 2.4 : 1.6) + gaussian(rand) * 1.1),
        0,
        EDUCATIONS.length - 1,
      );
      const incomeIdx = clamp(
        Math.round(
          2 + (age >= 35 && age <= 60 ? 0.6 : -0.4) + gaussian(rand) * 1.2,
        ),
        0,
        INCOME_BRACKETS.length - 1,
      );

      const stance = (key: IssueKey, bias: number): number => {
        const a = adjustments[key];
        const base = leaning * bias * a.multiplier;
        const noise = gaussian(rand) * 18 * a.noiseScale;
        // Rake the stance toward the survey-implied target mean when present.
        const raked =
          a.targetMean !== null && a.targetPull > 0
            ? base * (1 - a.targetPull) + a.targetMean * a.targetPull
            : base;
        return Math.round(clamp(raked + noise, -100, 100));
      };
      const issueStances: AgentIssueStances = {
        economy: stance("economy", 0.7),
        welfare: stance("welfare", -0.6),
        security: stance("security", 0.65),
        environment: stance("environment", -0.5),
        housing: stance("housing", -0.4),
      };

      // Consumer axes (0..100): deterministic demographic base + noise, raked
      // toward commercial-survey targets. Distinct from the political issues.
      const consumerStance = (key: ConsumerAxisKey, base: number): number => {
        const c = consumerAdjustments[key];
        const noise = gaussian(consumerRand) * 12 * c.noiseScale;
        const raked =
          c.targetMean !== null && c.targetPull > 0
            ? base * (1 - c.targetPull) + c.targetMean * c.targetPull
            : base;
        return Math.round(
          clamp(raked + noise + calibrationOffsets.consumer, 0, 100),
        );
      };
      const consumerStances: AgentConsumerStances = {
        priceSensitivity: consumerStance(
          "priceSensitivity",
          80 - incomeIdx * 11 + (age >= 60 ? 6 : 0),
        ),
        brandLoyalty: consumerStance("brandLoyalty", 30 + (age - 20) * 0.7),
        noveltySeeking: consumerStance(
          "noveltySeeking",
          78 - (age - 25) * 0.8 + eduIdx * 4,
        ),
        ecoConsciousness: consumerStance(
          "ecoConsciousness",
          48 + eduIdx * 5 - (age - 40) * 0.25,
        ),
        digitalConsumption: consumerStance(
          "digitalConsumption",
          95 - (age - 25) * 1.0,
        ),
      };

      // Policy axes (0..100): deterministic demographic base + noise (own PRNG
      // stream), raked toward policy-survey targets. Distinct from political
      // issues and consumer axes — used by the Seraph product line.
      const policyStance = (key: PolicyAxisKey, base: number): number => {
        const p = policyAdjustments[key];
        const noise = gaussian(policyRand) * 12 * p.noiseScale;
        const raked =
          p.targetMean !== null && p.targetPull > 0
            ? base * (1 - p.targetPull) + p.targetMean * p.targetPull
            : base;
        return Math.round(
          clamp(raked + noise + calibrationOffsets.policy, 0, 100),
        );
      };
      const policyStances: AgentPolicyStances = {
        governmentTrust: policyStance(
          "governmentTrust",
          50 + (age - 45) * 0.3 - eduIdx * 3,
        ),
        policyAcceptance: policyStance(
          "policyAcceptance",
          52 + (age - 45) * 0.25 - eduIdx * 2,
        ),
        taxTolerance: policyStance(
          "taxTolerance",
          44 + eduIdx * 4 - (age - 40) * 0.15,
        ),
        regulationPreference: policyStance(
          "regulationPreference",
          58 + (age - 40) * 0.2 + eduIdx * 2,
        ),
        publicServiceSatisfaction: policyStance(
          "publicServiceSatisfaction",
          56 - (age - 45) * 0.1,
        ),
      };

      const values: string[] = [];
      while (values.length < 3) {
        const v = VALUE_POOL[Math.floor(rand() * VALUE_POOL.length)];
        if (!values.includes(v)) values.push(v);
      }

      const occupation =
        age >= 67
          ? "은퇴"
          : age <= 24 && rand() < 0.6
            ? "학생"
            : OCCUPATIONS[Math.floor(rand() * OCCUPATIONS.length)];

      const name =
        SURNAMES[Math.floor(rand() * SURNAMES.length)] +
        GIVEN[Math.floor(rand() * GIVEN.length)];

      agents.push({
        userId,
        name,
        age,
        ageBracket: cell.age,
        gender,
        district: region.name,
        lat: Math.round(lat * 1e6) / 1e6,
        lng: Math.round(lng * 1e6) / 1e6,
        education: EDUCATIONS[eduIdx],
        incomeBracket: INCOME_BRACKETS[incomeIdx],
        occupation,
        householdType:
          HOUSEHOLD_TYPES[Math.floor(rand() * HOUSEHOLD_TYPES.length)],
        politicalLeaning: leaning,
        partyAffinity: partyFromLeaning(leaning),
        turnoutPropensity,
        issueStances,
        consumerStances,
        policyStances,
        mediaDiet: MEDIA_DIETS[Math.floor(rand() * MEDIA_DIETS.length)],
        values,
        personaSummary: buildPersona({
          ageBracket: cell.age,
          district: region.name,
          occupation,
          leaning,
          values,
        }),
      });
    }
  }

  return agents;
}
