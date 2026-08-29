---
name: create-pull-request
description: >-
  Open a GitHub pull request using the kit PR template. Use when the user asks to open/create a PR,
  push and PR, or publish a branch. Write a detailed, product-facing description. Contracts and
  harness review stay local — never put feature IDs, contract paths, or harness sections in the PR
  title or body.
---

# Create pull request

GitHub PRs are **product-facing and detailed**. A reviewer who has not seen the session should
understand the problem, the fix, what changed in behaviour, and how it was verified. Harness workflow
(contracts, `FEATURES.json` IDs, `harness-review`, audit finding codes) stays in local/session
context only.

## Before opening

1. Human explicitly asked to push and/or open a PR.
2. VERIFY is green; harness review is done (reported in chat, not in the PR body).
3. Run `git status`, `git diff` vs the default branch, `git log` for commits on the branch.
4. Draft the full body from the diff — do not ship a sparse PR.

## Title format

Conventional commit style — **no ticket/harness IDs**:

```
<type>(<scope>): <what changed in plain English>
```

**Do not** include: feature ledger IDs (`SEC-002`, `PAY-015`), audit codes (`AUDIT-001-F02`),
`PENDING_REVIEW`, or contract file paths.

## Body template (required sections)

Use **all** sections below. Omit a section only when truly N/A (say "N/A" in one line).

Template file: `templates/pull_request_template.md` (install to `.github/pull_request_template.md`
via `setup-harness-kit.sh` when missing).

```markdown
## Summary

<2–4 sentences: what this PR does and why it matters.>

## Problem

<What was broken, unsafe, or missing — user-visible or production symptom.>

## Solution

<How the code fixes it. Key functions, routes, guards.>

## Behaviour changes

| Before | After |
|--------|-------|
| <old> | <new> |

## Files changed

- `path/to/file` — <one line each>

## Risk and rollout

- **Risk:** Low / Medium / High — <why>
- **Rollback:** <safe to revert?>
- **Prod / env notes:** <env vars, flags — or "None">

## Test plan

- [x] `<command>` — <result>
- [ ] CI build + e2e
```

### Forbidden in title, body, and commit messages

- Feature ledger IDs, audit finding IDs, contract paths
- Sections named "Harness review", "Contract compliance", sprint contract paste
- Contract HTML markers (`<!-- harness-kit:contract:start -->`)
- Tool attribution (`Made with Cursor`, `Co-Authored-By` assistant)

## Command

```bash
git push -u origin HEAD
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
...
EOF
)"
```

Use the consumer repo's `gh` auth pattern if documented in `AGENTS.md`.

## Editing an existing PR

Rewrite the full body with `gh pr edit <number> --title "..." --body "$(cat <<'EOF' ... EOF)"`.
