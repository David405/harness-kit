# REVIEW PACKET — <FEATURE-ID>: <feature name>

> Produced by the Executor as the final step of implementation. The single artifact the
> Reviewer reads — complete by construction. The Reviewer should be able to complete Tier 2
> of REVIEW_CHECKLIST.md from this packet ALONE for a well-formed change, pulling raw files
> only to resolve specific doubt.
>
> EPHEMERAL — TEMPORARY FILE. Lives at .harness/review/<feature-id>.md (gitignored) or is
> pasted directly in paste-fallback mode. NEVER committed. DELETED once the feature is
> APPROVED, merged, and FEATURES.json marks it PASS. Deletion is owned by whoever merges,
> done alongside flipping FEATURES.json to PASS. In paste-fallback mode there is no file to
> delete. Packets inherit the sensitivity of their contents — never embed secrets.

## Header

- **Feature ID:** <AREA-NNN>
- **Contract:** <link / path to the approved sprint contract>
- **Branch:** <branch name>
- **Delivery mode:** file (.harness/review/<id>.md) | paste

## Summary of change

<2–4 sentences: what was built, against which contract.>

## Files changed

| Path | What changed | Grounded / Educated |
|------|--------------|---------------------|
| <path> | <one line> | GROUNDED / EDUCATED |

## Per-criterion evidence

> FILL THIS TABLE IN TWO STEPS. (1) First, copy each success criterion from the approved
> contract VERBATIM into the Criterion column — one row per criterion, in contract order,
> before filling anything else. (2) Then complete "How met" and "Pointer" for each row.
>
> Do NOT summarize, reword, merge, or omit criteria. Do NOT substitute the handoff's
> verify-steps for the contract's success criteria — they are different lists; use the
> contract's. Qualitative and reviewer-judged criteria get their own rows like any other.
> Mechanical/verify-string checks live in "Deterministic check results", not here.

| # | Criterion | How met | Pointer |
|---|-----------|---------|---------|
| 1 | <criterion> | <how> | <file:section> |

## Deterministic check results

> VERBATIM command output, not checkboxes. If a check wasn't run, say so and why.

- **Verify step:** <command> → <verbatim output>
- **JSON parse (if applicable):** <command> →
<verbatim output>
- **Build / test / lint:** <commands> →
<verbatim output>
- **git status:** →
<verbatim output — must show only expected files, no packet file>
- **Dependency audit (if deps touched):** <command> →
<verbatim output>

## Self-report

- **Assumptions made:** <list, or "none">
- **Deviations from contract:** <list, or "none">
- **Anything skipped / deferred:** <list, or "none">

## Drill-down index

> Files the Reviewer can request in full if a claim needs checking.

- <path> — <why it might warrant a full read>
