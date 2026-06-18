---
name: Session auth (custom express-session)
description: Why DEMOS uses custom session auth instead of managed auth, and the key constraints
---

# Custom session auth in DEMOS

DEMOS uses **custom session auth** (express-session + connect-pg-simple Postgres store + bcryptjs), NOT Clerk/Replit Auth.

**Why:** managed auth providers reject the weak seeded demo passwords and don't fit the custom signup fields (이름/아이디/생년월일/비밀번호, username→email later). The product is a no-account demo whose commercialization step 1 is auth.

## connect-pg-simple + esbuild bundling constraint
Do NOT use `createTableIfMissing: true`. connect-pg-simple reads a `table.sql` file relative to the bundle dir at runtime; the esbuild-bundled api-server has no such file, so sessions silently never persist (login returns 200 + Set-Cookie, but the next request is 401).

**How to apply:** keep `createTableIfMissing: false` and provision the `session` table out-of-band via raw SQL (standard connect-pg-simple schema). It is intentionally NOT a Drizzle schema, so it won't appear in `lib/db/src/schema`.

## Route gating + session hygiene
- `routes/index.ts` order matters: health + auth routers (public) FIRST, then `requireAuth`, then data routers, then `requireAdmin` + admin router. Any new public route must be registered before the `requireAuth` line.
- Login/signup call `req.session.regenerate()` before setting `userId` to defend against session fixation.
