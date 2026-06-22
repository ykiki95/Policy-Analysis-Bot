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
- Only 21대(20250603, 김문수) is supported (보수=국민의힘). 데모는 제21대 대선으로 통일했고
  20대 흔적은 제거됨. Earlier elections used different party names, so the single-rule mapping breaks.
- **진영 배지는 actualWinner(실제 1위 진영) 기준** — 득표율 임계값(>50%) 금지. 강원·울산은 보수
  후보가 <50%로 1위였기에 임계값 방식이면 오판함. import 경로는 전 후보 dugsuNN 최대 득표수와
  비교해 winner를 판정하고, elections.actual_winner(NOT NULL) 컬럼에 저장한다.

**Why import REPLACES the whole elections table:** the frontend ElectionCalibrationView is
single-election (reads `rows[0]` for the header), so importing a new election deletes + reseeds
all rows in one transaction. A completeness guard requires all 17 시·도 codes before replacing,
to avoid clobbering good data with a partial fetch.

**Note:** 세종시(36) is in elections but usually absent from calibration rows because the
synthetic population generates no 세종 agents — pre-existing, not a regression.
