---
name: data.go.kr NEC election import
description: How real Korean presidential election results are pulled from data.go.kr to fill the elections ground-truth.
---

# data.go.kr 선거 개표 연동

Real NEC (중앙선거관리위원회) presidential results feed the `elections` ground-truth used by
election calibration, replacing the hardcoded seed.

- Endpoint: `VoteXmntckInfoInqireService2/getXmntckSttusInfoInqire`, params: serviceKey (raw,
  URL-encoded by URLSearchParams), resultType=json, sgId, sgTypecode=1 (대선), pageNo.
- **numOfRows is capped at 100 by the API** regardless of requested value → must paginate on
  `totalCount` (~270 rows per 대선).
- 시·도 합계행 = `wiwName === "합계"` && sdName ∉ {합계, 전국}. Conservative share =
  `dugsuNN / yutusu * 100` where `jdNN === "국민의힘"`.
- 21대(20250603, 김문수) and 20대(20220309, 윤석열) are both supported (보수=국민의힘 for both).
  데모는 두 대선을 백테스트로 함께 제공. 더 이전 대선은 국민의힘 명칭 이전이라 단일 규칙이 깨짐.
- **진영 배지는 actualWinner(실제 1위 진영) 기준** — 득표율 임계값(>50%) 금지. 강원·울산은 보수
  후보가 <50%로 1위였기에 임계값 방식이면 오판함. import 경로는 전 후보 dugsuNN 최대 득표수와
  비교해 winner를 판정하고, elections.actual_winner(NOT NULL) 컬럼에 저장한다.

**Import replaces ONLY the selected election (per-electionDate), not the whole table.** Import
deletes rows matching the chosen `electionDate` then inserts the fetched rows in one transaction —
so importing 20대 never touches 21대 rows. A completeness guard requires all 17 시·도 codes before
replacing, to avoid clobbering good data with a partial fetch. No global `ALTER SEQUENCE` reset.
Calibration result is grouped per election (`ElectionCalibrationGroup[]`, electionDate desc); the
frontend ElectionCalibrationView is a selector over `data.elections` (no longer single-election).

**Note:** 세종시(36) is in elections but usually absent from calibration rows because the
synthetic population generates no 세종 agents — pre-existing, not a regression.
