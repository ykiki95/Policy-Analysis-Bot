import type { InsertAgent, AgentIssueStances } from "@workspace/db";

type District = {
  name: string;
  lat: number;
  lng: number;
  weight: number;
  leaningBias: number;
};

const DISTRICTS: District[] = [
  { name: "강남구", lat: 37.5172, lng: 127.0473, weight: 5.5, leaningBias: 18 },
  { name: "강동구", lat: 37.5301, lng: 127.1238, weight: 4.6, leaningBias: 4 },
  { name: "강북구", lat: 37.6396, lng: 127.0257, weight: 3.1, leaningBias: -10 },
  { name: "강서구", lat: 37.5509, lng: 126.8495, weight: 5.9, leaningBias: -4 },
  { name: "관악구", lat: 37.4784, lng: 126.9516, weight: 5.0, leaningBias: -16 },
  { name: "광진구", lat: 37.5385, lng: 127.0823, weight: 3.6, leaningBias: -6 },
  { name: "구로구", lat: 37.4954, lng: 126.8874, weight: 4.1, leaningBias: -8 },
  { name: "금천구", lat: 37.4569, lng: 126.8956, weight: 2.4, leaningBias: -9 },
  { name: "노원구", lat: 37.6542, lng: 127.0568, weight: 5.2, leaningBias: -12 },
  { name: "도봉구", lat: 37.6688, lng: 127.0471, weight: 3.2, leaningBias: -7 },
  { name: "동대문구", lat: 37.5744, lng: 127.0397, weight: 3.5, leaningBias: -5 },
  { name: "동작구", lat: 37.5124, lng: 126.9393, weight: 3.9, leaningBias: -3 },
  { name: "마포구", lat: 37.5663, lng: 126.9019, weight: 3.7, leaningBias: -11 },
  { name: "서대문구", lat: 37.5791, lng: 126.9368, weight: 3.0, leaningBias: -6 },
  { name: "서초구", lat: 37.4837, lng: 127.0324, weight: 4.2, leaningBias: 20 },
  { name: "성동구", lat: 37.5634, lng: 127.0369, weight: 2.9, leaningBias: -2 },
  { name: "성북구", lat: 37.5894, lng: 127.0167, weight: 4.3, leaningBias: -8 },
  { name: "송파구", lat: 37.5145, lng: 127.1059, weight: 6.6, leaningBias: 10 },
  { name: "양천구", lat: 37.5169, lng: 126.8665, weight: 4.5, leaningBias: 2 },
  { name: "영등포구", lat: 37.5264, lng: 126.8962, weight: 3.7, leaningBias: -1 },
  { name: "용산구", lat: 37.5324, lng: 126.99, weight: 2.2, leaningBias: 8 },
  { name: "은평구", lat: 37.6027, lng: 126.9291, weight: 4.7, leaningBias: -9 },
  { name: "종로구", lat: 37.5735, lng: 126.979, weight: 1.5, leaningBias: 0 },
  { name: "중구", lat: 37.5638, lng: 126.9976, weight: 1.2, leaningBias: 1 },
  { name: "중랑구", lat: 37.6063, lng: 127.0927, weight: 3.9, leaningBias: -8 },
];

const AGE_BRACKETS: { bracket: string; min: number; max: number; weight: number }[] =
  [
    { bracket: "18-29", min: 18, max: 29, weight: 19 },
    { bracket: "30-39", min: 30, max: 39, weight: 18 },
    { bracket: "40-49", min: 40, max: 49, weight: 20 },
    { bracket: "50-59", min: 50, max: 59, weight: 20 },
    { bracket: "60-69", min: 60, max: 69, weight: 13 },
    { bracket: "70+", min: 70, max: 84, weight: 10 },
  ];

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
const SURNAMES =
  "김이박최정강조윤장임한오서신권황안송류전홍".split("");
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

function weightedPick<T extends { weight: number }>(
  items: T[],
  r: number,
): T {
  const total = items.reduce((acc, i) => acc + i.weight, 0);
  let cursor = r * total;
  for (const item of items) {
    cursor -= item.weight;
    if (cursor <= 0) return item;
  }
  return items[items.length - 1];
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
  const lean =
    a.leaning <= -34 ? "진보" : a.leaning >= 34 ? "보수" : "중도";
  return `${a.district}에 거주하는 ${a.ageBracket} ${a.occupation}. 정치 성향은 ${lean}이며 ${a.values.join(
    ", ",
  )} 가치를 중시한다.`;
}

export function generateAgents(count: number, seed = 20260615): InsertAgent[] {
  const rand = mulberry32(seed);
  const agents: InsertAgent[] = [];

  for (let i = 0; i < count; i++) {
    const district = weightedPick(DISTRICTS, rand());
    const ageInfo = weightedPick(AGE_BRACKETS, rand());
    const age =
      ageInfo.min + Math.floor(rand() * (ageInfo.max - ageInfo.min + 1));
    const gender = rand() < 0.49 ? "Male" : "Female";

    const lat = district.lat + (rand() - 0.5) * 0.045;
    const lng = district.lng + (rand() - 0.5) * 0.05;

    const ageLeaning = (age - 45) * 0.9;
    const leaning = Math.round(
      clamp(
        ageLeaning + district.leaningBias + gaussian(rand) * 22,
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
      Math.round(2 + (age >= 35 && age <= 60 ? 0.6 : -0.4) + gaussian(rand) * 1.2),
      0,
      INCOME_BRACKETS.length - 1,
    );

    const stance = (bias: number): number =>
      Math.round(clamp(leaning * bias + gaussian(rand) * 18, -100, 100));
    const issueStances: AgentIssueStances = {
      economy: stance(0.7),
      welfare: stance(-0.6),
      security: stance(0.65),
      environment: stance(-0.5),
      housing: stance(-0.4),
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
      name,
      age,
      ageBracket: ageInfo.bracket,
      gender,
      district: district.name,
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
      mediaDiet: MEDIA_DIETS[Math.floor(rand() * MEDIA_DIETS.length)],
      values,
      personaSummary: buildPersona({
        ageBracket: ageInfo.bracket,
        district: district.name,
        occupation,
        leaning,
        values,
      }),
    });
  }

  return agents;
}
