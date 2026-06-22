---
name: data.go.kr NEC election import
description: How real Korean election results (presidential / local / proportional) are pulled from data.go.kr to fill the elections ground-truth.
---

# data.go.kr 선거 개표 연동

Real NEC (중앙선거관리위원회) results feed the `elections` ground-truth used by election
calibration, replacing the hardcoded seed. Supports 3 election types — all share the SAME response
shape (jd/hbj/dugsu/yutusu), so one generic fetcher (`fetchConservativeShares(sgId)`) handles all,
parameterized per-election by `sgTypecode` + `conservativeParty`.

- Endpoint: `VoteXmntckInfoInqireService2/getXmntckSttusInfoInqire`, params: serviceKey (raw,
  URL-encoded by URLSearchParams), resultType=json, sgId, sgTypecode, pageNo.
- **sgTypecode**: 1=대통령, 3=시·도지사(광역단체장), 7=비례대표국회의원. (tc2=지역구 국회의원은
  소선거구 단위라 시·도별 단일 보수 득표율이 안 나와 미사용.)
- **numOfRows is capped at 100 by the API** regardless of requested value → must paginate on
  `totalCount` (~270 rows for 대선/비례, ~284 for 지방).
- 시·도 합계행 = `wiwName === "합계"` && sdName ∉ {합계, 전국}. Conservative share =
  `dugsuNN / yutusu * 100` where `jdNN === source.conservativeParty`.
- **conservativeParty varies per election** (위성정당/명칭 변경): 대선·지방=국민의힘, 비례 22대=
  국민의미래, 비례 21대=미래한국당. 그래서 ElectionSource에 선거별로 박아둔다(모듈 상수 금지).
- **선거별 ground-truth 완전성(17 시·도)이 자동 연동 가능 여부를 결정한다.** 제7회(2018) 지방선거는
  자유한국당이 광주·전남에 광역단체장 후보를 안 내 17개를 못 채워 SUPPORTED_ELECTIONS에서 제외.
  완전성 미달이면 import가 명시적 오류로 거부 → 부분 데이터로 교체 안 함.
- **metric 라벨은 시·도 전역에서 참인 값(=conservativeParty)으로만 만든다.** 지방선거 광역단체장은
  시·도마다 후보가 달라 특정 후보명(예: 오세훈)을 17개 지역에 공통 저장하면 안 됨. 비례=「보수
  정당(party)」, 대선·지방=「보수 후보(party)」. (응답의 candidate 필드는 안내용 대표값일 뿐.)
- **진영 배지는 actualWinner(실제 1위 진영) 기준** — 득표율 임계값(>50%) 금지. 강원·울산은 보수
  후보가 <50%로 1위였기에 임계값 방식이면 오판함. import 경로는 전 후보 dugsuNN 최대 득표수와
  비교해 winner를 판정하고, elections.actual_winner(NOT NULL) 컬럼에 저장한다. (비례는 진보표가
  더불어민주연합+조국혁신당으로 갈려, "보수 정당이 단일 최다였는가"로 winner 판정됨 — 의도된 규약.)

**Import replaces ONLY the selected election (per-electionDate), not the whole table.** Import
deletes rows matching the chosen `electionDate` then inserts the fetched rows in one transaction —
so importing 20대 never touches 21대 rows. A completeness guard requires all 17 시·도 codes before
replacing, to avoid clobbering good data with a partial fetch. No global `ALTER SEQUENCE` reset.
Calibration result is grouped per election (`ElectionCalibrationGroup[]`, electionDate desc); the
frontend ElectionCalibrationView is a selector over `data.elections` (no longer single-election).

**Note:** 세종시(36) is in elections but usually absent from calibration rows because the
synthetic population generates no 세종 agents — pre-existing, not a regression.
