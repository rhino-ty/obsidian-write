# Changelog

All notable changes to obsidian-write are documented here. Format roughly follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning is informal — semver-like but no strict guarantees in the 0.x range.

## [Unreleased]

### Added
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
