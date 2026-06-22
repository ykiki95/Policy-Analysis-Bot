/**
 * 신호 인제스트 배치의 효과 수치(데모)를 결정론적으로 생성한다.
 * 실제 스크래핑·외부 API·계산은 하지 않는다 — source/product/title 입력에서
 * 안정적으로 재현 가능한 그럴듯한 예시값을 만든다(투자자 데모용).
 */

export type SignalSource = "뉴스" | "검색트렌드" | "SNS·커뮤니티";
export type SignalProduct = "Lumen" | "Seraph" | "Dynamo";

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

function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v));
}

export function mockSignalEffect(
  source: SignalSource,
  product: SignalProduct,
  title?: string | null,
  sourceWeight = 1,
): SignalEffect {
  const seedKey = `${source}|${product}|${title ?? ""}`;
  const rand = mulberry32(hashStr(seedKey));

  const meta = PRODUCT_META[product];
  const titles = SOURCE_TITLES[source];
  const resolvedTitle =
    title && title.trim().length > 0
      ? title.trim()
      : titles[Math.floor(rand() * titles.length)];

  const itemCount = 120 + Math.floor(rand() * 880);

  // 감성: 소스 기준 + 소폭 노이즈, 합 100 재정규화
  const [bp, bn, bg] = SOURCE_SENTIMENT[source];
  let pos = clamp(bp + Math.round((rand() - 0.5) * 12), 5, 80);
  let neg = clamp(bg + Math.round((rand() - 0.5) * 12), 5, 80);
  let neu = Math.max(0, 100 - pos - neg);
  const sum = pos + neu + neg;
  pos = Math.round((pos / sum) * 100);
  neg = Math.round((neg / sum) * 100);
  neu = 100 - pos - neg;

  // before/after: 제품 기준 범위 + ±2~6%p 변화(긍정여론이 높으면 상승 쪽으로)
  const [lo, hi] = meta.base;
  const before = Math.round((lo + rand() * (hi - lo)) * 10) / 10;
  // 소스 가중치(0~2)를 강도에 곱한다 — 관리자가 소스 비중을 키우면 효과 Δ 가 커진다.
  const magnitude = (2 + rand() * 4) * sourceWeight; // (2~6) × sourceWeight
  const direction = pos >= neg ? 1 : -1;
  const after = clamp(
    Math.round((before + direction * magnitude) * 10) / 10,
    0,
    100,
  );

  const realDelta = Math.round((after - before) * 10) / 10;
  const deltaTxt = `${realDelta >= 0 ? "+" : "−"}${Math.abs(realDelta).toFixed(1)}%p`;
  const summary =
    `${source} 채널에서 '${resolvedTitle}' 관련 신호 ${itemCount.toLocaleString()}건을 배치 수집했습니다. ` +
    `긍정 ${pos}% · 중립 ${neu}% · 부정 ${neg}% 의 감성 분포가 관측되었으며, ` +
    `합성 여론 ${meta.metric} 지표가 ${before}% → ${after}% (${deltaTxt})로 ${realDelta >= 0 ? "상승" : "하락"}하는 것으로 추정됩니다.`;

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
