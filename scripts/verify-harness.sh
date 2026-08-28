#!/bin/sh
# verify-harness.sh — deterministic checks on harness discipline.
#
# Rules and skills are instructions to a model that can misread them under load.
# This is a fact. Run it from a repo root; it exits non-zero on any violation.
#
#   ./verify-harness.sh                 # skip contract checks when no contract is reachable
#   ./verify-harness.sh --strict        # a skip becomes a failure
#   ./verify-harness.sh --contract <id> # check a specific contract
#   ./verify-harness.sh --base <ref>    # diff base for scope containment (default: origin/HEAD)
#
# CI and any editor hook invoke THIS script. Never reimplement a check elsewhere.
set -u

STRICT=0; CONTRACT=""; BASE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --strict) STRICT=1 ;;
    --contract) shift; CONTRACT="${1:-}" ;;
    --base) shift; BASE="${1:-}" ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
  shift
done

fails=0; skips=0
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; fails=$((fails + 1)); }
skip() {
  if [ "$STRICT" -eq 1 ]; then fail "$1 (skipped, and --strict is on)"
  else printf '  SKIP  %s\n' "$1"; skips=$((skips + 1)); fi
}

CONTRACTS_DIR=skills/.harness/contracts
[ -d "$CONTRACTS_DIR" ] || CONTRACTS_DIR=.harness/contracts
STATE=skills/.harness/STATE.md
[ -f "$STATE" ] || STATE=.harness/STATE.md

echo "harness verify"

# --- 1. ledger integrity ------------------------------------------------------
if [ -f FEATURES.json ]; then
  if python3 -m json.tool FEATURES.json >/dev/null 2>&1; then
    bad=$(python3 - <<'PY'
import json
d = json.load(open("FEATURES.json"))
legend = set(d.get("legend", {}).get("status") or ["FAIL", "PENDING_REVIEW", "PASS"])
out = []
for f in d.get("features", []):
    fid = f.get("id", "<no id>")
    if f.get("status") not in legend:
        out.append("%s: status %r not in legend" % (fid, f.get("status")))
    v = (f.get("verify") or "").strip()
    if not v:
        out.append("%s: empty verify" % fid)
    elif not any(c in v for c in "&|;$/") and " " not in v:
        out.append("%s: verify does not look like a command" % fid)
print("\n".join(out))
PY
)
    if [ -z "$bad" ]; then pass "FEATURES.json: parses, statuses legal, verify fields runnable"
    else printf '%s\n' "$bad" | while IFS= read -r l; do [ -n "$l" ] && printf '        %s\n' "$l"; done
         fail "FEATURES.json: invalid entries (above)"; fi
  else
    fail "FEATURES.json: does not parse"
  fi
else
  skip "FEATURES.json: not present"
fi

# --- 2. every PENDING_REVIEW has a contract ----------------------------------
if [ -f FEATURES.json ] && [ -d "$CONTRACTS_DIR" ]; then
  missing=$(python3 - "$CONTRACTS_DIR" <<'PY'
import json, os, sys
d = json.load(open("FEATURES.json"))
out = [f["id"] for f in d.get("features", [])
       if f.get("status") == "PENDING_REVIEW"
       and not os.path.exists(os.path.join(sys.argv[1], f["id"] + ".md"))]
print(" ".join(out))
PY
)
  if [ -z "$missing" ]; then pass "every PENDING_REVIEW feature has a contract file"
  else fail "PENDING_REVIEW without a contract: $missing"; fi
else
  skip "PENDING_REVIEW/contract cross-check"
fi

# --- 3. STATE points at a real contract --------------------------------------
if [ -f "$STATE" ]; then
  ref=$(grep -o '[A-Za-z0-9._/-]*contracts/[A-Za-z0-9._-]*\.md' "$STATE" | head -1)
  if [ -z "$ref" ]; then skip "STATE.md names no contract"
  elif [ -f "$ref" ]; then pass "STATE.md current contract exists ($ref)"
  else fail "STATE.md points at a missing contract: $ref"; fi
else
  skip "STATE.md not present"
fi

