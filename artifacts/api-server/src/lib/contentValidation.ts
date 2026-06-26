/**
 * 시뮬레이션 입력(제목·정책/메시지 원문)의 "의미성" 휴리스틱 검증.
 *
 * 목적: "slkdbnasd" 같은 무의미한 키보드 입력으로 시뮬레이션을 돌려 LLM 비용만
 * 낭비하고 결과가 무의미해지는 것을 막는다. 완벽한 자연어 판별은 불가능하므로
 * 명백한 쓰레기 입력(공백/기호만, 한 글자 반복, 모음 없는 자음 덩어리)을 거른다.
 *
 * ⚠️ 이 파일은 프런트(`artifacts/demos/src/lib/contentValidation.ts`)와 의도적으로
 * 동일하게 복제돼 있다(별도 lib 스캐폴딩 회피). 한쪽을 고치면 반드시 다른 쪽도 같이 고친다.
 */

// 한글(자모/완성형) · CJK 한자 · 일본어 가나.
const CJK_RE = /[\u3131-\uD79D\u4E00-\u9FFF\u3040-\u30FF]/u;

/**
 * 텍스트가 "의미 있는 내용"으로 보이는지 검사한다(true=통과).
 * 길이 검증은 호출부(zod min)에서 별도로 한다 — 여기선 의미성만 본다.
 */
export function hasMeaningfulContent(raw: string): boolean {
  const text = (raw ?? "").trim();
  if (text.length === 0) return false;

  // 1) 문자/숫자(유니코드 letter/number)가 최소 2자 이상 — 기호·공백만이면 탈락.
  const wordChars = text.replace(/[^\p{L}\p{N}]/gu, "");
  if (wordChars.length < 2) return false;

  // 2) 한 글자(또는 두 글자)만 반복하는 입력 거부(예: "aaaaaa", "ㅋㅋㅋㅋㅋㅋ").
  const compact = text.replace(/\s/g, "");
  const uniqueChars = new Set(compact).size;
  if (compact.length >= 6 && uniqueChars <= 2) return false;

  // 3) 한글/CJK 가 있으면 의미 있는 것으로 간주(단어 구분 공백 요구 없음).
  if (CJK_RE.test(text)) return true;

  // 4) 라틴 경로: 여러 단어면 통과.
  const tokens = text.split(/\s+/).filter(Boolean);
  if (tokens.length >= 2) return true;

  // 5) 단일 라틴 토큰: 모음 비율이 너무 낮으면(자음 덩어리) 무의미로 판단.
  const letters = text.replace(/[^a-zA-Z]/g, "");
  if (letters.length >= 4) {
    const vowels = (letters.match(/[aeiouAEIOU]/g) ?? []).length;
    if (vowels / letters.length < 0.2) return false;
  }
  return true;
}

/** 제목용 가벼운 검증 — 공백/기호만이거나 한 글자 반복이면 탈락. */
export function isMeaningfulTitle(raw: string): boolean {
  const text = (raw ?? "").trim();
  if (text.length < 2) return false;
  const wordChars = text.replace(/[^\p{L}\p{N}]/gu, "");
  if (wordChars.length < 2) return false;
  const compact = text.replace(/\s/g, "");
  if (compact.length >= 6 && new Set(compact).size <= 2) return false;
  return true;
}

export const POLICY_TEXT_ERROR =
  "정책/메시지 원문을 의미 있는 문장으로 작성해주세요. (무작위 문자·반복 입력은 시뮬레이션할 수 없습니다)";
export const TITLE_ERROR = "시뮬레이션 제목을 의미 있게 입력해주세요.";
