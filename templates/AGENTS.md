# AGENTS.md — <PROJECT NAME>

> Canonical context for any AI agent working in this repo. Read at the start of every session.
> Open standard: read natively by most coding agents. Keep accurate; keep under ~400 lines.
> (If your tool prefers a different filename — CLAUDE.md, .cursor/rules — symlink or mirror this.)

---

## Stack

- **Language(s):** <e.g. TypeScript (strict), Rust (edition 2021)>
- **Framework(s):** <e.g. NestJS, Next.js>
- **Data:** <e.g. Postgres, Redis>
- **Infra / deploy:** <e.g. Docker, Render, CI provider>
- **Package manager:** <e.g. pnpm>

## Architecture

<2–3 sentences. What this does, how data flows, the key constraints. No essays.>

## Dependency flow (enforce strictly)

<e.g. Types → Config → Repo → Service → Runtime → UI>
Lower layers never import from higher layers.

## Critical rules / invariants

- <Naming conventions>
- <State machine / valid transitions, if any>
- <Idempotency requirements>
- <Money/precision rules — e.g. no floats, use Decimal>
- <What APIs must NEVER return — secrets, internal IDs, etc.>
- <Error handling: propagate or explicitly log; no silent swallowing>
- <Auth / security invariants>

## File map (depth 2)

```
src/
  <module>/        <one line: what it owns>
  <module>/        <...>
```

## How we work here

- Tests: <unit = pure only? integration = test containers?>
- Commits: <convention, e.g. conventional commits>
- Branching: <convention>
- <Anything a new engineer would need on day one>

## Current focus

<The active milestone. Update weekly. Point at FEATURES.json for the live list.>

## Off limits

<Files / modules / generated code never to touch without explicit instruction.>

---

## Conventions I keep getting wrong (correct me here)

<Running list of mistakes the agent has made, so future sessions don't repeat them.
This section is gold — every entry is a bug that won't happen twice.>
