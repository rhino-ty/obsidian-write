#!/usr/bin/env bash
#
# audit-vault.sh — Run the obsidian-write Stage 1 + CJK self-check
# across a whole Obsidian vault (or any markdown tree).
#
# Usage:
#   ./scripts/audit-vault.sh                          # audit current directory
#   ./scripts/audit-vault.sh /path/to/vault           # audit a specific path
#   ./scripts/audit-vault.sh -v /path/to/vault        # verbose (print every file checked)
#   ./scripts/audit-vault.sh -q /path/to/vault        # quiet (summary only)
#   ./scripts/audit-vault.sh --cjk-only /path/to/vault   # skip Stage 1 generic, run CJK checks only
#
# Output:
#   - For each file with breakage, prints: <file>:<line>: <matched content>
#   - Final summary: total files scanned, total hits per category
#
# Exit code:
#   0 if zero hits, non-zero if any hits found (CI-friendly)
#
# Requires: bash 4+, GNU grep with -P (Perl regex), awk, find

set -u

# ---- arg parsing ----
VAULT="."
VERBOSE=0
QUIET=0
CJK_ONLY=0

while (( "$#" )); do
  case "$1" in
    -v|--verbose) VERBOSE=1; shift ;;
    -q|--quiet)   QUIET=1; shift ;;
    --cjk-only)   CJK_ONLY=1; shift ;;
    -h|--help)
      grep -E '^# ' "$0" | sed 's/^# //'
      exit 0
      ;;
    *) VAULT="$1"; shift ;;
  esac
done

if [ ! -d "$VAULT" ]; then
  echo "Error: $VAULT is not a directory" >&2
  exit 2
fi

# ---- counters ----
total_files=0
total_hits_stage1_close=0
total_hits_stage1_open=0
total_hits_h1=0
total_hits_numbered=0
total_hits_cjk_close=0
total_hits_cjk_open=0
total_hits_cjk_korean_particle=0
hit_files=()

# ---- color (only if stdout is a terminal) ----
if [ -t 1 ]; then
  RED=$'\033[31m'
  YEL=$'\033[33m'
  GRN=$'\033[32m'
  RST=$'\033[0m'
else
  RED="" YEL="" GRN="" RST=""
fi

print_hit() {
  local label="$1" file="$2" output="$3"
  [ -z "$output" ] && return
  if [ "$QUIET" -eq 0 ]; then
    echo "${YEL}── ${label} in ${file} ──${RST}"
    echo "$output"
  fi
  hit_files+=("$file")
}