# --- 4/5. skills and rules load ----------------------------------------------
if [ -d skills ]; then
  bad=""
  for s in skills/*/SKILL.md; do
    [ -f "$s" ] || continue
    head -1 "$s" | grep -q '^---$' && grep -q '^name:' "$s" && grep -q '^description:' "$s" || bad="$bad $s"
  done
  if [ -z "$bad" ]; then pass "skills: frontmatter valid (retrievable)"
  else fail "skills with bad frontmatter:$bad"; fi
else
  skip "no skills directory"
fi

if [ -d rules ]; then
  bad=""
  for r in rules/*.mdc; do
    [ -f "$r" ] || continue
    head -1 "$r" | grep -q '^---$' && grep -q '^description:' "$r" && grep -q '^alwaysApply:' "$r" || bad="$bad $r"
  done
  if [ -z "$bad" ]; then pass "rules: frontmatter valid (will load)"
  else fail "rules with bad frontmatter:$bad"; fi
else
  skip "no rules directory"
fi

# --- resolve the active contract ---------------------------------------------
contract_file=""
if [ -n "$CONTRACT" ]; then
  contract_file="$CONTRACTS_DIR/$CONTRACT.md"
  [ -f "$contract_file" ] || contract_file="$CONTRACT"
elif [ -f "$STATE" ]; then
  ref=$(grep -o '[A-Za-z0-9._/-]*contracts/[A-Za-z0-9._-]*\.md' "$STATE" | head -1)
  [ -n "$ref" ] && [ -f "$ref" ] && contract_file="$ref"
fi

# --- 6. grounded paths exist (catches invented files) ------------------------
if [ -n "$contract_file" ] && [ -f "$contract_file" ]; then
  # Only backticked tokens that look like paths: they contain a slash, or carry a
  # known file extension. Branch names and commit SHAs are also backticked on
  # [GROUNDED] lines and are not paths.
  missing=""
  for p in $(grep -o '`[^`]*`[^|]*\[GROUNDED\]' "$contract_file" | grep -o '`[^`]*`' | tr -d '`' | sort -u); do
    case "$p" in
      *" "*|"") continue ;;
      */*) : ;;
      *.md|*.sh|*.json|*.yml|*.yaml|*.mdc|*.ts|*.js|*.go|*.rs|*.sol|*.py) : ;;
      *) continue ;;
    esac
    [ -e "$p" ] || missing="$missing $p"
  done
  if [ -z "$missing" ]; then pass "contract: every [GROUNDED] path exists"
  else fail "contract cites paths that do not exist:$missing"; fi
else
  skip "contract [GROUNDED] paths (no contract)"
fi

# --- 7. diff is contained by the impact map ----------------------------------
if [ -n "$contract_file" ] && [ -f "$contract_file" ] && git rev-parse --git-dir >/dev/null 2>&1; then
  base="$BASE"
  [ -n "$base" ] || base=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null || echo origin/master)
  if git rev-parse --verify -q "$base" >/dev/null; then
    undeclared=""
    for f in $(git diff --name-only "$base"...HEAD 2>/dev/null); do
      grep -qF "$f" "$contract_file" || undeclared="$undeclared $f"
    done
    if [ -z "$undeclared" ]; then pass "diff is contained by the contract impact map"
    else fail "changed but not declared in the contract:$undeclared"; fi
  else
    skip "scope containment (base $base unresolvable)"
  fi
else
  skip "scope containment (no contract)"
fi

# --- 8. RED was recorded, and failed for the right reason --------------------
if [ -n "$contract_file" ] && [ -f "$contract_file" ]; then
  if grep -q 'RED (recorded before EXECUTE)' "$contract_file"; then
    if grep -qi 'N/A' "$(printf %s "$contract_file")" && grep -A4 'RED (recorded before EXECUTE)' "$contract_file" | grep -qi 'N/A'; then
      pass "RED: declared N/A (no behaviour change)"
    elif grep -A6 'RED (recorded before EXECUTE)' "$contract_file" | grep -qiE 'assert|expect|to (be|equal)|assertion'; then
      pass "RED: recorded and failed on an assertion"
    else
      fail "RED: recorded but no assertion-shaped failure — a test that never failed proves nothing"
    fi
  else
    skip "RED artifact (contract predates the recording format)"
  fi
else
  skip "RED artifact (no contract)"
fi

# --- 9. branch discipline -----------------------------------------------------
if git rev-parse --git-dir >/dev/null 2>&1; then
  cur=$(git branch --show-current 2>/dev/null || echo "")
  def=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null | sed 's|^origin/||')
  [ -n "$def" ] || def=master
  if [ -z "$cur" ]; then skip "branch discipline (detached HEAD)"
  elif [ "$cur" != "$def" ]; then pass "on a feature branch ($cur)"
  else
    if [ -z "$(git status --porcelain 2>/dev/null)" ]; then pass "on $def and clean"
    else fail "uncommitted implementation on the default branch ($def)"; fi
  fi
else
  skip "branch discipline (not a git repo)"
fi

echo
if [ "$fails" -gt 0 ]; then
  echo "harness verify: $fails failure(s), $skips skipped"
  exit 1
fi
echo "harness verify: green ($skips skipped)"
exit 0
