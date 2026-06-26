/**
 * 신호 인제스트 실제 파이프라인.
 *
 * 목업(`signalMock.ts`)과 달리 여기서는 실제 외부 데이터를 가져온다:
 * 1. Google 뉴스 RSS(무료·키 불필요)에서 실시간 한국어 헤드라인을 수집하고,
 * 2. LLM(Replit AI Integrations 프록시)으로 종합 감성·요약·예상 영향을 분석한다.
 *
 * 가짜 fallback 은 두지 않는다 — 네트워크/파싱/LLM 어느 단계든 실패하면 throw 하여
 * 라우트가 명시적 오류(502)를 반환한다. 효과 수치(valueBefore/After)는 제품 기준선
 * + LLM 추정 영향(%p)으로, "실데이터 기반 추정"임을 분명히 한다.
 */
import { openai } from "@workspace/integrations-openai-ai-server";

export type IngestProduct = "Lumen" | "Seraph" | "Dynamo";

export type RssItem = { title: string; description: string; pubDate: string };

export type IngestResult = {
  itemCount: number;
  sentimentPos: number;
  sentimentNeu: number;
  sentimentNeg: number;
  summary: string;
  title: string;
  metric: string;
  valueBefore: number;
  valueAfter: number;
};

/** 제품별 지표 + 기준선(추정 영향의 출발점). */
const PRODUCT_METRIC: Record<
  IngestProduct,
  { metric: string; baseline: number }
> = {
  Dynamo: { metric: "지지율(%)", baseline: 42 },
  Lumen: { metric: "구매의향(%)", baseline: 40 },
  Seraph: { metric: "정책수용도(%)", baseline: 55 },
};

/**
 * 제품별 기본 실검색 주제(쿼리). count>1 자동 수집 시 로테이션해 서로 다른
 * 실뉴스를 가져온다. 실존 정당·인물명이 아닌 이슈 중심 키워드.
 */
const NEWS_TOPICS: { product: IngestProduct; query: string }[] = [
  { product: "Lumen", query: "소비 심리" },
  { product: "Seraph", query: "정부 정책" },
  { product: "Dynamo", query: "여론조사" },
  { product: "Lumen", query: "물가 장바구니" },
  { product: "Seraph", query: "복지 제도" },
  { product: "Dynamo", query: "정치 현안" },
  { product: "Lumen", query: "소비 트렌드" },
  { product: "Seraph", query: "공공요금" },
];

/** count 개의 (제품, 쿼리) 주제를 무작위 시작점에서 로테이션해 반환. */
export function pickNewsTopics(
  count: number,
): { product: IngestProduct; query: string }[] {
  const offset = Math.floor(Math.random() * NEWS_TOPICS.length);
  const out: { product: IngestProduct; query: string }[] = [];
  for (let i = 0; i < count; i++) {
    out.push(NEWS_TOPICS[(offset + i) % NEWS_TOPICS.length]!);
  }
  return out;
}

export function defaultQueryForProduct(product: IngestProduct): string {
  const topic = NEWS_TOPICS.find((t) => t.product === product);
  return topic ? topic.query : "뉴스";
}

const ENTITIES: Record<string, string> = {
  "&amp;": "&",
  "&lt;": "<",
  "&gt;": ">",
  "&quot;": '"',
  "&#39;": "'",
  "&apos;": "'",
  "&nbsp;": " ",
};

