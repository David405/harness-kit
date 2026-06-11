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
  printf '%s\n' "error: could not resolve installer location" >&2
  exit 1
fi

if [ ! -f "$kit_dir/HARNESS.md" ] || [ ! -d "$kit_dir/templates" ]; then
  printf '%s\n' "error: install.sh must be run from a cloned harness-kit directory." >&2
  printf '%s\n' "Clone the kit, then run ./install.sh /path/to/your-repo." >&2
  exit 1
fi

copied="HARNESS.md SETUP.md LOOP.md templates/*"
agents_status="already present; left untouched"
features_status="already present; left untouched"
gitignore_changes=""

cp "$kit_dir/HARNESS.md" "$target/HARNESS.md"
cp "$kit_dir/SETUP.md" "$target/SETUP.md"
cp "$kit_dir/LOOP.md" "$target/LOOP.md"

mkdir -p "$target/.harness/templates"
cp "$kit_dir"/templates/* "$target/.harness/templates/"

if [ ! -f "$target/AGENTS.md" ]; then
  cp "$kit_dir/templates/AGENTS.md" "$target/AGENTS.md"
  agents_status="scaffolded from templates/AGENTS.md"
fi

if [ ! -f "$target/FEATURES.json" ]; then
  cp "$kit_dir/templates/FEATURES.json" "$target/FEATURES.json"
  features_status="scaffolded from templates/FEATURES.json"
fi

gitignore="$target/.gitignore"
if [ ! -f "$gitignore" ]; then
  : > "$gitignore"
fi

append_header=false
if ! grep -qxF ".harness/review/" "$gitignore"; then
  append_header=true
fi
if ! grep -qxF "!.harness/templates/" "$gitignore"; then
  append_header=true
fi

if [ "$append_header" = true ] && ! grep -qxF "# Harness Kit" "$gitignore"; then
  printf '%s\n' "# Harness Kit" >> "$gitignore"
  gitignore_changes="${gitignore_changes}added header; "
fi

if ! grep -qxF ".harness/review/" "$gitignore"; then
  printf '%s\n' ".harness/review/" >> "$gitignore"
  gitignore_changes="${gitignore_changes}added .harness/review/; "
fi

if ! grep -qxF "!.harness/templates/" "$gitignore"; then
  printf '%s\n' "!.harness/templates/" >> "$gitignore"
  gitignore_changes="${gitignore_changes}added !.harness/templates/; "
fi

if [ -z "$gitignore_changes" ]; then
  gitignore_changes="already up to date"
fi

install_date=$(date '+%Y-%m-%d')
printf 'version=%s\ninstalled=%s\n' "$KIT_VERSION" "$install_date" > "$target/.harness/VERSION"

cat <<EOF
Harness Kit install summary
Target: $target
Copied: $copied
AGENTS.md: $agents_status
FEATURES.json: $features_status
.gitignore: $gitignore_changes
VERSION: wrote .harness/VERSION with version $KIT_VERSION and date $install_date

Manual next steps:
1) Follow SETUP.md for your setup path.
2) Use README.md "Adoption concepts" when generating AGENTS.md from the real codebase.
3) Review, then commit yourself — this script does not stage/commit/push.
EOF
