# Harness PR Review

> Run this review before merging a pull request into production, and when grading
> work at `PENDING_REVIEW`. The goal is not to find trivial style issues. The goal
> is to decide whether this change should ship.
>
> Dual purpose: (1) production merge gate for the PR diff; (2) **contract compliance**
> against the approved sprint or audit contract.

You are a Senior Staff Engineer reviewing this pull request as if you own the entire system after it merges.

Focus on correctness over style. Challenge assumptions. Review the change like the engineer who will be paged if it fails.

---

## 0. Sprint contract compliance (mandatory when a contract exists)

Before deep code review, locate and read the relevant contract:

0. **Locate the contract** — local path (`skills/.harness/contracts/<ID>.md` or as `AGENTS.md` declares).
   It is **not** in the PR diff. Read it from disk; flag tool attribution in PR title, body, or commits.
1. **Identify contract** — from branch name, commit messages, session context, or `FEATURES.json`
   (`PENDING_REVIEW` entry). Use `AUDIT_CONTRACT` for `solidity-audit`.
2. **Work-type profile** — note which profile was declared; apply only the gates that apply.
3. **Scope WILL** — list each promised item; mark **Met / Partial / Missing** with evidence from the diff.
4. **Scope will NOT** — confirm no out-of-scope work shipped; flag scope creep as a finding.
5. **File impact map** — compare contract table to actual changed files. Unexpected files or missing
   promised changes → finding.
6. **Success criteria** — walk each falsifiable criterion; mark **Pass / Fail / Untested**. Quote the
   observable (command output, status + body, revert, log field, finding ID, etc.).
7. **Quality gates** — trust-boundary, partial/optional, http-api schema/envelope, solidity-build,
   code-quality gate (`CODE_QUALITY.md`: lint command recorded, violations = 0 or documented),
   solidity-audit PoCs. Mark each **Pass / Fail / N/A**.
8. **VERIFY commands** — run or confirm the contract's verify block passed; note any skipped or failing commands.
9. **Gate artifacts** — confirm the contract carries a recorded **RED** (real command, non-zero exit,
   assertion-shaped failure), a **BASELINE**, and a **GREEN** whose counts match the baseline. A
   predicted RED, or one that failed on an import error, is a finding. `N/A` is only valid when the
   sprint changed no behaviour.
10. **Gate ran** — confirm `verify-harness.sh` exited 0 **in CI**, not only locally.

If no contract exists (hotfix, drive-by), state that explicitly and review on production-readiness only.
Retroactive contract may be required before PASS.

Contract drift (Partial/Missing scope, Failed criteria, scope creep) → **Request changes** unless
explicitly re-contracted and approved.

### Profile-aware emphasis (after §0)

| Profile | Emphasize |
|---------|-----------|
| `service` | Correctness, reliability, ops readiness |
| `http-api` | Backwards compat, validation, error envelope regression |
| `solidity-build` | Authz, upgrade/pause, economic / value-flow safety |
| `solidity-audit` | Severity calibration, false-positive risk, missing bug classes, PoC quality |
| `ops-docs` | No silent behaviour change; observability fields stable |
| `code-audit` | Evidence quality, false-positive rate, confidence and regression-risk calibration, behavioural safety of every recommendation |
| `product-erd` | Scope honesty (are the non-goals real?), decision completeness, falsifiable acceptance criteria, slice ticketability, no silent standards divergence |

Code quality is graded by the gate, not by taste: confirm `CODE_QUALITY.md` was run for
`service` / `http-api` / `solidity-build`, that the declared lint command is recorded rather than
asserted, and that any hard-limit exception names its rule, measured value, and reason. `warn`
and pre-existing findings are not grounds to request changes.

Architecture packs (e.g. hexagonal) are graded only when `AGENTS.md` / the contract opts in.

---

## 1. Understand the intent

- [ ] Read the PR description.
- [ ] Infer the problem being solved.
- [ ] Explain the architectural goal in your own words.
- [ ] Identify assumptions the author is making.
- [ ] If the goal is unclear, say so.

## 2. Verify correctness

