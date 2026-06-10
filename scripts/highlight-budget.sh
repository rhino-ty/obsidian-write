#!/usr/bin/env bash
#
# highlight-budget.sh — Count ==highlight== occurrences per leaf section
# and flag sections that exceed the budget defined in SKILL.md §6
# (Quantitative highlight budget variant).
#
# Budget:
#   h4 leaf      — 3 highlights
#   h3 leaf      — 4 highlights
#   h2 leaf      — 5 highlights
#   parent lead  — 1 highlight (h2/h3 with child headers; lead paragraph only)
#
# Usage:
#   ./scripts/highlight-budget.sh <file.md> [file2.md ...]
#   ./scripts/highlight-budget.sh path/to/vault           # recurse into directory
#
# Output:
#   For each over-budget section: <file>:<line>  <header>  (==N > budget M)
#   Frontmatter and fenced code blocks are excluded.
#
# Exit code:
#   0 if no overages, non-zero if any section exceeds budget (CI-friendly)
#
# Requires: bash, awk, find

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AWK_SCRIPT="$SCRIPT_DIR/highlight-budget.awk"

if [[ $# -eq 0 ]]; then
  echo "usage: $0 <file.md|dir> [...]" >&2
  exit 2
fi

if [[ ! -f "$AWK_SCRIPT" ]]; then
  echo "missing: $AWK_SCRIPT" >&2
  exit 2
fi

over=0
for target in "$@"; do
  if [[ -d "$target" ]]; then
    while IFS= read -r -d '' f; do
      awk -f "$AWK_SCRIPT" "$f" || over=1
    done < <(find "$target" -type f -name '*.md' -print0)
  elif [[ -f "$target" ]]; then
    awk -f "$AWK_SCRIPT" "$target" || over=1
  else
    echo "skip (not found): $target" >&2
  fi
done

exit $over
