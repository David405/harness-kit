# LOOP.md — Loop Readiness

> Companion to HARNESS.md. The harness is what one agent runs inside; the loop is the
> operating cadence around that harness. This file documents seams, rules, and state needed
> to become loop-ready without turning automation on.

---

## What a loop is (one floor above the harness)

> Harness engineering is the environment one agent runs inside. Loop engineering is the
> system that runs the harness on a cadence and feeds itself — it finds work, dispatches it,
> checks it, records state, and decides the next thing, so the system prompts the agents
> instead of you prompting them. The loop sits one floor above the harness; this kit is the
> harness, and LOOP.md describes how it becomes loop-ready.

## The five primitives, mapped to this kit

| Primitive | What it is | In this kit |
|-----------|-----------|-------------|
| Sub-agents (maker/checker) | one agent makes, a different one checks | COVERED — Architect/Executor/Reviewer; Reviewer is never the maker |
| Memory (state on disk) | state outside the conversation; the agent forgets, the repo doesn't | PARTIAL — FEATURES.json = feature status; templates/STATE.md (new) = loop/triage state |
| Skills (written intent) | project knowledge written where the agent reads it every run | COVERED — AGENTS.md + HARNESS.md |
| Automations (cadence) | scheduled discovery/triage; the heartbeat that makes it a loop | NEW SEAM — not wired here (loop-ready, not loop-on) |
| Worktrees (parallel isolation) | separate checkouts so parallel agents don't collide | SEAM — documented below against the session-isolation rule |
| Connectors/plugins | let the loop act in real tools (issues, CI, chat) | ADJACENT — governed by HARNESS.md Workflow safety (side effects human-gated) |

## Automation-precondition rule

> LOAD-BEARING — state as a RULE, not a suggestion.
>
> A loop step may be automated to run UNATTENDED only when its verification is computational
> (deterministic), not inferential. Computational stop-conditions — tests pass, lint clean,
> JSON valid, build green — are safe to automate. Inferential checks — security review,
> adversarial-assertion judgment, scope/coherence review — stay human-gated until proven
> reliable.
>
> Rationale: this kit has direct evidence that inferential controls fail under load and
> become reliable only when made computational (see the criteria-keying history). The same
> applies to loop stop-conditions. This rule is what keeps "design the loop" from becoming
> "press go and stop thinking."

## Worktrees for parallelism

Git worktrees are the mechanism for running parallel harness sessions without file
collisions. Each parallel sprint gets its own checkout, so each session can keep the kit's
session-isolation rule intact: one session, one concern; do not mix repos or concerns in the
same context.

Worktrees do not weaken the loop's gates. Each checkout still follows the same contract,
execute, verify, review path; worktrees only prevent simultaneous work from trampling the
same files.

## Walking away requires a verifier you trust

> An unattended loop is also a loop making mistakes unattended. The only reason you can walk
> away is a checker (the separated Reviewer / a computational stop-condition) you actually
> trust. "Done" is a claim, not a proof. Verification, comprehension, and judgment stay the
> engineer's job — the loop moves the leverage point, it does not remove you.

## Loop-ready, not loop-on

> This document describes how the kit becomes loop-ready. It includes NO scheduler, cron,
> /goal, /loop, or CI wiring, and implies none as active. Turning a loop on is a deliberate,
> separate decision gated by the automation-precondition rule above.
