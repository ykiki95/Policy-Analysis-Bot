/**
 * 중앙선거관리위원회 투·개표 정보 Open API (공공데이터포털, data.go.kr) 연동.
 *
 * 실제 과거 대통령선거의 시·도별 개표결과를 가져와, 보수(국민의힘) 후보의 시·도별
 * 득표율을 계산한다. 이 값은 `elections` 테이블의 ground-truth(actualValue)로 저장돼
 * 선거 검증(electionCalibration)에서 합성 인구 예측과 비교된다.
 *
 * 인증키는 환경변수 `DATA_GO_KR_API_KEY`(URL 인코딩 전 raw 키)에서 읽으며, 절대 응답·로그에
 * 노출하지 않는다. API는 numOfRows를 100으로 캡하므로 totalCount 기준으로 페이지네이션한다.
 */
const SERVICE_BASE =
  "http://apis.data.go.kr/9760000/VoteXmntckInfoInqireService2";
const OPERATION = "getXmntckSttusInfoInqire";
const CONSERVATIVE_PARTY = "국민의힘";
const PAGE_SIZE = 100;

/** 연동 과정에서 사용자에게 보여줄 수 있는, 의미가 명확한 오류. */
export class DataGoKrError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "DataGoKrError";
  }
}

export type ElectionSource = {
  sgId: string;
  name: string;
  electionType: string;
  electionDate: string;
};

/**
 * 연동 지원 선거. 대통령선거만 지원한다 — 보수 진영을 "국민의힘 후보" 단일 규칙으로
 * 매핑할 수 있는 20·21대만 포함(그 이전은 당명이 달라 제외).
 */
export const SUPPORTED_ELECTIONS: ElectionSource[] = [
  {
    sgId: "20250603",
    name: "제21대 대통령선거",
    electionType: "대통령선거",
    electionDate: "2025-06-03",
  },
  {
    sgId: "20220309",
    name: "제20대 대통령선거",
    electionType: "대통령선거",
    electionDate: "2022-03-09",
  },
];

export function findElectionSource(sgId: string): ElectionSource | undefined {
  return SUPPORTED_ELECTIONS.find((e) => e.sgId === sgId);
}

/**
 * API가 돌려주는 시·도명 → regions.code 매핑. 명칭 변경(강원도→강원특별자치도,
 * 전라북도→전북특별자치도)을 모두 같은 코드로 흡수한다. 매핑에 없는 sdName(예: 재외/국외)은
 * 건너뛴다.
 */
const SIDO_TO_REGION_CODE: Record<string, string> = {
  서울특별시: "11",
  부산광역시: "26",
  대구광역시: "27",
  인천광역시: "28",
  광주광역시: "29",
  대전광역시: "30",
  울산광역시: "31",
  세종특별자치시: "36",
  경기도: "41",
  충청북도: "43",
  충청남도: "44",
  전라남도: "46",
  경상북도: "47",
  경상남도: "48",
  제주특별자치도: "50",
  강원도: "51",
  강원특별자치도: "51",
  전라북도: "52",
  전북특별자치도: "52",
};

/** 정상적인 대선 개표결과라면 반드시 채워져야 하는 17개 시·도 코드. */
const EXPECTED_REGION_CODES = [
  "11", "26", "27", "28", "29", "30", "31", "36", "41",
  "43", "44", "46", "47", "48", "50", "51", "52",
];

type RawRow = Record<string, string>;