function decodeEntities(s: string): string {
  return s
    .replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1")
    .replace(/&#(\d+);/g, (_, d: string) => String.fromCharCode(Number(d)))
    .replace(/&[a-z#0-9]+;/gi, (m) => ENTITIES[m] ?? m)
    .trim();
}

function stripTags(s: string): string {
  return decodeEntities(s.replace(/<[^>]+>/g, " ")).replace(/\s+/g, " ").trim();
}

/** RSS XML 에서 item 들을 추출(정규식 기반, 외부 의존성 없음). */
function parseRssItems(xml: string, limit: number): RssItem[] {
  const items: RssItem[] = [];
  const itemRe = /<item\b[^>]*>([\s\S]*?)<\/item>/g;
  let m: RegExpExecArray | null;
  while ((m = itemRe.exec(xml)) !== null && items.length < limit) {
    const block = m[1] ?? "";
    const title = decodeEntities(
      /<title\b[^>]*>([\s\S]*?)<\/title>/.exec(block)?.[1] ?? "",
    );
    if (!title) continue;
    const description = stripTags(
      /<description\b[^>]*>([\s\S]*?)<\/description>/.exec(block)?.[1] ?? "",
    );
    const pubDate = decodeEntities(
      /<pubDate\b[^>]*>([\s\S]*?)<\/pubDate>/.exec(block)?.[1] ?? "",
    );
    items.push({ title, description, pubDate });
  }
  return items;
}

const RSS_TIMEOUT_MS = 12_000;

/**
 * Google 뉴스 RSS 에서 실시간 한국어 헤드라인을 가져온다. 실패/0건이면 throw.
 * (가짜 fallback 금지 — 호출부가 명시적 오류로 사용자에게 알린다.)
 */
export async function fetchNewsItems(
  query: string,
  limit = 12,
): Promise<RssItem[]> {
  const url = `https://news.google.com/rss/search?q=${encodeURIComponent(
    query,
  )}&hl=ko&gl=KR&ceid=KR:ko`;
  let res: Response;
  try {
    res = await fetch(url, {
      signal: AbortSignal.timeout(RSS_TIMEOUT_MS),
      headers: { "user-agent": "Mozilla/5.0 (compatible; DemosSignalBot/1.0)" },
    });
  } catch (e) {
    throw new Error(
      `뉴스 RSS 요청 실패: ${e instanceof Error ? e.message : String(e)}`,
    );
  }
  if (!res.ok) {
    throw new Error(`뉴스 RSS 응답 오류 (HTTP ${res.status})`);
  }
  const xml = await res.text();
  const items = parseRssItems(xml, limit);
  if (items.length === 0) {
    throw new Error(`'${query}' 검색 결과에서 뉴스 항목을 찾지 못했습니다.`);
  }
  return items;
}

function clampInt(v: unknown, lo: number, hi: number, fallback: number): number {
  const n = typeof v === "number" ? v : Number(v);
  if (Number.isNaN(n)) return fallback;
  return Math.max(lo, Math.min(hi, Math.round(n)));
}

function renorm(
  pos: number,
  neu: number,
  neg: number,
): { pos: number; neu: number; neg: number } {
  const p = Math.max(0, pos);
  const u = Math.max(0, neu);
  const g = Math.max(0, neg);
  const sum = p + u + g || 1;
  const rp = Math.round((p / sum) * 100);
  const rg = Math.round((g / sum) * 100);
  const ru = Math.max(0, 100 - rp - rg);
  return { pos: rp, neu: ru, neg: rg };
}

const ANALYSIS_TIMEOUT_MS = 45_000;

type Analysis = {
  sentimentPos: number;
  sentimentNeu: number;
  sentimentNeg: number;
  impact: number;
  summary: string;
  headline: string;
};

/**
 * 실제 헤드라인 목록을 LLM 으로 분석해 종합 감성·요약·예상 영향을 산출한다.
 * 결과는 합 100 으로 재정규화하고 impact 는 ±8%p 로 clamp. 실패 시 throw.
 */
export async function analyzeNewsSentiment(
  items: RssItem[],
  product: IngestProduct,
  model = "gpt-5-mini",
): Promise<Analysis> {
  const { metric } = PRODUCT_METRIC[product];
  const headlines = items
    .map((it, i) => `${i + 1}. ${it.title}`)
    .join("\n");
  const response = await openai.chat.completions.create(
    {
      model,
      max_completion_tokens: 4096,
      messages: [
        {
          role: "system",
          content:
            "당신은 한국 미디어 신호 분석 엔진입니다. 실제 뉴스 헤드라인 목록을 받아 " +
            "특정 제품 지표에 대한 종합 감성과 예상 영향을 분석하고, 반드시 유효한 JSON 객체 하나만 출력합니다. " +
            "실존 정당·정치인 개인에 대한 평가나 옹호는 피하고 이슈 중심으로 분석하세요.",
        },
        {
          role: "user",
          content:
            `대상 지표: ${metric} (제품: ${product})\n\n` +
            `다음은 방금 수집한 실제 뉴스 헤드라인입니다:\n${headlines}\n\n` +
            "이 헤드라인들의 종합 여론 감성과 위 지표에 대한 예상 영향을 분석해 아래 JSON 으로만 답하세요.\n" +
            "{\n" +
            '  "sentimentPos": 0~100 정수,\n' +
            '  "sentimentNeu": 0~100 정수,\n' +
            '  "sentimentNeg": 0~100 정수,  // 세 값 합이 대략 100\n' +
            '  "impact": -8~8 정수,  // 위 지표의 예상 변화(%p), 긍정 여론이면 +\n' +
            '  "summary": "2~3문장 한국어 요약(감성 근거 포함)",\n' +
            '  "headline": "12~28자 한국어 신호 제목"\n' +
            "}",
        },
      ],
      response_format: { type: "json_object" },
    },
    { timeout: ANALYSIS_TIMEOUT_MS, maxRetries: 1 },
  );
  const content = response.choices[0]?.message?.content ?? "";
  let parsed: Record<string, unknown>;
  try {
    parsed = JSON.parse(content) as Record<string, unknown>;
  } catch {
    throw new Error("LLM 감성 분석 응답을 해석하지 못했습니다(JSON 파싱 실패).");
  }
  const sent = renorm(
    clampInt(parsed.sentimentPos, 0, 100, 33),
    clampInt(parsed.sentimentNeu, 0, 100, 34),
    clampInt(parsed.sentimentNeg, 0, 100, 33),
  );
  const summary =
    typeof parsed.summary === "string" && parsed.summary.trim().length > 0
      ? parsed.summary.trim()
      : "";
  if (!summary) {
    throw new Error("LLM 감성 분석 요약이 비어 있습니다.");
  }
  const headline =
    typeof parsed.headline === "string" && parsed.headline.trim().length > 0
      ? parsed.headline.trim()
      : "";
  return {
    sentimentPos: sent.pos,
    sentimentNeu: sent.neu,
    sentimentNeg: sent.neg,
    impact: clampInt(parsed.impact, -8, 8, 0),
    summary,
    headline,
  };
}

function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v));
}

/**
 * 실시간 뉴스 1주제를 수집·분석해 신호 배치 1건의 효과값을 만든다.
 * `weight`(소스 가중치 0~2)는 추정 영향에 곱해진다. 어느 단계든 실패하면 throw.
 */
export async function ingestNewsSignal(
  query: string,
  product: IngestProduct,
  weight: number,
  model = "gpt-5-mini",
): Promise<IngestResult> {
  const items = await fetchNewsItems(query);
  const analysis = await analyzeNewsSentiment(items, product, model);
  const { metric, baseline } = PRODUCT_METRIC[product];
  const valueBefore = baseline;
  const valueAfter = clamp(
    Math.round((baseline + analysis.impact * clamp(weight, 0, 2)) * 10) / 10,
    0,
    100,
  );
  const title =
    analysis.headline.length > 0 ? analysis.headline : `${query} 관련 뉴스`;
  return {
    itemCount: items.length,
    sentimentPos: analysis.sentimentPos,
    sentimentNeu: analysis.sentimentNeu,
    sentimentNeg: analysis.sentimentNeg,
    summary: analysis.summary,
    title,
    metric,
    valueBefore,
    valueAfter,
  };
}
