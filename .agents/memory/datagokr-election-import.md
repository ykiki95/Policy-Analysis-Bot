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
- Only 20대(20220309, 윤석열) and 21대(20250603, 김문수) are supported — both have 보수=국민의힘.
  Earlier elections used different party names, so the single-rule mapping would break.

**Why import REPLACES the whole elections table:** the frontend ElectionCalibrationView is
single-election (reads `rows[0]` for the header), so importing a new election deletes + reseeds
all rows in one transaction. A completeness guard requires all 17 시·도 codes before replacing,
to avoid clobbering good data with a partial fetch.

**Note:** 세종시(36) is in elections but usually absent from calibration rows because the
synthetic population generates no 세종 agents — pre-existing, not a regression.
