---
name: Orval enum+nullable drops null
description: Why constraining a nullable OpenAPI string field with enum breaks the generated TS client's ability to send null.
---

# Orval enum + nullable drops the null type

When an OpenAPI property is both `nullable: true` AND has an `enum`, Orval's generated
request-body TypeScript type becomes `XxxEnum | undefined` — the `null` member is lost.

**Why it matters:** any frontend that needs to send `null` to *clear* the field (e.g. reset
an avatar/selection back to default) will fail typecheck (`Type 'string | null' is not
assignable to 'XxxEnum | undefined'`).

**How to apply:** if a nullable field must accept `null` over the wire, keep it as a plain
`{ type: string, nullable: true }` (no enum) and validate allowed values in the handler /
gracefully fall back for unknown values on the client. Only add `enum` to fields that are
never sent as null.
