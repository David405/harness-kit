# HARNESS STATE — <PROJECT>

> Working memory between agent sessions. Distinct from `FEATURES.json` (feature status).
> Lives at `skills/.harness/STATE.md` (gitignored). The agent forgets; this file does not.

## Last run

- <timestamp> — <what the session did>

## Current contract

- **Feature ID:** <AREA-NNN or AUDIT-NNN or "none">
- **Path:** `skills/.harness/contracts/<feature-id>.md`
- **Profile:** <service | http-api | solidity-build | solidity-audit | ops-docs | none>
- **Status:** <draft / awaiting human approval / approved / implementing / verify / PENDING_REVIEW>

## Current branch

- **Feature branch:** <name or "none — awaiting human confirmation">
- **Confirmed by human:** <yes + date / pending>

## Triaged findings

| id | finding | source (CI/issue/commit) | disposition |
|----|---------|--------------------------|-------------|
| <id> | <what was found> | <where> | <queued / sprint / inbox / dropped> |

## Tried and failed (do not re-attempt without new info)

| what was attempted | why it failed | date |
|--------------------|---------------|------|
| <attempt> | <reason> | <date> |

## Human-attention inbox

- <items the agent could not resolve and escalated to a person>
