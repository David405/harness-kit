# <Product or Feature> — Engineering Requirements Document

> Companion: [`architecture.md`](./architecture.md) — owns system shape, diagrams, boundaries and
> control flows. This document owns goals, decisions, contracts, acceptance criteria, risks, open
> questions and slices. Keep the split; do not duplicate across the pair.
>
> Apply the standards pack declared in this repo's `AGENTS.md`. Record any divergence in
> **Design Decisions** with rationale — never diverge silently.

## Executive Summary

- **Product / feature:**
- **Source brief / PRD:**
- **Customer promise:** <what a caller can do once this ships>
- **Approach:**
- **MVP delivery shape:**

## Goals and Non-Goals

### Goals

-

### Non-Goals

> Required — at least one. Say where excluded work goes instead. Non-goals written here at S0 are
> what stop scope creep during execution; discovered later, they are already expensive.

-

## Engineering Standards / Goals

- **Standards pack applied:** <from `AGENTS.md`, or "none">
- **Performance bar:**
- **Reliability / availability:**
- **Security / privacy:**
- **Testing strategy:**
- **Observability:**
- **Deployable shape:** <service | library | contract | docs>

| Signal | Threshold | Action |
| --- | --- | --- |
|  |  |  |

## Implementation Overview

- **Mental model:**
- **Primary control flow:**
- **Data ownership:**

Diagrams and boundaries live in [`architecture.md`](./architecture.md).

## Design Decisions

### Decisions

| Decision | Rationale | Alternatives considered |
| --- | --- | --- |
|  |  |  |

### Acceptance Criteria / Done Signals

Each criterion must be falsifiable — name how it is verified, not "works correctly".

| Criterion / signal | Source | Verification method | Owner |
| --- | --- | --- | --- |
|  |  |  |  |

## API / Data Contracts

- **Naming and formats:**
- **Endpoint / event / message contracts:**
- **Error model:**
- **Wire encoding:** <exact representation of amounts, ids, timestamps — ambiguity here is expensive later>
- **Compatibility / migration rules:**

## Risks, Security Concerns, and Pre-Mortem

| Risk / likely failure | Impact | Early signal | Mitigation | Owner | Test / validation |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

## Open Questions

Every row needs an owner and a needed-by. An unowned question is not tracked.

| Question | Owner | Needed by | Status |
| --- | --- | --- | --- |
|  |  |  | Open / Locked |

## Implementation plan: Feature slices

> Write this **last**, after the sections above are stable. Slice 1 is scaffolding when the target is
> a deployable service; **N/A** otherwise. Each row is a concrete working behaviour end to end —
> never a layer cake ("schema", then "API", then "UI"). Prefer more small slices over few vague ones.

| Slice | Working behavior | Functional test | Notes |
| --- | --- | --- | --- |
| 1 |  |  |  |
| 2 |  |  |  |

### FEATURES.json seed

One entry per slice. `verify` is a runnable command from this repo's `AGENTS.md`. The agent
**proposes**; a human accepts into the ledger.

```json
[
  {
    "id": "<AREA-001>",
    "name": "<slice 1 working behaviour>",
    "priority": 1,
    "verify": "<runnable command from AGENTS.md>",
    "status": "FAIL",
    "notes": "From <ERD-NNN> slice 1"
  }
]
```

## Appendices

### Data Dictionary

| Field | Type | Required | Description | Source / owner |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

### Glossary

| Term | Meaning |
| --- | --- |
|  |  |

### References

-
