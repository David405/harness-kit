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

> Fill the Criterion column by PASTING the criteria: block from the handoff — one block line
> per table row, text copied VERBATIM. Do not retype, resolve from prose, paraphrase, merge,
> or omit, and never substitute handoff step text for a criterion. Then fill "How met" and
> "Pointer" for each row. Mechanical/verify-string checks go in "Deterministic check results".

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
