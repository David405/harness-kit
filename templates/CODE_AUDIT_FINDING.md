# CODE AUDIT FINDING — <AUDIT-ID>-F<nn>: <short title>

> One finding per file or clearly separated section. Link from the parent `CODE_AUDIT_CONTRACT`.
> A finding recommends a **behaviour-preserving** change. If it cannot preserve behaviour,
> it is not a finding — it belongs under *Possible existing functional bugs* in the parent contract.

---

## Meta

| Field | Value |
|-------|--------|
| **ID** | `<AUDIT-ID>-F<nn>` |
| **Severity** | Critical / High / Medium / Low / Informational |
| **Category** | Best practices / Duplication / Optimisation / Code smell / Comments / Readability / Maintainability / Function quality / Conditionals / Error handling / Data flow / Tests / Dead code / Over-engineering / Under-engineering |
| **Confidence** | High / Medium / Low |
| **Regression risk** | Very Low / Low / Medium / High |
| **Status** | Draft / Confirmed / Disputed / Accepted into FEATURES / Fixed / Accepted risk |
| **Parent audit** | `<AUDIT-NNN>` |
| **Commit / tag** | `<ref reviewed>` |

> **Low confidence must never be presented as ready to apply.** Mark it
> *"Potential improvement — requires behavioural verification"* and complete
> *Behavioural safety* below.

---

## Location

- **File:** `<path>`
- **Module / class / function:** `<Name.fn>`
- **Lines (approx):** `<start-end>` if stable

---

## Problem

<Precisely what is wrong. No filler. No restating the code.>

## Why it matters

<The real engineering impact: what it costs to understand, change, or extend. If there is no
material cost, this is not a finding — delete it.>

## Evidence

<The actual pattern observed, with a short excerpt or accurate description. Never invent paths,
line numbers, call sites, or behaviour. If something could not be verified, say so here.>

**Validated against:** <call sites / imports / consumers / tests / interfaces / config /
serialization / framework registration checked before filing>

---

## Recommended change

<The smallest change that achieves a meaningful improvement. No cascading refactors.>

### Before / after

<Only when it meaningfully clarifies the recommendation. Omit otherwise.>

---

## Behavioural safety

<Why this preserves externally observable behaviour, and what must be verified first.>

- [ ] Same inputs accepted · same outputs · same errors
- [ ] Side effects and ordering unchanged
- [ ] Frozen contracts untouched (APIs, schemas, formats, routes, status codes, headers, env, config keys)
- [ ] Null/undefined handling and edge cases preserved
- [ ] Async / concurrency semantics unchanged
- [ ] Operationally-relied-upon logging unchanged

**Uncertainties:** <anything that must be proven before this is applied, or "none">

## Characterization tests required

<The tests that capture current behaviour for this code. They must be written and passing
**against the code as it stands today** before any refactor, and pass unchanged afterwards.>

- `<test path or description>` — <the behaviour it pins>

**Existing tests already covering this:** <refs, or "none — must be written first">

---

## Disposition

| Field | Value |
|-------|--------|
| **Proposed FEATURES id** | `<AREA-NNN>` |
| **Accepted by** | `<human — the agent never accepts its own finding>` |
| **Sprint contract** | `<path once created>` |
