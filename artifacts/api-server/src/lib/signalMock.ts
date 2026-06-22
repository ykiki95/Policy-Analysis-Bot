/**
 * 신호 인제스트 배치의 효과 수치(데모)를 결정론적으로 생성한다.
 * 실제 스크래핑·외부 API·계산은 하지 않는다 — source/product/title(또는 시나리오)
 * 입력에서 안정적으로 재현 가능한 그럴듯한 예시값을 만든다(투자자 데모용).
 */

export type SignalSource = "뉴스" | "검색트렌드" | "SNS·커뮤니티";
export type SignalProduct = "Lumen" | "Seraph" | "Dynamo";
export type SignalSentiment = "긍정" | "부정" | "중립" | "혼조";
export type SignalDirection = "up" | "down" | "mixed";

/**
 * 자동 수집 샘플 풀의 한 항목. 실제 외부 수집이 아니라 한국 이슈 시나리오 시드다.
 * 실존 정당·후보·인물명은 쓰지 않는다(이슈 중심 표현만).
 * before/after·itemCount·감성 분포는 mockSignalEffect 가 결정론적으로 산출하고,
 * sentiment/direction/magnitude/summary 가 그 산출을 시나리오 방향으로 형성한다.
 */
export type SignalScenario = {
  source: SignalSource;
  product: SignalProduct;
  title: string;
  /** 숫자 없는 서술형 1~2문장(요약 앞부분에 그대로 사용). */
  summary: string;
  sentiment: SignalSentiment;
  direction: SignalDirection;
  /** 기준 변화폭(%p, 2~6). sourceWeight 가 곱해진다. */
  magnitude: number;
};

export type SignalEffect = {
  title: string;
  itemCount: number;
  sentimentPos: number;
  sentimentNeu: number;
  sentimentNeg: number;
  summary: string;
  metric: string;
  valueBefore: number;
  valueAfter: number;
};

