#!/usr/bin/env bash
#
# em-dash-audit.sh — Flag em dash / en dash / ASCII double-hyphen in Korean
# prose, per SKILL.md §6 (Optional: Korean punctuation policy).
#
# The policy is language-scoped: a dash is fine in English, banned in Korean.
# So the audit decides PER DASH, not per line. For each dash it looks at the
# nearest non-space token on either side; the dash counts as Korean only when
# one of those neighbours contains Hangul. A bibliographic line like
#
#   Bjork, R. A. & Bjork, E. L. (1992) — A New Theory of Disuse 를 참고했다.
#
# has `(1992)` and `A` around the dash, so it passes even though the line holds
# Korean elsewhere. Before v2 this was a line-level test and over-reported every
# such line.
#
# What is reported, by tag:
#   [dash]   unicode em/en dash in Korean prose        → real violation
#   [ascii]  `--` (two or more ASCII hyphens)          → the em dash in disguise
#   [both]   both on one line
#   [link]   dash inside a `[[wikilink]]`              → a FILENAME reference
#   [fname]  dash in the note's own Korean filename    → real violation
#
# [link] is reported, not suppressed — but it is tagged separately because it is
# NOT prose. It is a pointer at a file whose name contains a dash, and rewriting
# it breaks the link. This distinction is load-bearing: a bulk "fix" of these
# once broke 387 wikilinks across this vault, because the link text changed and
# the filenames did not. Never rewrite a [link] hit on its own. Fix the filename
# ([fname]) and let the rename update its referrers. Use --no-links to hide them
# once you have accepted the filenames as-is.
#
# [fname] is what actually surfaces a bad filename. Filenames were invisible to
# this script before v2 — it only ever read file CONTENTS.
#
# Frontmatter and fenced code blocks are excluded. For the ASCII check these are
# excluded too, because there `-` runs ARE real syntax:
#   - horizontal rules      (a line that is only `---`)
#   - table delimiter rows  (`|---|---|`)
#   - inline code           (`--save`, `--include`)
#   - HTML comments         (`<!-- ... -->`)
#   - markdown link targets (`](https://a/b--c)`)
#
# Usage:
#   ./scripts/em-dash-audit.sh <file.md> [file2.md ...]
#   ./scripts/em-dash-audit.sh path/to/vault           # recurse into directory
#   ./scripts/em-dash-audit.sh -c path/to/vault        # per-file counts, no line text
#   ./scripts/em-dash-audit.sh --no-ascii path/to/dir  # unicode dashes only
#   ./scripts/em-dash-audit.sh --no-links path/to/dir  # hide wikilink-interior hits
#   ./scripts/em-dash-audit.sh --no-fname path/to/dir  # skip the filename check
#   ./scripts/em-dash-audit.sh --only-fname path/to/dir # filenames only
#
# Output:
#   <file>:<line>: [tag] <the offending line>   (or "<count>  <file>" with -c)
#   <file>:0: [fname] <basename>                 for filename hits
#   Final block: per-tag totals.
#
# Expected false positives (review, don't blind-fix):
#   - Metalinguistic lines — prose *about* the dash
#   - Quoted or bibliographic source text, which keeps the source's punctuation
#   - Deliberate ASCII art or aligned tables written by hand
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
ASCII=1
LINKS=1
FNAME=1
ONLY_FNAME=0
while [[ $# -gt 0 ]]; do
  case "${1:-}" in
    -c)           COUNT_ONLY=1; shift ;;
    --no-ascii)   ASCII=0;      shift ;;
    --no-links)   LINKS=0;      shift ;;
    --no-fname)   FNAME=0;      shift ;;
    --only-fname) ONLY_FNAME=1; shift ;;
    *)            break ;;
  esac
done
export EMDASH_ASCII="$ASCII" EMDASH_LINKS="$LINKS"

