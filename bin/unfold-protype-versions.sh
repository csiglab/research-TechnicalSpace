#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: explode-prototype <proto_path> <explode_dir>"
  exit 1
}

[[ $# -ne 2 ]] && usage

proto_path="$1"
explode_dir="$2"

# ---- Validation ----

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Not inside a Git repository."
  exit 1
fi

if [[ ! -f "$proto_path" ]]; then
  echo "Error: File not found: $proto_path"
  exit 1
fi

mkdir -p "$explode_dir/versions"

# ---- Collect commits that modified the file ----

mapfile -t commits < <(
  git log --follow --format="%H" -- "$proto_path"
)

echo "Found ${#commits[@]} versions."

# ---- Explode current (HEAD) version ----

cp "$proto_path" "$explode_dir/prototype.html"

# ---- Explode each historical version ----

for commit in "${commits[@]}"; do
  short=$(git rev-parse --short "$commit")

  git show "$commit:$proto_path" \
    > "$explode_dir/versions/prototype.$short.html"
done

echo "Explosion complete → $explode_dir"
