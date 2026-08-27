# <PROJECT NAME>

<One-line description of what this project does.>

| Doc | Audience | Purpose |
|-----|----------|---------|
| **`AGENTS.md`** | Agents | Single entrypoint — context, rules, and **Agent process** (v1.3 multi-language spine) |
| **`FEATURES.json`** | Both | Progress: `FAIL` → `PENDING_REVIEW` → `PASS`; every `verify` = runnable command |
| **`BOOTSTRAP.md`** | Maintainers | Bootstrap checklist + appendix source for regeneration |
| **`<PROJECT_SETUP>.md`** | Humans | Optional — local dev, env, deploy (name is project-specific) |

**Work-type profiles:** `service` · `http-api` · `solidity-build` · `solidity-audit` · `ops-docs`  
**Audit:** the `solidity-audit` skill + `AUDIT_FINDING.md`

**Humans →** setup doc (if present). **Agents →** `AGENTS.md` only.
