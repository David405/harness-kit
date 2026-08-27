# AUDIT CONTRACT — <AUDIT-ID>: <system / commit / tag>

> Written by the **agent**. Approved by the **human** before audit EXECUTE.
> Work-type profile: **`solidity-audit`**. Deliverable is findings + PoCs + residual risk,
> not a product feature PASS.
> One audit slice per contract when scope is large; link fix follow-ups as `solidity-build` sprints.

---

## Meta

- **Audit ID:** `<AUDIT-NNN>`
- **Target repo:** <path / remote>
- **Commit / tag / release:** <immutable ref>
- **Chains / deployments in scope:** <e.g. Ethereum Sepolia, address list or N/A for source-only>
- **Prior reports:** <paths or "none">

---

## Branch (feature branch — mandatory)

- **Default branch:** <e.g. main>
- **Proposed feature branch:** `<e.g. audit/audit-001-origin-settler>`
- **Human confirmed:** <pending / yes + date / alternate>

---

## Scope — WILL review

- **Contracts / files:**
  - `<path>` — <why in scope>
- **Functions / flows of interest:**
  - <e.g. openIntent, fill, settle, upgrade, pause>

## Scope — will NOT review (this pass)

- <Explicit exclusions: dependencies, UI, off-chain solver, prior Low findings, …>
- <Where deferred work goes>

---

## Assets, actors, trust boundaries

- **Assets at risk:** <tokens, ETH, roles, merkle roots, …>
- **Actors:** <user, solver, admin, pauser, relayer, …>
- **Trust boundaries:** <EOA signatures, cross-chain messages, oracles, admin keys, …>
- **Privileged roles:** <who can upgrade / pause / set params>

---

## Severity rubric

Use the project rubric if `AGENTS.md` defines one; otherwise:

| Severity | Meaning |
|----------|---------|
| Critical | Direct loss of funds or irreversible protocol break under realistic conditions |
| High | Significant loss / takeover with plausible conditions |
| Medium | Limited loss, griefing, or conditional exploit |
| Low | Best-practice / defense-in-depth with low practical impact |
| Informational | Clarity, gas, docs — no security impact required |

---

## Tooling plan (commands from AGENTS.md)

> Brand names are examples. Use whatever this repo declares.

- [ ] Unit / integration: `<e.g. forge test>`
- [ ] Fuzz: `<command or N/A>`
- [ ] Invariant: `<command or N/A>`
- [ ] Fork (if in scope): `<command or N/A>`
- [ ] Static analysis (if used): `<e.g. slither . — or N/A>`
- [ ] Manual checklist: the `security-checklist` skill Solidity section

---

## Method

1. Map value flows and authz for in-scope entrypoints.
2. Hypothesis → attempt PoC (`forge test` or declared runner).
3. Write findings with `AUDIT_FINDING.md` (one file or section per finding).
4. High/Critical **require** a reproducible VERIFY command before claiming the finding.
5. Do not silently skip a suspected class of bug; either test it or record “attempted, not found” with what was tried.

---

## Finding ID scheme

- Pattern: `<AUDIT-ID>-F<nn>` e.g. `AUDIT-001-F01`
- Tracker: `FEATURES.json` may use `AUDIT-001` for the pass; findings live in the audit folder / report.

---

## Success criteria (falsifiable)

1. Every in-scope contract/file listed above was reviewed or explicitly deferred with rationale.
2. Every **High** and **Critical** finding has a PoC command that fails on vulnerable code (or documents why PoC is infeasible — rare; human must accept).
3. Tooling plan commands that were checked ran; output summarized in the audit notes.
4. Out-of-scope held: no drive-by refactors of production contracts unless a fix sprint is approved.
5. Work on confirmed feature branch only.
6. SECURITY_CHECKLIST Solidity section completed for this pass.

---

## Verify

```bash
# examples — replace with AGENTS.md commands
# forge test --match-path test/audit/...
# slither . --filter-paths lib
```

---

## Blocking questions (gates)

<Chains, commit pin, out-of-scope deps, whether fix PRs are in-band or follow-up. If none: None.>

---

## FEATURES.json entry

```json
{
  "id": "<AUDIT-NNN>",
  "name": "<audit pass name>",
  "priority": <n>,
  "verify": "<runnable PoC/tool command sequence>",
  "status": "FAIL",
  "notes": "profile=solidity-audit; contract=skills/.harness/contracts/<AUDIT-NNN>.md"
}
```

---

## Fix follow-ups

Each accepted finding that needs a code change gets a separate **`solidity-build`** sprint contract
referencing the finding ID. Do not mix large fix batches into the audit contract unless the human
explicitly approves that scope.