/** FNV-1a 해시(결정론적). */
function hashStr(s: string): number {
  let h = 2166136261;
  for (let i = 0; i < s.length; i++) {
    h ^= s.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return h >>> 0;
}

/** mulberry32 PRNG — seed 로부터 [0,1) 시퀀스. */
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

const PRODUCT_META: Record<
  SignalProduct,
  { metric: string; base: [number, number] }
> = {
  Dynamo: { metric: "지지율(%)", base: [39, 45] },
  Lumen: { metric: "구매의향(%)", base: [34, 46] },
  Seraph: { metric: "정책수용도(%)", base: [50, 60] },
};

const SOURCE_TITLES: Record<SignalSource, string[]> = {
  뉴스: [
    "청년 월세지원 관련 보도 급증",
    "물가 안정 대책 언론 집중 조명",
    "신제품 출시 주요 매체 일제 보도",
  ],
  검색트렌드: [
    "정책 키워드 검색량 주간 급상승",
    "브랜드 연관 검색어 상위권 진입",
    "지역 현안 검색 관심도 확대",
  ],
  "SNS·커뮤니티": [
    "커뮤니티 여론 확산세 포착",
    "SNS 해시태그 언급량 증가",
    "온라인 반응 양극화 심화",
  ],
};

/** 소스별 감성 성향(목업): [pos, neu, neg] 기준 가중치. */
const SOURCE_SENTIMENT: Record<SignalSource, [number, number, number]> = {
  뉴스: [34, 45, 21],
  검색트렌드: [40, 38, 22],
  "SNS·커뮤니티": [38, 22, 40],
};

/** 시나리오 감성 성향 → [pos, neu, neg] 기준값. */
const SENTIMENT_BASE: Record<SignalSentiment, [number, number, number]> = {
  긍정: [56, 30, 14],
  부정: [16, 28, 56],
  중립: [30, 50, 20],
  혼조: [41, 18, 41],
};

/**
 * 자동 수집 샘플 풀 — 한국 이슈 시나리오(실존 정당·인물명 없음).
 * 비즈니스(Lumen)=구매의향, 정부(Seraph)=정책수용도, 정치(Dynamo)=지지율.
 */
export const AUTO_SCENARIOS: SignalScenario[] = [
  // ── 비즈니스 / 구매의향(%) ──
  {
    source: "뉴스",
    product: "Lumen",
    title: "주요 OTT 구독료 인상 발표",
    summary:
      "주요 OTT 사업자의 구독료 인상 소식이 매체에 집중 보도되며 가격 부담 우려가 커지고 있습니다.",
    sentiment: "부정",
    direction: "down",
    magnitude: 4,
  },
  {
    source: "뉴스",
    product: "Lumen",
    title: "편의점 PB·가성비 상품 라인업 확대",
    summary:
      "가성비 중심 PB 상품 출시가 긍정적으로 보도되며 합리적 소비에 대한 기대가 높아지고 있습니다.",
    sentiment: "긍정",
    direction: "up",
    magnitude: 3,
  },
  {
    source: "검색트렌드",
    product: "Lumen",
    title: "'무지출 챌린지' 검색량 급증",
    summary:
      "절약 소비를 상징하는 키워드 검색이 급상승하며 가격 민감도가 강화되는 신호가 포착됐습니다.",
    sentiment: "부정",
    direction: "down",
    magnitude: 5,
  },
  {
    source: "SNS·커뮤니티",
    product: "Lumen",
    title: "배달앱 수수료 인상 불매 언급 확산",
    summary:
      "수수료 인상에 대한 반발이 커뮤니티에서 불매 언급으로 확산되고 있습니다.",
    sentiment: "부정",
    direction: "down",
    magnitude: 5,
  },
  {
    source: "SNS·커뮤니티",
    product: "Lumen",
    title: "신제품 언박싱 긍정 후기 확산",
    summary:
      "초기 사용자들의 호의적인 언박싱 후기가 SNS에서 빠르게 확산되고 있습니다.",
    sentiment: "긍정",
    direction: "up",
    magnitude: 4,
  },
  // ── 정부 / 정책수용도(%) ──
  {
    source: "뉴스",
    product: "Seraph",
    title: "전자정부·민원 서비스 개편 발표",
    summary:
      "디지털 행정 개선안이 보도되며 공공 서비스 편의 향상에 대한 기대가 형성됐습니다.",
    sentiment: "긍정",
    direction: "up",
    magnitude: 3,
  },
  {
    source: "뉴스",
    product: "Seraph",
    title: "공공요금 인상 계획 보도",
    summary:
      "공공요금 인상 계획이 보도되며 가계 부담 증가 우려가 부각되고 있습니다.",
    sentiment: "부정",
    direction: "down",
    magnitude: 4,
  },
  {
    source: "검색트렌드",
    product: "Seraph",
    title: "'재난지원금 신청' 검색 폭증",
    summary:
      "지원 정책에 대한 관심이 검색량 급증으로 나타나며 정책 수용 분위기가 형성되고 있습니다.",
    sentiment: "긍정",
    direction: "up",
    magnitude: 5,
  },
  {
    source: "SNS·커뮤니티",
    product: "Seraph",
    title: "행정 서비스 접속 지연·오류 불만 확산",
    summary:
      "행정 서비스 접속 장애에 대한 불만이 온라인에서 확산되고 있습니다.",
    sentiment: "부정",
    direction: "down",
    magnitude: 4,
  },
  // ── 정치 / 지지율(%) ──
  {
    source: "뉴스",
    product: "Dynamo",
    title: "청년 주거지원 확대안 집중 보도",
    summary:
      "청년 주거 지원 확대안이 긍정적으로 집중 보도되고 있습니다.",
    sentiment: "긍정",
    direction: "up",
    magnitude: 4,
  },
  {
    source: "뉴스",
    product: "Dynamo",
    title: "증세 필요성 논의 보도 확대",
    summary:
      "증세 필요성에 대한 논의가 확대 보도되며 세 부담 우려가 부각되고 있습니다.",
    sentiment: "부정",
    direction: "down",
    magnitude: 4,
  },
  {
    source: "검색트렌드",
    product: "Dynamo",
    title: "지역 현안 정책 키워드 검색 급상승",
    summary:
      "지역 현안 관련 정책 키워드 검색이 늘며 관심이 확대되는 신호가 포착됐습니다.",
    sentiment: "중립",
    direction: "up",
    magnitude: 2,
  },
  {
    source: "SNS·커뮤니티",
    product: "Dynamo",
    title: "현안 관련 온라인 여론 양극화 심화",
    summary:
      "현안을 둘러싼 찬반 대립이 온라인에서 격화되며 여론 양극화가 심화되고 있습니다.",
    sentiment: "혼조",
    direction: "mixed",
    magnitude: 3,
  },
];

/** 시드 리셋용 큐레이션 부분집합(부문·소스·방향 균형). */
export const RESET_SCENARIOS: SignalScenario[] = [
  AUTO_SCENARIOS[0], // 비즈 뉴스 ↓
  AUTO_SCENARIOS[2], // 비즈 검색 ↓
  AUTO_SCENARIOS[4], // 비즈 SNS ↑
  AUTO_SCENARIOS[5], // 정부 뉴스 ↑
  AUTO_SCENARIOS[7], // 정부 검색 ↑
  AUTO_SCENARIOS[6], // 정부 뉴스 ↓
  AUTO_SCENARIOS[9], // 정치 뉴스 ↑
  AUTO_SCENARIOS[10], // 정치 뉴스 ↓
];

function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v));
}

