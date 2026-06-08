# REVIEW CHECKLIST — <FEATURE>

> Run by the **Reviewer** — a DIFFERENT instance than the one that wrote the code.
> Evaluate the diff against the approved contract. **Flag, don't fix.** The human decides.

---

## Inputs

- Approved sprint contract: <link / paste>
- Diff under review: <paste or attach>
- Touched files: <list>

## Contract compliance

- [ ] Every success criterion in the contract is met (go through them one by one)
- [ ] Scope respected — nothing built that was marked out-of-scope
- [ ] Only the expected files changed (`git status` matches the impact map)
- [ ] No adjacent refactors / scope creep snuck in

## Grounding

- [ ] No hallucinated file paths, symbols, or APIs — everything referenced actually exists
- [ ] Reused existing patterns/tokens rather than inventing new ones
- [ ] Any [EDUCATED] paths from the contract were verified, not assumed

## Invariants (project-specific — pull from AGENTS.md)

- [ ] <e.g. no floats for money>
- [ ] <e.g. idempotency preserved on the changed path>
- [ ] <e.g. no secrets / internal IDs / voucher codes leaked to public responses>
- [ ] <e.g. state-machine transitions still valid>
- [ ] Error handling: propagated or logged, nothing silently swallowed

## Quality

- [ ] Verify step actually passes (not just "looks right")
- [ ] No obvious regressions (build, types, lint, existing tests)
- [ ] Responsive / cross-environment where relevant

## Verdict

- **Status:** APPROVE / CHANGES REQUESTED
- **Blocking issues:** <numbered list, or "none">
- **Non-blocking notes:** <optional>
- **FEATURES.json:** mark `<AREA-NNN>` PASS only if APPROVE and verify passed.

---

> If the only reviewer available is the tool that wrote the code, this checklist is invalid.
> Get an independent pass.
