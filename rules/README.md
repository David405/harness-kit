# Rules

Always-on constraints. Six of them, and that number is the point.

A **rule** is loaded on every turn and *subtracts* — it narrows what is acceptable. A **skill** loads
on a trigger and *adds* — it supplies a procedure. A **gate** is neither: it is a command that fails.

> **Gate it if you can, skill it if it is procedural, rule it only if it must hold everywhere.**

## The budget

Rules compete for the same always-on attention. Forty constraints are not honoured forty times as
well — they dilute each other, and the model silently weights some over others. So the kit ships
**six**, and a seventh has to displace one.

Before adding a rule, ask in order:

1. Can a command enforce this instead? → make it a **gate**, not a rule.
2. Does it only apply while doing a particular task? → put it in the **skill** that owns that task.
3. Does it hold regardless of what is being done? → a rule.

A rule that is not load-bearing should be deleted or promoted to a gate.

## Ownership tiers

Only tier 1 belongs in this directory.

| Tier | Example | Home |
|------|---------|------|
| 1. **Process law** | Contract before changes; branch before work; who may set `PASS` | **The kit** — here |
| 2. **Repo invariants** | Money precision, dependency direction, what an API must never return | The consumer repo — `.agents/local-rules/` |
| 3. **Product specifics** | Service URLs, log query syntax, ownership context | The consumer repo — `.agents/local-rules/` |
| 4. **Personal style** | Prose preferences, review tone, comment formatting | The person's editor settings, not any repo |

Tier 4 in particular does not belong in a shared repo. It travels with a person, not a codebase.

## Format

Each rule is `<name>.mdc` with frontmatter:

```markdown
---
description: One line, third person, stating what it constrains
alwaysApply: true
globs: ""
---
```

`alwaysApply: true` loads it every turn. Set `globs` instead when a rule genuinely applies to a subset
of files — a scoped rule costs nothing when those files are untouched, which is how the always-on
budget stays small.

## How these load

Canonical here in the kit. The setup script links them into the editor's rules directory, and also
assembles their bodies (frontmatter stripped) into a marked block in the consumer's `AGENTS.md`, so
agents without a rules feature still receive them. Local rules in `.agents/local-rules/` merge
alongside and win on name collision.

Kit upgrades are a submodule pointer bump and a setup re-run. Never edit these files in a consumer repo.