async function fetchAllRows(sgId: string): Promise<RawRow[]> {
  const key = process.env.DATA_GO_KR_API_KEY;
  if (!key) {
    throw new DataGoKrError(
      "DATA_GO_KR_API_KEY 환경변수가 설정되어 있지 않습니다.",
    );
  }

  const rows: RawRow[] = [];
  let pageNo = 1;
  // totalCount(약 270) 대비 안전 상한.
  for (let guard = 0; guard < 30; guard++) {
    const url = new URL(`${SERVICE_BASE}/${OPERATION}`);
    url.searchParams.set("serviceKey", key);
    url.searchParams.set("resultType", "json");
    url.searchParams.set("numOfRows", String(PAGE_SIZE));
    url.searchParams.set("pageNo", String(pageNo));
    url.searchParams.set("sgId", sgId);
    url.searchParams.set("sgTypecode", "1");

    const res = await fetch(url);
    if (!res.ok) {
      throw new DataGoKrError(
        `공공데이터포털 응답 오류 (HTTP ${res.status}). 활용신청 승인 및 전파 상태를 확인해 주세요.`,
      );
    }
    const text = await res.text();
    let data: unknown;
    try {
      data = JSON.parse(text);
    } catch {
      throw new DataGoKrError(
        "공공데이터포털에서 예상치 못한 응답 형식이 반환되었습니다. 활용신청 승인 상태를 확인해 주세요.",
      );
    }

    const response = (data as { response?: Record<string, unknown> }).response;
    const header = response?.header as
      | { resultCode?: string; resultMsg?: string }
      | undefined;
    if (header?.resultCode && header.resultCode !== "INFO-00") {
      throw new DataGoKrError(
        `공공데이터포털 오류: ${header.resultMsg ?? header.resultCode}`,
      );
    }

    const body = response?.body as
      | {
          items?: { item?: RawRow | RawRow[] };
          totalCount?: number | string;
        }
      | undefined;
    const item = body?.items?.item;
    if (!item) break;
    const pageRows = Array.isArray(item) ? item : [item];
    rows.push(...pageRows);

    const total = Number(body?.totalCount ?? rows.length);
    if (rows.length >= total || pageRows.length < PAGE_SIZE) break;
    pageNo++;
  }

  return rows;
}

export type ImportedRegionResult = {
  regionCode: string;
  sidoName: string;
  candidate: string;
  actualValue: number;
};

/**
 * 지정한 대통령선거의 시·도별 보수(국민의힘) 후보 득표율(%)을 실제 개표결과에서 계산해
 * 반환한다. 매핑 가능한 시·도만 포함하며, 하나도 추출하지 못하면 오류를 던진다.
 */
export async function fetchPresidentialConservativeShares(
  sgId: string,
): Promise<ImportedRegionResult[]> {
  const rows = await fetchAllRows(sgId);
  const sidoTotals = rows.filter(
    (r) =>
      r.wiwName === "합계" &&
      r.sdName !== "합계" &&
      r.sdName !== "전국",
  );

  const out: ImportedRegionResult[] = [];
  for (const r of sidoTotals) {
    const regionCode = SIDO_TO_REGION_CODE[r.sdName];
    if (!regionCode) continue;

    let idx: string | null = null;
    for (let i = 1; i <= 50; i++) {
      const pad = String(i).padStart(2, "0");
      if (r[`jd${pad}`] === CONSERVATIVE_PARTY) {
        idx = pad;
        break;
      }
    }
    if (!idx) continue;

    const validVotes = Number(r.yutusu);
    const candidateVotes = Number(r[`dugsu${idx}`]);
    if (!validVotes || !Number.isFinite(candidateVotes)) continue;

    out.push({
      regionCode,
      sidoName: r.sdName,
      candidate: r[`hbj${idx}`] ?? "",
      actualValue: Number(((candidateVotes / validVotes) * 100).toFixed(2)),
    });
  }

  if (out.length === 0) {
    throw new DataGoKrError(
      "개표결과에서 시·도별 보수 후보 득표율을 추출하지 못했습니다.",
    );
  }

  // 기존 ground-truth를 부분 데이터로 교체하지 않도록, 17개 시·도가 모두
  // 채워졌는지 확인한다.
  const seen = new Set(out.map((r) => r.regionCode));
  const missing = EXPECTED_REGION_CODES.filter((c) => !seen.has(c));
  if (missing.length > 0) {
    throw new DataGoKrError(
      `개표결과가 불완전합니다. 누락된 시·도 코드: ${missing.join(", ")}`,
    );
  }
  return out;
}