export function mockSignalEffect(
  source: SignalSource,
  product: SignalProduct,
  title?: string | null,
  sourceWeight = 1,
  scenario?: SignalScenario,
): SignalEffect {
  const seedKey = `${source}|${product}|${scenario?.title ?? title ?? ""}`;
  const rand = mulberry32(hashStr(seedKey));

  const meta = PRODUCT_META[product];
  const titles = SOURCE_TITLES[source];
  const resolvedTitle = scenario
    ? scenario.title
    : title && title.trim().length > 0
      ? title.trim()
      : titles[Math.floor(rand() * titles.length)];

  const itemCount = 120 + Math.floor(rand() * 880);

  // 감성: 시나리오가 있으면 시나리오 성향 기준, 없으면 소스 기준 + 노이즈, 합 100 재정규화.
  const [bp, , bg] = scenario
    ? SENTIMENT_BASE[scenario.sentiment]
    : SOURCE_SENTIMENT[source];
  let pos = clamp(bp + Math.round((rand() - 0.5) * 12), 5, 80);
  let neg = clamp(bg + Math.round((rand() - 0.5) * 12), 5, 80);
  let neu = Math.max(0, 100 - pos - neg);
  const sum = pos + neu + neg;
  pos = Math.round((pos / sum) * 100);
  neg = Math.round((neg / sum) * 100);
  neu = 100 - pos - neg;

  // before: 제품 기준 범위(결정론적).
  const [lo, hi] = meta.base;
  const before = Math.round((lo + rand() * (hi - lo)) * 10) / 10;

  // 변화폭·방향: 시나리오가 있으면 시나리오 강도/방향, 없으면 감성에서 유도.
  let magnitudeBase: number;
  let direction: number;
  if (scenario) {
    magnitudeBase =
      scenario.direction === "mixed" ? scenario.magnitude * 0.6 : scenario.magnitude;
    direction =
      scenario.direction === "up"
        ? 1
        : scenario.direction === "down"
          ? -1
          : rand() < 0.5
            ? -1
            : 1;
  } else {
    magnitudeBase = 2 + rand() * 4; // 2~6
    direction = pos >= neg ? 1 : -1;
  }
  // 소스 가중치(0~2)를 강도에 곱한다 — 관리자가 소스 비중을 키우면 효과 Δ 가 커진다.
  const magnitude = magnitudeBase * sourceWeight;
  const after = clamp(
    Math.round((before + direction * magnitude) * 10) / 10,
    0,
    100,
  );

  const realDelta = Math.round((after - before) * 10) / 10;
  const deltaTxt = `${realDelta >= 0 ? "+" : "−"}${Math.abs(realDelta).toFixed(1)}%p`;
  const trend = realDelta > 0 ? "상승" : realDelta < 0 ? "하락" : "변동";

  const summary = scenario
    ? `${scenario.summary} ${source} 채널에서 관련 신호 ${itemCount.toLocaleString()}건이 관측됐고, ` +
      `긍정 ${pos}% · 중립 ${neu}% · 부정 ${neg}% 분포에서 합성 여론 ${meta.metric} 지표가 ` +
      `${before}% → ${after}% (${deltaTxt})로 ${trend}하는 것으로 추정됩니다.`
    : `${source} 채널에서 '${resolvedTitle}' 관련 신호 ${itemCount.toLocaleString()}건을 배치 수집했습니다. ` +
      `긍정 ${pos}% · 중립 ${neu}% · 부정 ${neg}% 의 감성 분포가 관측되었으며, ` +
      `합성 여론 ${meta.metric} 지표가 ${before}% → ${after}% (${deltaTxt})로 ${trend}하는 것으로 추정됩니다.`;

  return {
    title: resolvedTitle,
    itemCount,
    sentimentPos: pos,
    sentimentNeu: neu,
    sentimentNeg: neg,
    summary,
    metric: meta.metric,
    valueBefore: before,
    valueAfter: after,
  };
}
