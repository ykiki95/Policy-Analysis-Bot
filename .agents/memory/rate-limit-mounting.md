---
name: Rate limiter mounting pitfall
description: Why an auth rate limiter accidentally throttled all /api traffic (429) and the correct scoping rule.
---

# Rate limiter must be scoped per-route, not mounted path-less alongside a subrouter

`router.use(limiter, subRouter)` with NO path argument mounts BOTH at `/` — so the
limiter runs on EVERY request that flows through the parent router, not just the
subrouter's routes. An auth limiter (short window, low max) mounted this way counts
all `/api/*` traffic.

**Why this bit us:** the B1 client-driven deployment polls `GET /simulations/:id`
every 1s and POSTs `/simulations/:id/tick` every 1.5s while a sim runs. That burns
through a 30-req / 15-min auth budget in seconds → every route (including
`/auth/login`, `/auth/me`) returns 429. Symptoms looked unrelated: simulations stuck
at 0%, "auto-logout" (`/auth/me` 429 → client thinks logged out), and login showing
"잘못된 비밀번호" (login.tsx renders the same credential-error string for ANY failure,
incl. 429).

**How to apply:**
- Apply brute-force limiters directly on the sensitive handlers only
  (`router.post("/auth/login", authLimiter, ...)`, same for signup) — never on a
  hot polling path (`/me`, GET detail, `/tick`).
- If a limiter must wrap a subrouter, give it an explicit path: `router.use("/auth", limiter)`.
- Client error handlers should branch on `err.status` (the generated `ApiError` in
  `custom-fetch.ts` exposes `.status`) so a 429 doesn't masquerade as a 401.