# ---- audit one file ----
audit_file() {
  local f="$1"
  total_files=$((total_files + 1))

  [ "$VERBOSE" -eq 1 ] && echo "checking $f"

  if [ "$CJK_ONLY" -eq 0 ]; then
    # Stage 1 (1) — closing-side break
    local h1
    h1=$(grep -nP '[\)\]"'\''\.,:;!?\$…—–]\*\*[가-힣A-Za-z0-9]' "$f" 2>/dev/null || true)
    if [ -n "$h1" ]; then
      total_hits_stage1_close=$((total_hits_stage1_close + $(echo "$h1" | wc -l)))
      print_hit "Stage1 closing-side break" "$f" "$h1"
    fi

    # Stage 1 (2) — opening-side break
    local h2
    h2=$(grep -nP '[가-힣A-Za-z0-9]\*\*["\(\[\$「『]' "$f" 2>/dev/null || true)
    if [ -n "$h2" ]; then
      total_hits_stage1_open=$((total_hits_stage1_open + $(echo "$h2" | wc -l)))
      print_hit "Stage1 opening-side break" "$f" "$h2"
    fi

    # Stage 1 (3) — h1 in body (excluding code blocks)
    local h3
    h3=$(awk -v file="$f" '
      /^```/ { in_code = !in_code; next }
      !in_code && /^# / { print file ":" NR ": " $0 }
    ' "$f" 2>/dev/null || true)
    if [ -n "$h3" ]; then
      total_hits_h1=$((total_hits_h1 + $(echo "$h3" | wc -l)))
      print_hit "h1 in body (forbidden)" "$f" "$h3"
    fi

    # Stage 1 (4) — numbered headers
    local h4
    h4=$(grep -nE '^##+ [0-9]+\. ' "$f" 2>/dev/null || true)
    if [ -n "$h4" ]; then
      total_hits_numbered=$((total_hits_numbered + $(echo "$h4" | wc -l)))
      print_hit "Numbered header" "$f" "$h4"
    fi
  fi

  # CJK extra checks (ref/cjk-language-extra-checks.md)
  # Check A — CJK closing-side break (extended)
  local cjk_a
  cjk_a=$(grep -nP '[\)\]"'\''\.,:;!?\$…—–。、」』]\*\*[\p{Hangul}\p{Hiragana}\p{Katakana}\p{Han}]' "$f" 2>/dev/null || true)
  if [ -n "$cjk_a" ]; then
    total_hits_cjk_close=$((total_hits_cjk_close + $(echo "$cjk_a" | wc -l)))
    print_hit "CJK closing-side break" "$f" "$cjk_a"
  fi

  # Check B — CJK opening-side break
  local cjk_b
  cjk_b=$(grep -nP '[\p{Hangul}\p{Hiragana}\p{Katakana}\p{Han}]\*\*["\(\[\$「『]' "$f" 2>/dev/null || true)
  if [ -n "$cjk_b" ]; then
    total_hits_cjk_open=$((total_hits_cjk_open + $(echo "$cjk_b" | wc -l)))
    print_hit "CJK opening-side break" "$f" "$cjk_b"
  fi

  # Check D — Korean academic gloss + particle (highest signal)
  local cjk_d
  cjk_d=$(grep -nP '\)\*\*(이|가|은|는|을|를|의|와|과|에|으로|에서|이다|이며|이고|하고|입니다)' "$f" 2>/dev/null || true)
  if [ -n "$cjk_d" ]; then
    total_hits_cjk_korean_particle=$((total_hits_cjk_korean_particle + $(echo "$cjk_d" | wc -l)))
    print_hit "Korean academic gloss + particle" "$f" "$cjk_d"
  fi
}

# ---- main loop ----
while IFS= read -r -d '' f; do
  audit_file "$f"
done < <(find "$VAULT" -type f -name '*.md' -print0 2>/dev/null)

# ---- summary ----
total_hits=$((total_hits_stage1_close + total_hits_stage1_open + total_hits_h1 + total_hits_numbered + total_hits_cjk_close + total_hits_cjk_open + total_hits_cjk_korean_particle))
unique_hit_files=0
if [ ${#hit_files[@]} -gt 0 ]; then
  unique_hit_files=$(printf '%s\n' "${hit_files[@]}" | sort -u | wc -l | tr -d ' ')
fi

echo
echo "${GRN}── Audit summary ──${RST}"
echo "Vault:                 $VAULT"
echo "Files scanned:         $total_files"
echo "Files with hits:       $unique_hit_files"
if [ "$CJK_ONLY" -eq 0 ]; then
  echo "Stage1 closing-side:   $total_hits_stage1_close"
  echo "Stage1 opening-side:   $total_hits_stage1_open"
  echo "h1 in body:            $total_hits_h1"
  echo "Numbered headers:      $total_hits_numbered"
fi
echo "CJK closing-side:      $total_hits_cjk_close"
echo "CJK opening-side:      $total_hits_cjk_open"
echo "Korean gloss+particle: $total_hits_cjk_korean_particle"
echo "${GRN}Total hits:            $total_hits${RST}"

if [ "$total_hits" -gt 0 ]; then
  echo
  echo "${RED}Fix references:${RST}"
  echo "  - SKILL.md §6 — safe-rewrite recipes"
  echo "  - SKILL.md §10 — full self-check procedure"
  echo "  - ref/emphasis-breakage-deep-dive.md — all 6 patterns + risky-char catalog"
  echo "  - ref/cjk-language-extra-checks.md — CJK-specific procedure"
  exit 1
fi

exit 0
