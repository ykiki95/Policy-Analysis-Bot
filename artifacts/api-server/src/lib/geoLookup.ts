import { db, ipGeoTable } from "@workspace/db";
import { inArray } from "drizzle-orm";
import { logger } from "./logger";

/**
 * IP → 위치 조회(ip-api.com 무료 배치 API).
 * - 무료 티어: HTTP 전용, 분당 15요청, 요청당 최대 100 IP.
 * - 사설/로컬 IP 는 외부 호출 없이 status='private' 로 캐시.
 * - 조회 결과는 ip_geo 테이블에 캐시해 재호출을 피한다.
 */

const BATCH_URL = "http://ip-api.com/batch";
const BATCH_FIELDS =
  "status,message,country,countryCode,regionName,city,lat,lon,isp,query";
const MAX_PER_BATCH = 100;
/** 한 번의 분석 요청에서 새로 해결할 IP 상한(분당 한도 보호). */
const MAX_NEW_IPS_PER_CALL = 100;

function isPrivateIp(ip: string): boolean {
  if (ip === "127.0.0.1" || ip === "::1" || ip === "localhost") return true;
  if (/^10\./.test(ip)) return true;
  if (/^192\.168\./.test(ip)) return true;
  if (/^172\.(1[6-9]|2[0-9]|3[0-1])\./.test(ip)) return true;
  if (/^169\.254\./.test(ip)) return true;
  if (/^(fc|fd)/i.test(ip)) return true; // IPv6 ULA
  if (/^fe80:/i.test(ip)) return true; // IPv6 link-local
  return false;
}

interface IpApiResult {
  status: string;
  message?: string;
  country?: string;
  countryCode?: string;
  regionName?: string;
  city?: string;
  lat?: number;
  lon?: number;
  isp?: string;
  query: string;
}

async function fetchBatch(ips: string[]): Promise<IpApiResult[]> {
  const url = `${BATCH_URL}?fields=${encodeURIComponent(BATCH_FIELDS)}`;
  const res = await fetch(url, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(ips),
    signal: AbortSignal.timeout(8000),
  });
  if (!res.ok) {
    throw new Error(`ip-api batch ${res.status}`);
  }
  return (await res.json()) as IpApiResult[];
}

/**
 * 주어진 IP 목록 중 캐시에 없는 것만 골라 외부 조회 후 ip_geo 에 저장한다.
 * 외부 호출 실패는 조용히 무시(분석은 위치 없이라도 동작).
 */
export async function ensureGeoForIps(ips: string[]): Promise<void> {
  const unique = Array.from(
    new Set(ips.filter((ip): ip is string => Boolean(ip))),
  );
  if (unique.length === 0) return;

  const cached = await db
    .select({ ip: ipGeoTable.ip })
    .from(ipGeoTable)
    .where(inArray(ipGeoTable.ip, unique));
  const cachedSet = new Set(cached.map((r) => r.ip));

  const missing = unique.filter((ip) => !cachedSet.has(ip));
  if (missing.length === 0) return;

  // 사설 IP 는 외부 호출 없이 표시.
  const privateIps = missing.filter(isPrivateIp);
  const publicIps = missing.filter((ip) => !isPrivateIp(ip));

  if (privateIps.length > 0) {
    await db
      .insert(ipGeoTable)
      .values(
        privateIps.map((ip) => ({ ip, status: "private", country: "(로컬/사설)" })),
      )
      .onConflictDoNothing();
  }

  const toResolve = publicIps.slice(0, MAX_NEW_IPS_PER_CALL);
  for (let i = 0; i < toResolve.length; i += MAX_PER_BATCH) {
    const chunk = toResolve.slice(i, i + MAX_PER_BATCH);
    try {
      const results = await fetchBatch(chunk);
      const rows = results.map((r) => ({
        ip: r.query,
        status: r.status === "success" ? "success" : "fail",
        country: r.country ?? null,
        countryCode: r.countryCode ?? null,
        region: r.regionName ?? null,
        city: r.city ?? null,
        lat: r.lat ?? null,
        lon: r.lon ?? null,
        isp: r.isp ?? null,
      }));
      if (rows.length > 0) {
        await db.insert(ipGeoTable).values(rows).onConflictDoNothing();
      }
    } catch (err) {
      logger.warn({ err }, "ip-api 위치 조회 실패(스킵)");
    }
  }
}
