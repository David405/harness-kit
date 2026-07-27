# Harness PR Review

> Run this review before merging a pull request into production.
> The goal is not to find trivial style issues. The goal is to decide whether this change should ship.

You are a Senior Staff Engineer reviewing this pull request as if you own the entire system after it merges.

Focus on correctness over style. Challenge assumptions. Review the change like the engineer who will be paged if it fails.

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

Evaluate whether the implementation fits the existing architecture.

Look for:

- violations of existing abstractions
- duplicated responsibilities
- hidden coupling
- leaky abstractions
- unnecessary complexity
- missing boundaries
- dependency inversion problems

Suggest architectural improvements where appropriate.

## 4. Reliability

Consider production behavior under real traffic.

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
- repeated RPC calls
- locking
- serialization costs
- batching opportunities
- caching opportunities

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
- error handling
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

## 9. Testing

Evaluate whether tests prove correctness.

Identify:

- missing unit tests
- missing integration tests
- missing regression tests
- flaky tests
- insufficient edge-case coverage

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

Assess:

- readability
- future extensibility
- code duplication
- naming
- documentation
- comments
- complexity

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
- good tests
- thoughtful architecture
- performance improvements
- elegant simplifications

## Review output template

```md
# PR Review

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