if [[ $# -eq 0 ]]; then
  echo "usage: $0 [-c] [--no-ascii] [--no-links] [--no-fname] [--only-fname] <file.md|dir> [...]" >&2
  exit 2
fi

# ── Shared: is the dash at $pos in Korean context? ───────────────────────────
# Nearest non-space token on either side; Korean if either holds Hangul.
read -r -d '' KO_CONTEXT <<'PERL' || true
use Encode ();
# -CSD decodes STDIN/STDOUT/STDERR but NOT @ARGV, so a Korean path printed
# straight from $ARGV gets encoded twice and lands as mojibake. Decode it.
sub fname { return Encode::decode_utf8($_[0]) }
sub ko_context {
  my ($s, $pos, $len) = @_;
  my $left  = substr($s, 0, $pos);
  my $right = substr($s, $pos + $len);
  my ($lw) = $left  =~ /(\S+)\s*$/;
  my ($rw) = $right =~ /^\s*(\S+)/;
  $lw = '' unless defined $lw;
  $rw = '' unless defined $rw;
  return (($lw =~ /\p{Hangul}/) || ($rw =~ /\p{Hangul}/)) ? 1 : 0;
}
PERL

read -r -d '' FILTER <<'PERL' || true
if ($. == 1) { $code = 0; $fm = /^---\s*$/ ? 1 : 0; if ($fm) { close ARGV if eof; next } }
if ($fm) { $fm = 0 if /^---\s*$/; close ARGV if eof; next }
# Fence markers may sit inside a blockquote/callout (`> ```sql`), and nested
# quotes stack (`> > ```). Without tolerating the `>` prefix the toggle never
# fires and every line of a quoted code block is scanned as prose — which
# reported Mermaid `-->` arrows and SQL `--` comments as Korean violations.
if (m{^\s*(?:>\s*)*```}) { $code = !$code; close ARGV if eof; next }
if ($code) { close ARGV if eof; next }

my $raw = $_;
my $l = $_;
$l =~ s/`[^`]*`/' ' x length($&)/ge;     # inline code: --save, --include
$l =~ s/<!--.*?-->/' ' x length($&)/ge;  # HTML comment
$l =~ s/\]\([^)]*\)/' ' x length($&)/ge; # markdown link target
# NOTE: blanked in place, not deleted, so character offsets stay aligned with $raw.

# Wikilink interiors, as offset ranges.
my @links;
while ($l =~ /\[\[.*?\]\]/g) { push @links, [ $-[0], $+[0] ] }
my $in_link = sub {
  my $p = shift;
  for my $r (@links) { return 1 if $p >= $r->[0] && $p < $r->[1] }
  return 0;
};

my ($uni, $asc, $lnk) = (0, 0, 0);

while ($l =~ /[\x{2014}\x{2013}]/g) {
  my ($p, $len) = ($-[0], 1);
  next unless ko_context($l, $p, $len);
  if ($in_link->($p)) { $lnk = 1; next }
  $uni = 1;
}

if ($ENV{EMDASH_ASCII}
    && $l !~ /^\s*-{3,}\s*$/             # horizontal rule
    && $l !~ /^\s*\|[\s\-:|]+\|\s*$/) {  # table delimiter row
  while ($l =~ /-{2,}/g) {
    my ($p, $len) = ($-[0], $+[0] - $-[0]);
    next unless ko_context($l, $p, $len);
    next if $in_link->($p);
    $asc = 1;
  }
}

$lnk = 0 unless $ENV{EMDASH_LINKS};

if ($uni || $asc || $lnk) {
  my $tag = $uni ? ($asc ? 'both' : 'dash') : ($asc ? 'ascii' : 'link');
  $tag = 'link' if !$uni && !$asc;
  print fname($ARGV) . ":$.: [$tag] $raw";
}
close ARGV if eof;
PERL

# ── Collect files ────────────────────────────────────────────────────────────
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

# ── Content pass ─────────────────────────────────────────────────────────────
hits=""
if [[ "$ONLY_FNAME" -eq 0 ]]; then
  hits=$(printf '%s\0' "${files[@]}" | xargs -0 -n 200 perl -CSD -ne "$KO_CONTEXT$FILTER")
fi

# ── Filename pass ────────────────────────────────────────────────────────────
fhits=""
if [[ "$FNAME" -eq 1 || "$ONLY_FNAME" -eq 1 ]]; then
  # NOTE: whole-stem judgment here, NOT the per-dash ko_context() used for prose.
  # A prose line can hold an English clause, so the dash there needs local
  # context. A filename is one short title, so `회독 1 — CORE (1·2·3·4강)` is a
  # Korean name even though the dash sits between `1` and `CORE`. Segment logic
  # let five such names through; whole-stem catches them and still passes a
  # genuinely English name like `Note — English Only.md`.
  fhits=$(printf '%s\n' "${files[@]}" | perl -CSD -ne '
    chomp;
    my $path = $_;
    my $base = $path; $base =~ s{.*/}{};
    my $stem = $base; $stem =~ s/\.md$//;
    print "$path:0: [fname] $base\n"
      if $stem =~ /[\x{2014}\x{2013}]/ && $stem =~ /\p{Hangul}/;
  ')
fi

all=$(printf '%s\n%s' "$hits" "$fhits" | grep -v '^$' || true)

total=0
if [[ -n "$all" ]]; then
  total=$(printf '%s\n' "$all" | wc -l | tr -d ' ')
  if [[ "$COUNT_ONLY" -eq 1 ]]; then
    printf '%s\n' "$all" | perl -CSD -ne 's/:\d+:.*\n?$//; print "$_\n"' \
      | sort | uniq -c | sort -rn
  else
    printf '%s\n' "$all"
  fi
fi

# ── Per-tag summary ──────────────────────────────────────────────────────────
if [[ -n "$all" ]]; then
  echo "──"
  for t in dash ascii both link fname; do
    n=$(printf '%s\n' "$all" | grep -c "\[$t\]" || true)
    [[ "$n" -gt 0 ]] && printf '   %-6s %s\n' "$t" "$n"
  done
  if printf '%s\n' "$all" | grep -q '\[link\]'; then
    echo "──"
    echo "   note: [link] hits are filename references, not prose."
    echo "         Never rewrite them on their own — that breaks the link."
    echo "         Fix the [fname] and let the rename update referrers."
  fi
fi
echo "── total hits: $total"
[[ "$total" -eq 0 ]]
