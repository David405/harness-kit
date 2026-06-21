# SPRINT CONTRACT — <FEATURE / CHANGE>

> Written by the **agent**. Approved by the **human** before any test or production code.
> One feature / a handful of files per contract. If it's bigger, split it.

---

## Scope — WILL do

<Exactly what this sprint delivers. Specific. One feature.>

## Scope — will NOT do (this sprint)

<Explicit out-of-scope items and where deferred work should go instead.>

## Target

- **Repo / package:** <which one, and why it's the right home>
- **Not touching:** <repos/modules that must stay untouched>

---

## Branch (feature branch — mandatory)

> Implementation on the default branch is forbidden. The human must confirm the branch name
> before the agent creates or checks out the branch.

- **Default branch:** <e.g. main — detected via `git symbolic-ref` or AGENTS.md>
- **Proposed feature branch:** `<e.g. feat/area-001-short-description>`
- **Human confirmed:** <pending — agent asks before checkout / yes + date / alternate name supplied>

---

## Tests first (TDD — mandatory)

> No production code until these tests exist and fail for the right reason.

- **Test files to create or extend:**
  - `<path/to/test.spec.ts>` — <what it asserts>
- **Expected RED output:** <command to run + what failure looks like>
- **Verify commands (GREEN):**
  - `<e.g. pnpm test path/to/test.spec.ts>`
  - `<e.g. pnpm test && pnpm lint>`

---

## Impact map

> Mark each path **[GROUNDED]** (verified in repo) or **[EDUCATED]** (must re-verify before
> implementing). Never present educated guesses as grounded.

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

<Numbered, each independently checkable. Include "all verify commands green.">

1. <...>
2. <...>
3. Diff confined to declared paths; `git status` shows only expected files.
4. All work on confirmed feature branch `<name>` — not on default branch.

## Edge cases / failure modes

- <What could go wrong and how it's handled>
- <Anything that would silently break an invariant>

## Threat model

<SKIP for low-stakes changes. REQUIRED if this feature touches money,
authentication, user data, or external input.>
- **Assets at risk:** <what could be lost/exposed/corrupted>
- **Entry points / attack surface:** <new endpoints, inputs, permissions, deps>
- **Threats considered:** <e.g. injection, authz bypass, replay, data leakage>
- **Mitigations in this sprint:** <what handles each threat above>
- **Security review:** run `skills/.harness/templates/SECURITY_CHECKLIST.md` before merge.

## Blocking questions (gates)

<Anything that must be answered before implementation. If none, write "None.">

---

## FEATURES.json entry

```json
{
  "id": "<AREA-NNN>",
  "name": "<...>",
  "priority": <n>,
  "verify": "<runnable test command>",
  "status": "FAIL"
}
```
