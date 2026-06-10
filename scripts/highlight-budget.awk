#!/usr/bin/awk -f
#
# highlight-budget.awk — Count ==highlight== occurrences per leaf section
# and flag sections that exceed the budget defined in SKILL.md §6
# (Quantitative highlight budget variant).
#
# Called by scripts/highlight-budget.sh — see that file for usage.

BEGIN {
  in_fm = 0; in_code = 0
  cur_level = 0; cur_count = 0; cur_line = 0; cur_header = ""
  over_total = 0
}

# YAML frontmatter — only when leading the file
NR == 1 && $0 == "---" { in_fm = 1; next }
in_fm { if ($0 == "---") in_fm = 0; next }

# Fenced code blocks — ignore content inside ```
/^```/ { in_code = !in_code; next }
in_code { next }

# Compare-and-flush helper. Called on every new header and at EOF.
function emit(next_level,    budget) {
  if (cur_header == "") return
  if (next_level > cur_level) {
    budget = 1                                  # parent-lead (has child headers)
  } else if (cur_level >= 4) {
    budget = 3                                  # h4+ leaf
  } else if (cur_level == 3) {
    budget = 4                                  # h3 leaf
  } else {
    budget = 5                                  # h2 (or h1) leaf
  }
  if (cur_count > budget) {
    printf "%s:%d  %s  (==%d > budget %d)\n",
      FILENAME, cur_line, cur_header, cur_count, budget
    over_total++
  }
}

function start_header(level) {
  emit(level)
  cur_level = level
  cur_count = 0
  cur_line = NR
  cur_header = $0
}

/^#### / { start_header(4); next }
/^### /  { start_header(3); next }
/^## /   { start_header(2); next }
/^# /    { start_header(1); next }

# Body line — count ==...== occurrences
{
  s = $0
  while (match(s, /==[^=]+==/)) {
    cur_count++
    s = substr(s, RSTART + RLENGTH)
  }
}

END {
  emit(0)                                       # last section is always leaf
  exit (over_total > 0 ? 1 : 0)
}
