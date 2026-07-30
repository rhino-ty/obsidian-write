#!/usr/bin/env bash
#
# em-dash-audit.sh — Flag em dash / en dash in Korean prose, per SKILL.md §6
# (Optional: Korean punctuation policy).
#
# Reports any line that contains `—` or `–` AND a Korean character.
# Frontmatter and fenced code blocks are excluded.
#
# Usage:
#   ./scripts/em-dash-audit.sh <file.md> [file2.md ...]
#   ./scripts/em-dash-audit.sh path/to/vault           # recurse into directory
#   ./scripts/em-dash-audit.sh -c path/to/vault        # per-file counts, no line text
#
# Output:
#   <file>:<line>: <the offending line>       (or "<count>  <file>" with -c)
#   Final line: total hits.
#
# Expected false positives (review, don't blind-fix):
#   - Metalinguistic lines — prose *about* the dash
#   - Quoted or bibliographic source text, which keeps the source's punctuation
#
# Exit code:
#   0 if zero hits, 1 if any hits found (CI-friendly)
#
# Requires: bash, perl (5.8+), find
#
# WHY PERL AND NOT AWK: BSD awk (macOS, "awk version 2020xxxx") evaluates the
# bracket range [가-힣] byte-wise, so it also matches continuation bytes of
# unrelated multibyte characters — including the em dash itself. Every line
# holding a dash then looks Korean and the audit over-reports wildly. GNU awk in
# a UTF-8 locale handles it correctly, which is precisely why the bug survives
# review on Linux and only bites macOS users. Perl with -CSD decodes to
# characters first, so \p{Hangul} is right on every platform.
#
# The `close ARGV if eof` at the end of the filter is load-bearing: without it
# `$.` keeps counting across files, so the `$. == 1` frontmatter test never fires
# again and the code-fence toggle leaks across file boundaries.

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

read -r -d '' FILTER <<'PERL' || true
if ($. == 1) { $code = 0; $fm = /^---\s*$/ ? 1 : 0; if ($fm) { close ARGV if eof; next } }
if ($fm) { $fm = 0 if /^---\s*$/; close ARGV if eof; next }
if (m{^\s*```}) { $code = !$code; close ARGV if eof; next }
if ($code) { close ARGV if eof; next }
print "$ARGV:$.: $_" if /[\x{2014}\x{2013}]/ && /\p{Hangul}/;
close ARGV if eof;
PERL

files=()
for target in "$@"; do
  if [[ -d "$target" ]]; then
    while IFS= read -r -d '' f; do files+=("$f"); done \
      < <(find "$target" -type f -name '*.md' -print0)
  elif [[ -f "$target" ]]; then
    files+=("$target")
  else
    echo "skip (not found): $target" >&2
  fi
done

if [[ ${#files[@]} -eq 0 ]]; then
  echo "── total hits: 0"
  exit 0
fi

hits=$(printf '%s\0' "${files[@]}" | xargs -0 -n 200 perl -CSD -ne "$FILTER")
total=0
if [[ -n "$hits" ]]; then
  total=$(printf '%s\n' "$hits" | wc -l | tr -d ' ')
  if [[ "$COUNT_ONLY" -eq 1 ]]; then
    printf '%s\n' "$hits" | perl -CSD -ne 's/:\d+:.*\n?$//; print "$_\n"' \
      | sort | uniq -c | sort -rn
  else
    printf '%s\n' "$hits"
  fi
fi

echo "── total hits: $total"
[[ "$total" -eq 0 ]]
