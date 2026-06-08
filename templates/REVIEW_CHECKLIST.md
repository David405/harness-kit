# REVIEW CHECKLIST — <FEATURE>

> Run by the **Reviewer** — a DIFFERENT instance than the one that wrote the code.
> Evaluate the diff against the approved contract. **Flag, don't fix.** The human decides.

---

## Inputs

- Approved sprint contract: <link / paste>
- Review Packet: <paste or path>
- Touched files: <list>

## Tier 1 — Machine-verified (confirm packet evidence present + green)

> The Reviewer confirms the packet CARRIES this evidence and that it passed — does not
> re-run or re-derive it. If evidence is missing, the packet is incomplete → reject.

- [ ] Verify step output present and passing
- [ ] Build / type / lint output present and clean (where applicable)
- [ ] JSON / config parses (where applicable) — output present
- [ ] git status shows only expected files (and NO packet file)
- [ ] Dependency audit clean (if deps touched)

## Tier 2 — Judgment (Reviewer evaluates)

> Evaluate the Review Packet against the approved contract. Pull raw files only to resolve
> a specific doubt.

- [ ] Every success criterion in the contract is met (go through them one by one)
- [ ] Scope respected — nothing built that was marked out-of-scope
- [ ] Only the expected files changed (`git status` matches the impact map)
- [ ] No adjacent refactors / scope creep snuck in
- [ ] No hallucinated file paths, symbols, or APIs — everything referenced actually exists
- [ ] Reused existing patterns/tokens rather than inventing new ones
- [ ] Any [EDUCATED] paths from the contract were verified, not assumed
- [ ] <e.g. no floats for money>
- [ ] <e.g. idempotency preserved on the changed path>
- [ ] <e.g. no secrets / internal IDs / voucher codes leaked to public responses>
- [ ] <e.g. state-machine transitions still valid>
- [ ] Error handling: propagated or logged, nothing silently swallowed
- [ ] **Security gate:** if this feature touches money, auth, user data, or external input, the SECURITY_CHECKLIST.md pass was completed and APPROVED
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
