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
  /** 선거관리위원회 선거종류 코드: 1=대통령, 3=시·도지사(광역단체장), 7=비례대표국회의원. */
  sgTypecode: string;
  /**
   * 이 선거에서 "보수 진영"으로 매핑할 정당명. 대선·지방선거는 국민의힘 계열 후보의
   * 소속 정당, 비례대표는 보수 위성정당명을 쓴다(선거마다 다르므로 선거별로 지정).
   */
  conservativeParty: string;
};

/**
 * 연동 지원 선거. 모든 선거는 data.go.kr 개표 API에서 동일한 후보/정당별(jd/hbj/dugsu/yutusu)
 * 구조로 내려오며, 시·도별 합계 행에서 보수 진영(conservativeParty) 득표율을 계산한다.
 *
 * - 대통령선거(sgTypecode=1): 보수=국민의힘 단일 후보.
 * - 지방선거 광역단체장(sgTypecode=3): 시·도지사 보수 후보 소속 정당.
 * - 국회의원선거 비례대표(sgTypecode=7): 보수 위성정당(선거별 상이). 정당 투표라 hbj=정당명.
 *
 * 보수 진영 정당명은 선거마다 다르므로(국민의힘/자유한국당, 국민의미래/미래한국당) 선거별로
 * 지정한다. 종류별로 묶고 각 그룹은 최신이 먼저 오도록 정렬한다(화면 기본 선택).
 */
export const SUPPORTED_ELECTIONS: ElectionSource[] = [
  {
    sgId: "20250603",
    name: "제21대 대통령선거",
    electionType: "대통령선거",
    electionDate: "2025-06-03",
    sgTypecode: "1",
    conservativeParty: "국민의힘",
  },
  {
    sgId: "20220309",
    name: "제20대 대통령선거",
    electionType: "대통령선거",
    electionDate: "2022-03-09",
    sgTypecode: "1",
    conservativeParty: "국민의힘",
  },
  {
    sgId: "20220601",
    name: "제8회 전국동시지방선거 (광역단체장)",
    electionType: "지방선거",
    electionDate: "2022-06-01",
    sgTypecode: "3",
    conservativeParty: "국민의힘",
  },
  // 제7회(2018) 지방선거는 자유한국당이 광주·전남 등에 광역단체장 후보를 내지 않아
  // 17개 시·도 보수 ground-truth를 완성할 수 없으므로 자동 연동 대상에서 제외한다.
  {
    sgId: "20240410",
    name: "제22대 국회의원선거 (비례대표)",
    electionType: "국회의원선거",
    electionDate: "2024-04-10",
    sgTypecode: "7",
    conservativeParty: "국민의미래",
  },
  {
    sgId: "20200415",
    name: "제21대 국회의원선거 (비례대표)",
    electionType: "국회의원선거",
    electionDate: "2020-04-15",
    sgTypecode: "7",
    conservativeParty: "미래한국당",
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

async function fetchAllRows(
  sgId: string,
  sgTypecode: string,
): Promise<RawRow[]> {
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
    url.searchParams.set("sgTypecode", sgTypecode);

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
  /** 실제 1위 진영: 보수 후보 득표수가 전 후보 중 최다면 conservative, 아니면 progressive. */
  actualWinner: "conservative" | "progressive";
};

/**
 * 지정한 선거(sgId)의 시·도별 보수 진영(source.conservativeParty) 득표율(%)을 실제
 * 개표결과에서 계산해 반환한다. 대통령선거·지방선거 광역단체장은 후보 단위, 비례대표
 * 국회의원선거는 정당 단위지만 API 응답 구조(jd=정당명, hbj=후보/정당명, dugsu=득표수,
 * yutusu=유효투표수)가 동일하므로 같은 로직으로 처리한다. 매핑 가능한 시·도만 포함하며,
 * 하나도 추출하지 못하면 오류를 던진다.
 */
export async function fetchConservativeShares(
  sgId: string,
): Promise<ImportedRegionResult[]> {
  const source = findElectionSource(sgId);
  if (!source) {
    throw new DataGoKrError("지원하지 않는 선거입니다.");
  }
  const rows = await fetchAllRows(sgId, source.sgTypecode);
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
      if (r[`jd${pad}`] === source.conservativeParty) {
        idx = pad;
        break;
      }
    }
    if (!idx) continue;

    const validVotes = Number(r.yutusu);
    const candidateVotes = Number(r[`dugsu${idx}`]);
    if (!validVotes || !Number.isFinite(candidateVotes)) continue;

    // 진영 판정은 득표율 임계값이 아니라 실제 1위 후보를 기준으로 한다 — 전 후보의
    // 득표수를 비교해 보수 후보가 최다면 conservative, 아니면 progressive.
    let maxVotes = 0;
    for (let i = 1; i <= 50; i++) {
      const pad = String(i).padStart(2, "0");
      const v = Number(r[`dugsu${pad}`]);
      if (Number.isFinite(v) && v > maxVotes) maxVotes = v;
    }

    out.push({
      regionCode,
      sidoName: r.sdName,
      candidate: r[`hbj${idx}`] ?? "",
      actualValue: Number(((candidateVotes / validVotes) * 100).toFixed(2)),
      actualWinner: candidateVotes >= maxVotes ? "conservative" : "progressive",
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
