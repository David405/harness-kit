# SPRINT CONTRACT — <FEATURE / CHANGE>

> Written by the **agent**. Approved by the **human** before any test or production code.
> One feature / a handful of files per contract. If it's bigger, split it.
> For `solidity-audit`, prefer `AUDIT_CONTRACT.md` (or embed its sections here).

---

## Work-type profile (required)

Pick **one**:

- [ ] `service` — app/domain logic (TS / Go / Rust / …)
- [ ] `http-api` — HTTP request/response surface
- [ ] `solidity-build` — smart contract implementation or fix
- [ ] `solidity-audit` — use audit contract / sections
- [ ] `ops-docs` — observability, docs, process-only
- [ ] `code-audit` — periodic whole-subsystem quality audit (use `CODE_AUDIT_CONTRACT.md`)

**Languages / toolchain:** <e.g. TypeScript+Bun, Rust+Cargo, Go 1.22, Solidity+Foundry — cite AGENTS.md>

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

## Decisions

| Topic | Decision | Status |
|-------|----------|--------|
| <e.g. error shape / storage / skip vs reject> | <locked answer> | Locked / Open |

---

## Tests first (TDD — mandatory for behaviour changes)

> No production code for a behaviour change until these tests exist and fail for the right reason.
> Use **this repo's** runner from `AGENTS.md` (bun/vitest, cargo test, go test, forge test, …).
> N/A for pure docs with no behaviour change; audits use PoC-first in `AUDIT_CONTRACT.md`.

- **Test files to create or extend:**
  - `<path/to/test>` — <what it asserts>
- **Expected RED output:** <command to run + what failure looks like>
- **Verify commands (GREEN):**
  - `<command from AGENTS.md>`
  - `<lint / typecheck / forge test — as applicable>`

### Vertical slice (when non-trivial)

- **Behaviour delivered:** <user-visible or port-level capability>
- **Touchpoints:** <modules / packages / contracts>
- **TDD order:** red → green → refactor notes
- **Done when:** <checklist aligned with Success criteria / VERIFY>

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

Each criterion must be **falsifiable** (command output, status+body, revert, log field, finding ID — not vague “clear error” / “unchanged”).

1. <...>
2. <...>
3. Diff confined to declared paths; `git status` shows only expected files.
4. All work on confirmed feature branch `<name>` — not on default branch.
5. All verify commands green.

## Quality gates (tick or N/A)

- [ ] Falsifiable success criteria (always required)
- [ ] Trust-boundary failure mode documented (typed error / `Err` / revert / 4xx — no uncaught panic/throw across handler/job boundary where applicable) — or **N/A**
- [ ] Partial/optional deps: skip vs reject documented; no wasted I/O when optional dep absent — or **N/A**
- [ ] **http-api only:** request **and** response schema/docs updated; error envelope regression in VERIFY — or **N/A**
- [ ] **solidity-build only:** invariant / access-control / value-flow risks named; declared forge (or equivalent) tests in VERIFY — or **N/A**
- [ ] **solidity-audit only:** `AUDIT_CONTRACT` sections completed; High/Critical have PoC commands — or **N/A**
- [ ] **behaviour-preserving refactor only:** characterization tests captured and passing **before**
      the change; the same tests pass unchanged after; declared frozen contracts untouched — or **N/A**
- [ ] **`service` / `http-api` / `solidity-build` only:** code-quality gate run
      (the `code-quality-gate` skill); declared lint command recorded; violations = 0
      or carrying documented exceptions — or **N/A**

## Edge cases / failure modes

- <What could go wrong and how it's handled>
- <Anything that would silently break an invariant>

## Threat model

<SKIP for low-stakes changes. REQUIRED if this feature touches money,
authentication, user data, external input, or Solidity funds/authz/upgrades.>
- **Assets at risk:** <what could be lost/exposed/corrupted>
- **Entry points / attack surface:** <new endpoints, inputs, permissions, deps, calls>
- **Threats considered:** <e.g. injection, authz bypass, reentrancy, oracle manipulation>
- **Mitigations in this sprint:** <what handles each threat above>
- **Security review:** run the `security-checklist` skill before merge.

## Blocking questions (gates)

<Anything that must be answered before implementation. If none, write "None.">

---

## FEATURES.json entry

```json
{
  "id": "<AREA-NNN>",
  "name": "<...>",
  "priority": <n>,
  "verify": "<runnable command from AGENTS.md>",
  "status": "FAIL"
}
```
