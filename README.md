# Harness Kit

A reusable, **tool-agnostic** framework for AI-assisted engineering — contract-first, TDD when
behaviour changes, multi-language (TypeScript, Rust, Go, Solidity build + audit).

| Doc | Audience | Purpose |
|-----|----------|---------|
| **`AGENTS.md`** | Agents | Single entrypoint — context, rules, and **Agent process** |
| **`FEATURES.json`** | Both | `FAIL` → `PENDING_REVIEW` → `PASS`; every `verify` = runnable command |
| **`templates/REVIEW.md`** | Reviewers | §0 contract compliance + production-readiness rubric |
| **`templates/AUDIT_CONTRACT.md`** | Auditors | Solidity audit slice contract |
| **`BOOTSTRAP.md`** | Maintainers | Bootstrap checklist + appendix source for regeneration |

**Kit v1.3:** work-type profiles (`service` / `http-api` / `solidity-build` / `solidity-audit` /
`ops-docs`); language-neutral VERIFY; optional skill packs must not replace the contract spine.

**Humans →** read `BOOTSTRAP.md` to adopt the kit into a repo. **Agents →** `AGENTS.md` only (in bootstrapped repos).
