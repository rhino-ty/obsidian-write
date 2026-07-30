#!/usr/bin/env bash
#
# em-dash-audit.sh — Flag em dash / en dash in Korean prose, per SKILL.md §6
# (Optional: Korean punctuation policy).
#
# Reports any line that contains `—` or `–` AND a Korean character.
# Fenced code blocks and frontmatter are excluded.
#
# Usage:
#   ./scripts/em-dash-audit.sh <file.md> [file2.md ...]
#   ./scripts/em-dash-audit.sh path/to/vault           # recurse into directory
#   ./scripts/em-dash-audit.sh -c path/to/vault        # count only, one line per file
#
# Output:
#   <file>:<line>: <the offending line>
#   Final line: total hits.
#
# Expected false positives (review, don't blind-fix):
#   - Metalinguistic lines — prose *about* the dash
#   - Quoted or bibliographic source text, which keeps the source's punctuation
#
# Exit code:
#   0 if zero hits, 1 if any hits found (CI-friendly)
#
# Requires: bash, awk, find

set -u

COUNT_ONLY=0
if [[ "${1:-}" == "-c" ]]; then
  COUNT_ONLY=1
  shift
fi

if [[ $# -eq 0 ]]; then
  echo "usage: $0 [-c] <file.md|dir> [...]" >&2
  exit 2
fi

COUNTS=$(mktemp)
trap 'rm -f "$COUNTS"' EXIT

scan_one() {
  awk -v file="$1" -v count_only="$COUNT_ONLY" -v counts="$COUNTS" '
    NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; next }
    in_fm { if (/^---[[:space:]]*$/) in_fm = 0; next }
    /^[[:space:]]*```/ { in_code = !in_code; next }
    in_code { next }
    /[—–]/ && /[가-힣]/ {
      hits++
      if (!count_only) print file ":" NR ": " $0
    }
    END {
      if (hits > 0) {
        if (count_only) printf "%6d  %s\n", hits, file
        print hits >> counts
      }
    }
  ' "$1"
}

for target in "$@"; do
  if [[ -d "$target" ]]; then
    while IFS= read -r -d '' f; do
      scan_one "$f"
    done < <(find "$target" -type f -name '*.md' -print0)
  elif [[ -f "$target" ]]; then
    scan_one "$target"
  else
    echo "skip (not found): $target" >&2
  fi
done

total=$(awk '{ s += $1 } END { print s + 0 }' "$COUNTS")
echo "── total hits: $total"

[[ "$total" -eq 0 ]]
