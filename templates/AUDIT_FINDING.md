# AUDIT FINDING — <AUDIT-ID>-F<nn>: <short title>

> One finding per file or clearly separated section. Link from the parent `AUDIT_CONTRACT`.

---

## Meta

| Field | Value |
|-------|--------|
| **ID** | `<AUDIT-ID>-F<nn>` |
| **Severity** | Critical / High / Medium / Low / Informational |
| **Status** | Draft / Confirmed / Disputed / Fixed / Accepted risk |
| **Parent audit** | `<AUDIT-NNN>` |
| **Commit / tag** | <ref reviewed> |

---

## Location

- **File:** `<path>`
- **Contract / function:** `<Name.fn>`
- **Lines (approx):** `<start-end>` if stable

---

## Description

<What is wrong. Precise. No filler.>

## Impact

<Who loses what under which conditions. Tie to assets/actors from the audit contract.>

## Preconditions

<What must be true for the issue to matter (roles, market state, call order, …).>

## Proof of concept

> High/Critical: required. Medium: strongly preferred. Low/Info: optional.

```bash
# Reproducible command from AGENTS.md / Foundry / etc.
```

<Expected vs actual result in one or two sentences.>

## Recommended fix

<Practical remediation. Prefer minimal diff guidance over redesign essays.>

## References

- <Prior report IDs, SWC/CWE, internal ADRs — optional>

## Reviewer notes

- **False-positive risk:** Low / Medium / High — <why>
- **Related findings:** <IDs or none>
