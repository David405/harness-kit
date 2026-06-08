# EXECUTOR HANDOFF — <FEATURE>

> Paste into the implementing tool. Derived from an APPROVED sprint contract.
> The Executor implements exactly this — no scope decisions, no architecture choices.

```
TASK: <one-sentence description of the single feature>

REPO / SCOPE: <package>. Do NOT touch any other package or unrelated files.

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

REPORT BACK:
  - The diff (or before/after of changed files)
  - Result of the verify step
  - Anything you had to assume or deviate from
```
