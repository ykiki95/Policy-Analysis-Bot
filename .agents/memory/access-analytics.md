---
name: Access analytics (접속 분석)
description: Design constraints for the admin access-analytics feature — public beacon endpoint, IP/geo, session dwell-time.
---

# 접속 분석 (admin access analytics)

Admin-only feature aggregating visit data for the externally-exposed service, including anonymous (logged-out) visits.

## Durable decisions / constraints

- **Public `/track` is a logged-out write endpoint** → mounted BEFORE requireAuth, and MUST stay rate-limited (`trackLimiter`, per-IP). Without the limiter any script can pollute metrics (menu usage, dwell-time, visitor counts) and amplify DB writes. Any new public/anonymous write endpoint needs the same treatment.
- **Beacon = pageview + 20s heartbeat + pagehide sendBeacon.** Dwell-time is derived from event timestamps within a session; login events are excluded from the session-duration aggregation so auth pings don't inflate dwell time.
- **ip-api.com free tier is HTTP only** — visitor IPs are sent in cleartext. Accepted as a demo limitation. Geo is resolved lazily: only unresolved IPs are batched at admin view time, then cached in `ip_geo`; private IPs are skipped.
- **IP trust**: `getClientIp` = cf-connecting-ip > x-forwarded-for > req.ip. Trustworthy because external traffic goes through a Cloudflare Worker (cf-connecting-ip is real there); direct Replit-URL hits can still spoof headers — acceptable for the demo.
- Tables created via raw DDL on **both** dev and prod (drizzle push is blocked in the non-TTY shell), same as other tables in this project.

**Why:** code review flagged the public endpoint as the top risk (data pollution + write amplification). The rate limiter is the must-keep mitigation; the HTTP geo + header-trust are knowingly-accepted demo tradeoffs documented so a future agent doesn't "rediscover" them as bugs.
