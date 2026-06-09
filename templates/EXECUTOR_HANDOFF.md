# EXECUTOR HANDOFF — <FEATURE>

> Paste into the implementing tool. Derived from an APPROVED sprint contract.
> The Executor implements exactly this — no scope decisions, no architecture choices.

````
TASK: <one-sentence description of the single feature>

REPO / SCOPE: <package>. Do NOT touch any other package or unrelated files.

## Criteria (carried verbatim from the contract — paste into the packet)
```criteria
- [<id>] <verbatim criterion text>
```

STEP 1 — LOCATE (verify, do not assume):
  Find <the target>. Check in order:
    <candidate path 1>
    <candidate path 2>
    <fallback location>
  If it does not exist, <what to create and where> — do not duplicate.

STEP 2 — IMPLEMENT:
  <Exact change. Include the literal code/string where it removes ambiguity.>
  <Reuse existing patterns / tokens — name them. Introduce no new primitives.>

STEP 3 — VERIFY (run before reporting done):
  <The runnable verify step from the contract / FEATURES.json>

CONSTRAINTS:
  - <hard constraints: exact strings, what must NOT change>
  - One feature only. No adjacent refactors.
  - No new dependencies unless the contract says so.
  - git status must show only the expected file(s).

EMIT REVIEW PACKET (templates/REVIEW_PACKET.md):
  - Write to .harness/review/<feature-id>.md (gitignored) — OR output inline for paste
    if no connector is available.
  - Paste each line of the criteria: block above into the packet's Criterion column VERBATIM,
    one line per row. Do NOT retype, resolve, paraphrase, or substitute handoff step text.
  - Include VERBATIM deterministic-check outputs (verify, parse, build/test/lint,
    git status, dep audit).
  - Do NOT commit the packet. It is temporary and is deleted on merge + PASS.
````
