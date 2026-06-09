#!/bin/sh

set -eu

KIT_VERSION="0.1.0"

target_arg=${1:-.}

if ! target=$(cd "$target_arg" 2>/dev/null && pwd -P); then
  printf '%s\n' "error: target directory does not exist or is not accessible: $target_arg" >&2
  exit 1
fi

if ! git -C "$target" rev-parse --git-dir >/dev/null 2>&1; then
  printf '%s\n' "error: target is not a git repository: $target" >&2
  exit 1
fi

script_dir=$(dirname "$0")
if ! kit_dir=$(cd "$script_dir" 2>/dev/null && pwd -P); then
  printf '%s\n' "error: could not resolve updater location" >&2
  exit 1
fi

if [ ! -f "$kit_dir/HARNESS.md" ] || [ ! -d "$kit_dir/templates" ]; then
  printf '%s\n' "error: update.sh must be run from a cloned harness-kit directory." >&2
  printf '%s\n' "Clone the kit, then run ./update.sh /path/to/your-repo." >&2
  exit 1
fi

if [ ! -d "$target/.harness/templates" ]; then
  printf '%s\n' "error: Kit not installed here — run install.sh first." >&2
  exit 1
fi

version_file="$target/.harness/VERSION"
old_version="unknown"
if [ -f "$version_file" ]; then
  old_version=$(sed -n 's/^version=//p' "$version_file" | sed -n '1p')
  if [ -z "$old_version" ]; then
    old_version="unknown"
  fi
fi

cp "$kit_dir/HARNESS.md" "$target/HARNESS.md"
cp "$kit_dir/ADOPTION.md" "$target/ADOPTION.md"
cp "$kit_dir/LOOP.md" "$target/LOOP.md"
cp "$kit_dir"/templates/* "$target/.harness/templates/"

update_date=$(date '+%Y-%m-%d')
printf 'version=%s\nupdated=%s\n' "$KIT_VERSION" "$update_date" > "$version_file"

drift_report="No drift detected in FEATURES.json legend status."
template_features="$target/.harness/templates/FEATURES.json"
live_features="$target/FEATURES.json"

if [ ! -f "$live_features" ]; then
  drift_report="Cannot check FEATURES.json drift: live FEATURES.json is missing."
elif [ ! -f "$template_features" ]; then
  drift_report="Cannot check FEATURES.json drift: refreshed template is missing."
else
  template_status=$(sed -n 's/.*"status"[[:space:]]*:[[:space:]]*\[\([^]]*\)\].*/\1/p' "$template_features" | sed -n '1p')
  live_status=$(sed -n 's/.*"status"[[:space:]]*:[[:space:]]*\[\([^]]*\)\].*/\1/p' "$live_features" | sed -n '1p')
  if [ -z "$template_status" ] || [ -z "$live_status" ]; then
    drift_report="Cannot reliably check FEATURES.json drift: legend status array not found."
  else
    template_count=$(printf '%s\n' "$template_status" | awk -F, '{ print NF }')
    live_count=$(printf '%s\n' "$live_status" | awk -F, '{ print NF }')
    if [ "$template_status" != "$live_status" ]; then
      drift_report="FEATURES.json drift: template legend status = [$template_status] ($template_count states); live FEATURES.json status = [$live_status] ($live_count states) — manual migration needed, see ADOPTION.md."
    fi
  fi
fi

cat <<EOF
Harness Kit update summary
Target: $target
Refreshed: HARNESS.md ADOPTION.md LOOP.md .harness/templates/*
Preserved: AGENTS.md FEATURES.json .harness/review/* project content
VERSION: Updated: $old_version -> $KIT_VERSION on $update_date
Drift: $drift_report

Manual next steps:
1) Review refreshed kit docs/templates.
2) Apply any reported manual migrations; see ADOPTION.md.
3) Review, then commit yourself — this script does not stage/commit/push.
EOF
