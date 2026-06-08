# SPRINT CONTRACT — <FEATURE / CHANGE>

> Produced by the **Architect**. Approved by the **human** before any code is written.
> One feature / a handful of files per contract. If it's bigger, split it.

---

## Scope — WILL do

<Exactly what this sprint delivers. Specific. One feature.>

## Scope — will NOT do (this sprint)

<Explicit out-of-scope items. Name the tempting adjacent work you're deliberately skipping,
and where it should go instead (follow-up sprint / different repo).>

## Target

- **Repo / package:** <which one, and why it's the right home>
- **Not touching:** <repos/modules that must stay untouched>

---

## Impact map

> Mark each path **[GROUNDED]** (verified to exist in the repo) or **[EDUCATED]** (inferred —
> Executor MUST verify before implementing). Never present educated guesses as grounded.

- **Files to change:**
  - `<path>` — <what changes> — [GROUNDED|EDUCATED]
- **Existing symbols/patterns to reuse:**
  - `<symbol / file>` — <the pattern to follow>
- **New files (if any):**
  - `<path>` — <why it's needed> — [NEW]
- **Interfaces / types affected:**
  - `<...>`

---

## Success criteria

<Numbered, each independently checkable. These become the Reviewer's checklist.>

1. <...>
2. <...>
3. Diff confined to the target repo; `git status` shows only expected files.

## Edge cases / failure modes

- <What could go wrong and how it's handled>
- <Anything that would silently break an invariant>

## Blocking questions (gates)

<Anything that must be answered before implementation. If none, write "None.">

---

## FEATURES.json entry

```json
{ "id": "<AREA-NNN>", "name": "<...>", "priority": <n>, "verify": "<...>", "status": "FAIL" }
```
