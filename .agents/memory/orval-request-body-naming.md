---
name: Orval request-body schema naming
description: How to name OpenAPI request-body component schemas in this repo so orval codegen doesn't emit duplicate exports.
---

# Orval request-body component schema naming

Request-body component schemas in `lib/api-spec/openapi.yaml` must be named `XxxInput`
(e.g. `ImportElectionInput`, `RegeneratePopulationInput`), NOT `XxxBody`.

**Why:** orval's zod target auto-generates a runtime const named from the operationId +
`Body` (operationId `importElection` → `ImportElectionBody`) and the api-zod barrel also
re-exports the TS interface generated from the component schema name. If the component is
itself named `ImportElectionBody`, both the interface and the zod const collide and
`tsc --build` fails with TS2308 "already exported a member named 'ImportElectionBody'".

**How to apply:** name body components `XxxInput`; orval then emits the zod const as
`XxxBody` and the response zod const as `XxxResponse` (from a component named `XxxResult`).
Server routes import the zod consts (`XxxBody`, `XxxResponse`) from `@workspace/api-zod`;
the `XxxInput`/`XxxResult` names are the generated TS interfaces. This mirrors the existing
`RegeneratePopulationInput`/`RegeneratePopulationResult` pair.
