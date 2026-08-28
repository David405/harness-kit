# Harness Kit

A reusable, **tool-agnostic** framework for AI-assisted engineering — contract-first, TDD when
behaviour changes, multi-language (TypeScript, Rust, Go, Solidity build + audit).

**Kit v2.1** — the process ships as **skills**, adopted as a **git submodule**. Skills stay canonical
here, so an upgrade is a pointer bump, not a per-repo edit.

## Adopt

```sh
git submodule add <harness-kit-url> harness-kit
git submodule update --init --recursive
./harness-kit/scripts/setup-harness-kit.sh
```

Setup creates **symlinks only** — no copies, so nothing drifts. Then open an agent session and run
`harness-onboard` to scaffold `AGENTS.md`, `FEATURES.json` and `STATE.md` for the repo.

## Upgrade

```sh
git submodule update --remote harness-kit
./harness-kit/scripts/setup-harness-kit.sh
```

## Skills

| Skill | Use when |
|-------|----------|
| `erd-authoring` | Defining a new product or feature **before** contracts exist — five gated stages |
| `harness-onboard` | Adopting the kit into a repo; scaffolding `AGENTS.md` / `FEATURES.json` / `STATE.md` |
| `sprint-contract` | Starting any non-trivial change — contract before code |
| `code-quality-gate` | At VERIFY, on the diff, for `service` / `http-api` / `solidity-build` |
| `code-audit` | Periodic whole-subsystem quality audit; behaviour-preserving |
| `solidity-audit` | Contract security review; PoC required for High/Critical |
| `security-checklist` | Pre-merge check for money, auth, user data, external input, contract funds |
| `harness-review` | Reviewing a PR or grading work at `PENDING_REVIEW` |

Each skill bundles its forms in `skills/<name>/templates/`.

## How the pieces fit

- **`AGENTS.md`** (in the consumer repo) — the single agent entrypoint; tool-agnostic, read natively.
- **`FEATURES.json`** — the ledger. `FAIL` → `PENDING_REVIEW` → `PASS`; every `verify` is a runnable command.
- **`skills/.harness/`** — working state: contracts and `STATE.md`. Gitignored, local to the repo.
- **Work-type profiles** — `service` · `http-api` · `solidity-build` · `solidity-audit` · `ops-docs` · `code-audit` · `product-erd`.
  The profile decides which quality gates are in force and which are N/A.

The kit ships **no thresholds and no tool mandates**. Verify commands, linters and architecture
patterns come from the consumer repo's `AGENTS.md`.

## Deprecated

`BOOTSTRAP.md` and `scripts/build-bootstrap.sh` were the single-file adoption path through v1.5.
They still work for repos already bootstrapped from them, and are removed in `KIT-SKILLS-002`.
New repos should use the submodule flow above. Migrating an already-bootstrapped repo is a
per-repo contract, not a kit change.

**Humans →** this file. **Agents →** `AGENTS.md` in the consumer repo.
