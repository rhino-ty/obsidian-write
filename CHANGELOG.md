# Changelog

All notable changes to obsidian-write are documented here. Format roughly follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning is informal — semver-like but no strict guarantees in the 0.x range.

## [Unreleased]

### Fixed
- `ref/obsidian-plugin-essentials.md` Linter section — corrected rule names. Earlier text referenced non-existent rule names (e.g., "Headings must start at heading level X", "Sort YAML keys", "Strict line breaks") that don't match what the actual [Obsidian Linter plugin](https://github.com/platers/obsidian-linter) ships. Replaced with the **exact rule names** organized by Linter's actual 7 categories (Headings / YAML / Footnote / Content / Spacing / Paste / General) plus per-rule ON/OFF + rationale. Also clarified that "Strict line breaks" is an Obsidian core editor setting, not a Linter rule — new users were searching Linter for it and not finding it

### Added
- `SKILL.md` §6 — new "Optional: Two-tier emphasis hierarchy" subsection. Opt-in policy that defines a 2-tier emphasis hierarchy (`**bold**` for *important* / scanning, `==highlight==` for *core* / crystallization) with explicit per-paragraph and per-section budgets (1~3 bold per paragraph; 0~1 highlight per section). Italic (`*x*` / `_x_`) is **banned in Korean prose** under this policy — Korean fonts render italic as a slanted glyph that adds visual noise without semantic gain, and the 2-tier hierarchy covers what italic would have signaled. English-only italic still allowed (book titles, foreign loanwords, deliberate English-prose stress). Mixed-language sentences with Korean as the matrix language → no italic; move the English term into bold or backticks instead. Boundary cases explicit: structural bold (`**기출X**:`, `**Q1:**`, table headers, callout-internal labels) is exempt from the L1 budget; no nesting between tiers (`**중요 ==핵심==**` and `==핵심 **강조**==` both forbidden — pick the higher tier); callout titles minimize emphasis (the callout itself is already visual separation). Activation is a one-line declaration in vault root `CLAUDE.md` (`Two-tier hierarchy ON (obsidian-write §6 Optional). Korean italic banned.`) — host skills (knou-note-writer, polymedia-review-skill, etc.) that delegate format authority here automatically inherit the policy
- `SKILL.md` §10 Stage 1 check (5) — Korean italic self-check (awk pipeline that strips `**bold**` first to avoid false-flagging single `*` inside `**...**`, then catches any remaining `*X*` on a line that also contains a Korean character, while respecting code-block toggling). Only meaningful when the §6 Two-tier hierarchy policy is ON, but harmless when OFF (zero hits in vaults that don't use Korean italic anyway). False positives possible in math/code-adjacent prose (`*x*²`); review hits manually
- `SKILL.md` Core/Recommended/Optional tier table — "Two-tier emphasis hierarchy (§6 Optional)" added to the Optional tier row alongside writing style §1, 5-axis tags §7, and PARA §8
- `ref/agent-context-files.md` — new write target for this skill: AI coding agent context files (CLAUDE.md, AGENTS.md, AGENT.md, .cursorrules, .codex.md, .windsurfrules, etc.) at vault root. Covers the agent context format catalog (which agent reads which file, scope inheritance, format), a vault-flavored 8-section template (Owner / Structure / Active projects / Conventions / Skills / Plugins / Voice / External), the convention-application matrix (heading depth + emphasis-flanking + §10 self-check apply; sticker + 5-axis tags + PARA path don't; numbered headers acceptable per the §3 exception), single-vs-many-file trade-offs with symlink strategy, and a worked CLAUDE.md skeleton. The motivation: every AI agent walking into an Obsidian vault re-discovers (or fails to discover) the vault's organizing system, conventions, installed skills, active plugins; a good agent context file calibrates the agent in 30 seconds
- `SKILL.md` §12 (new) — "Agent Context Files (separate reference)" — one-paragraph pointer to the new ref explaining the tailored-subset approach. Previous §12 Related Skills renumbered to §13. SKILL.md cross-references intentionally use section *content* names rather than numbers (per the delegation versioning rules) so this renumbering doesn't break delegating skills
- `ref/para-classification.md` — extracted from SKILL.md §8 PARA Classification. Adds material the inline §8 didn't have: PARA-vs-other-systems decision rules, what counts as Project vs Area vs Resource, migration tips for existing vaults, how PARA combines with the 5-axis tag model. SKILL.md §8 collapsed to a one-paragraph pointer
- `ref/delegation-for-skill-authors.md` — extracted from SKILL.md §9 Delegation Interface. Audience is *other skill authors* (developers of new Obsidian writing skills that delegate to this one), not regular skill users. Adds material §9 didn't have: detection signal *priority* (most-specific-first), versioning stability rules for the delegation contract, four common delegation mistakes with fixes, canonical reference paths. SKILL.md §9 collapsed to a one-paragraph pointer explicitly noting the audience is skill developers, not users
- `ref/obsidian-plugin-essentials.md` — per-plugin **verification step** added for all Required + Recommended tier plugins (Make.md, Dataview, Templater, Periodic Notes, Linter, Tasks, Tag Wrangler). Each verification includes domain-specific checks (does the Spaces panel appear? did the dataview block render as a list? did `<% tp.date %>` get replaced?) and failure-mode troubleshooting. Also adds a top-level "AI guidance pattern: install → verify → confirm" section documenting the 4-step pattern (explain why → install → verify → ask user to confirm) and explicitly warning about Obsidian's three silent-failure modes (installed but not enabled / enabled but missing follow-up setting / UI didn't refresh). The Linter ↔ §10 self-check overlap is reiterated in Linter's "Tell the user" guidance — new users tend to assume Linter "covers everything" and silently disable §10's CJK-specific grep
- `ref/obsidian-plugin-essentials.md` — first-time-user-friendly plugin guide. Three tiers: **Required** (Make.md, Dataview — without these, sticker frontmatter and typed-property dashboards don't render), **Recommended** (Templater, Periodic Notes, Linter, Tasks, Tag Wrangler — friction-removers that synergize with the conventions), **Compatible** (Excalidraw, Citations, Hover Editor, MetaEdit, Smart Connections, Advanced Tables, Outliner — install when you hit each one's specific pain point). Each entry answers what the plugin does, why a first-time user might want it, what pain it solves, who benefits most, relationship to this skill's sections, install + first-5-minutes setup, watch-outs. Includes a 4-stage progressive rollout plan (Day 1 / Week 2 / Month 2 / as-needed) so new users don't install 20 plugins on day one
- Explicit **Linter ↔ §10 self-check comparison table** in the plugin ref — Linter is broad GFM coverage (trailing whitespace, heading levels, frontmatter ordering) and this skill is CJK-emphasis-specific (the `**활용(exploitation)**과` case Linter doesn't know about). They complement; run both
- README plugin compatibility matrix — 14-row table sorted by tier, with "why install" one-liner and which SKILL.md section each plugin affects
- `SKILL.md` §11 expanded to include a one-paragraph pointer to the new plugin essentials ref alongside the syntax reference
- `ref/obsidian-syntax-reference.md` — full Obsidian Flavored Markdown catalog. Covers wikilinks (5 variations + disambiguation + aliases), block IDs (paragraph / list-item / quote placement), embeds (notes / sections / blocks / images with width+height / audio / video / PDF with page / query embeds), callouts (13 canonical types + alias mapping, collapse `-`/`+`, nesting, custom CSS), properties (Obsidian 1.4+ typed properties), inline tags (character rules), comments, highlight, math (MathJax 3.x + align environment), Mermaid (full type list + `class NodeName internal-link;` for vault-note linking), footnotes (standard + inline portability warning), task lists (GFM + Obsidian extensions + Tasks plugin syntax), strikethrough, HTML subset, Dataview integration. Verified against Obsidian 1.5+
- `SKILL.md` §11 (new) — "Obsidian-Specific Syntax (separate reference)" pointing to the syntax catalog. Previous §11 Related Skills renumbered to §12
- `SKILL.md` §6 — new "Same rule applies to `*`, `_`, and `==`" callout, noting that the CommonMark flanking rule applies to Obsidian's `==highlight==` delimiter too (substitute `=` for `*` in §10 Stage 1 grep to catch highlight breakage in CJK notes)
- `templates/` directory consolidated into `examples/` (each example file ends with a `## Minimal template to start from` section). No separate templates folder — this skill's conventions are medium-agnostic, so a single template per shape is redundant
- 4 new examples — `example-moc.md`, `example-folder-spec-note.md`, `example-daily-note.md`, `example-fix-before-after.md`
- `scripts/audit-vault.sh` — batch audit script wrapping Stage 1 + CJK extra grep checks across a whole vault, with `--cjk-only`, `-v` (verbose), `-q` (quiet) flags; CI-friendly exit code
- `CHANGELOG.md` (this file)
- GitHub repo topics (`obsidian`, `markdown`, `cjk`, `commonmark`, `korean`, `note-taking`, `zettelkasten`, `para-method`, `claude-skill`) for discoverability

### Changed
- `SKILL.md` description compressed (~65% shorter) so the system trigger index doesn't truncate the value proposition
- `SKILL.md` §3 exception note expanded to clarify that `examples/*.md` are GitHub documents that embed vault-note simulations — outer `# title` h1 is not a violation, the embedded note inside the fence still follows the full convention set

## [0.2.0] — 2026-06-05

### Added
- Full English rewrite (was Korean-only in 0.1)
- Output-language policy: convention text in English, notes produced follow the user's language
- 8-language trigger keywords (KO, EN, JA, ZH, ES, FR, DE, IT)
- Unicode-aware self-check grep using `\p{Han}`, `\p{Hiragana}`, `\p{Katakana}` property classes (was Hangul-only)
- `ref/emphasis-breakage-deep-dive.md` — CommonMark flanking spec walkthrough, per-parser behavior, full risky-character catalog, myth-busting
- `ref/cjk-language-extra-checks.md` — Korean / Japanese / Chinese-specific procedure with extra grep checks
- `examples/` — 4 worked vault-note examples (academic, essay, guide, tech-reference) each with conventions-applied commentary
- README — complete (npx install instructions, directory tree, ASCII usage flow, 8-language trigger keyword table, trigger-not-for section, model recommendation, Credits)

### Changed
- SKILL.md §3 — added exception note for this skill's own documents (numbered headers OK on GitHub-targeted docs)

## [0.1.0] — 2026-06-04

### Added
- Initial Korean release
- SKILL.md — 11-section convention SSoT (writing style, sticker frontmatter, heading, hr, indentation, emphasis-breakage, 5-axis tags, PARA, delegation interface, self-check, related skills)
- README.md — basic Korean-language overview
- LICENSE (MIT)
- `.gitignore`
- Delegation interface defined: vault signal `.claude/skills/obsidian-write/SKILL.md` lets other writing skills auto-defer for convention authority
- Companion skills configured for delegation: [polymedia-review-skill](https://github.com/rhino-ty/polymedia-review-skill), [review-myblog-converter](https://github.com/rhino-ty/review-myblog-converter)