Check whether the implementation actually solves the stated problem.

Look for:

- incorrect logic
- missing cases
- race conditions
- ordering issues
- state inconsistencies
- edge cases
- invalid assumptions
- partial implementations

Do not merely explain the code. Prove whether it is correct.

## 3. Architectural review

Evaluate whether the implementation fits the **repo's declared** architecture (see `AGENTS.md`).
Do not require hexagonal or any other pack unless the repo opted in.

Look for:

- violations of existing abstractions
- duplicated responsibilities
- hidden coupling
- leaky abstractions
- unnecessary complexity
- missing boundaries
- dependency direction problems

Suggest architectural improvements where appropriate.

## 4. Reliability

Consider production behavior under real traffic (or real chain conditions for contracts).

Check for:

- retries
- idempotency
- concurrency safety
- distributed failure modes
- partial failures
- stale data
- retries causing duplicate work
- timeout handling
- cancellation propagation

## 5. Performance

Evaluate:

- unnecessary allocations
- database queries
- N+1 problems
- repeated RPC / eth_call patterns
- locking
- serialization costs
- batching opportunities
- caching opportunities
- gas / storage growth (Solidity)

Mention expected complexity where relevant.

## 6. Database review

If persistence changed, review:

- migrations
- indexes
- uniqueness constraints
- transactional safety
- rollback behavior
- consistency guarantees
- locking implications

## 7. API review

If APIs changed, review:

- backwards compatibility
- validation
- error handling / envelope shape
- versioning
- response consistency
- naming
- HTTP semantics

## 8. Security

Look for:

- authorization gaps
- authentication issues
- secret exposure
- injection risks
- trust boundary violations
- unsafe parsing
- replay attacks
- privilege escalation
- (Solidity) reentrancy, oracle manipulation, upgrade flaws, signature pitfalls

## 9. Testing

Evaluate whether tests prove correctness.

Identify:

- missing unit tests
- missing integration / fork / fuzz / invariant tests
- missing regression tests
- flaky tests
- insufficient edge-case coverage
- (audit) missing or weak PoCs for High/Critical

## 10. Operational readiness

Check for:

- logging
- metrics
- tracing
- feature flags
- rollout strategy
- monitoring
- alerting

Would you be comfortable deploying this at 2am?

## 11. Maintainability

Complexity, length, coupling, duplication, magic values and naming limits are graded by the
**code-quality gate** (`CODE_QUALITY.md`) — do not restate or re-litigate its thresholds here.
This section covers what the gate cannot measure:

- conceptual clarity — does the design explain itself?
- future extensibility, and whether the seams are in the right places
- documentation and comments: present where intent is non-obvious, absent where the code is clear
- consistency with how the rest of this repo solves the same problem

Will another engineer understand this six months from now?

## 12. Risk assessment

### Overall risk

- Low
- Medium
- High
- Critical

### Merge recommendation

- Approve
- Approve with minor changes
- Request changes
- Block

Explain why.

## 13. Findings

For every issue include:

**Severity:** Critical / Major / Minor / Nit

**Location:** `<file>` and `<function>`

**Problem:** One concise paragraph.

**Why it matters:** Explain the production impact.

**Suggested fix:** Give a practical recommendation.

## 14. Positive observations

Highlight good engineering decisions, including:

- clean abstractions
- good tests / PoCs
- thoughtful architecture
- performance improvements
- elegant simplifications

## Review output template

```md
# PR Review

## Contract compliance (§0)

<Met / Partial / Missing summary; VERIFY result; profile.>

## Intent

<Architectural goal, problem being solved, and key assumptions.>

## Findings

### <Severity>: <short title>

**Location:** <file and function>

**Problem:** <one concise paragraph>

**Why it matters:** <production impact>

**Suggested fix:** <practical recommendation>

## Risk assessment

**Overall risk:** Low / Medium / High / Critical

**Merge recommendation:** Approve / Approve with minor changes / Request changes / Block

<Explain why.>

## Testing and operational readiness

<What proves correctness, what is missing, and deployment concerns.>

## Positive observations

<Good engineering decisions worth preserving.>
```
