/**
 * 경량 접속 분석 비콘. react-query 와 별개로 동작한다(heartbeat·pagehide 가
 * 컴포넌트 수명과 무관하게 떠야 하므로 plain fetch/sendBeacon 사용).
 *
 * - clientId: 브라우저(기기) 식별, localStorage 영속 → 방문자 수 집계.
 * - sessionId: 탭 세션 식별, sessionStorage(탭 닫으면 소멸) → 세션·체류시간 집계.
 * - pageview: 경로 변경 시 1회.
 * - heartbeat: 탭이 보일 때 HEARTBEAT_SECONDS 마다(체류시간 측정).
 * - pagehide: 비콘으로 마지막 heartbeat 전송(체류시간 정확도 보강).
 */

const TRACK_URL = `${import.meta.env.BASE_URL.replace(/\/$/, "")}/api/track`;
const CLIENT_KEY = "demos.analytics.clientId";
const SESSION_KEY = "demos.analytics.sessionId";

/** 서버 lib/analytics.ts HEARTBEAT_SECONDS 와 반드시 동일. */
export const HEARTBEAT_SECONDS = 20;

function randomId(): string {
  if (typeof crypto !== "undefined" && "randomUUID" in crypto) {
    return crypto.randomUUID();
  }
  return `${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 10)}`;
}

function getClientId(): string {
  try {
    let id = localStorage.getItem(CLIENT_KEY);
    if (!id) {
      id = randomId();
      localStorage.setItem(CLIENT_KEY, id);
    }
    return id;
  } catch {
    return "anon";
  }
}

function getSessionId(): string {
  try {
    let id = sessionStorage.getItem(SESSION_KEY);
    if (!id) {
      id = randomId();
      sessionStorage.setItem(SESSION_KEY, id);
    }
    return id;
  } catch {
    return "anon-session";
  }
}

type TrackType = "pageview" | "heartbeat";

function send(path: string, type: TrackType, useBeacon = false): void {
  const payload = JSON.stringify({
    clientId: getClientId(),
    sessionId: getSessionId(),
    path: path.slice(0, 300),
    type,
  });
  try {
    if (useBeacon && typeof navigator !== "undefined" && navigator.sendBeacon) {
      const blob = new Blob([payload], { type: "application/json" });
      navigator.sendBeacon(TRACK_URL, blob);
      return;
    }
    void fetch(TRACK_URL, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: payload,
      credentials: "include",
      keepalive: true,
    }).catch(() => {});
  } catch {
    // 분석 비콘 실패는 무시.
  }
}

let started = false;
let heartbeatTimer: ReturnType<typeof setInterval> | null = null;
let currentPath = "";

/** 경로 변경 시 호출 — pageview 기록 + 현재 경로 갱신. */
export function trackPageview(path: string): void {
  currentPath = path;
  send(path, "pageview");
}

/**
 * 전역 추적기를 1회 기동한다(heartbeat 인터벌 + pagehide/visibility 리스너).
 * App 마운트 시 호출. 중복 호출은 무시.
 */
export function startTracking(initialPath: string): void {
  if (started) return;
  started = true;
  currentPath = initialPath;

  const beat = (): void => {
    if (typeof document !== "undefined" && document.visibilityState === "visible") {
      send(currentPath, "heartbeat");
    }
  };
  heartbeatTimer = setInterval(beat, HEARTBEAT_SECONDS * 1000);

  if (typeof document !== "undefined") {
    document.addEventListener("visibilitychange", () => {
      // 다시 보이게 되면 즉시 heartbeat 1회(체류 연속성).
      if (document.visibilityState === "visible") send(currentPath, "heartbeat");
    });
  }
  if (typeof window !== "undefined") {
    window.addEventListener("pagehide", () => {
      send(currentPath, "heartbeat", true);
    });
  }
}

/** 테스트/정리용. 보통 호출할 필요 없음. */
export function stopTracking(): void {
  if (heartbeatTimer) clearInterval(heartbeatTimer);
  heartbeatTimer = null;
  started = false;
}
