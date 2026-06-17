---
name: gpt-5 reasoning token budget
description: Why gpt-5* chat completions can return empty content unless max_completion_tokens is large enough.
---

# gpt-5* reasoning tokens consume max_completion_tokens

When calling `openai.chat.completions.create` with a `gpt-5*` model (gpt-5,
gpt-5-mini, gpt-5-nano) via the Replit AI Integrations proxy, the model spends
**reasoning tokens** out of the same `max_completion_tokens` budget before it
emits any visible content. If the budget is too small, the call still returns
HTTP 200 but `choices[0].message.content` is **empty** — your JSON.parse then
falls back to `{}` and you get an empty result with no error.

**Why:** observed when a `suggest-drivers` JSON endpoint set
`max_completion_tokens: 1200` and consistently returned empty drivers; raising
it to `4000` produced full output. The per-agent simulation calls work at `600`
only because their expected output is a single tiny JSON object.

**How to apply:** for any gpt-5* call that must return a non-trivial JSON
payload, budget generously (a few thousand `max_completion_tokens`), not just
enough for the visible output. If a gpt-5* call mysteriously returns empty/blank
content with a 200 status, the token budget is the first thing to raise.
