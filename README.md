# obsidian-write

> Single Source of Truth (SSoT) skill for writing and editing Obsidian vault notes.
> Heading (h2~h4) · horizontal-rule placement · indentation · **CommonMark flanking emphasis-breakage guard (CJK-optimized)** · sticker frontmatter · 5-axis tag model · PARA classification · post-write grep self-check.

[![Made with](https://img.shields.io/badge/Made%20with-Claude%20Skills-blueviolet)](https://docs.claude.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![CJK optimized](https://img.shields.io/badge/CJK-optimized-blue)](#why-cjk-authors-care-the-most)
[![Languages](https://img.shields.io/badge/Triggers-8%20languages-blueviolet)](#trigger-keywords)
[![한국어 README](https://img.shields.io/badge/%ED%95%9C%EA%B5%AD%EC%96%B4-README.ko.md-red)](README.ko.md)

---

## What this skill does

Every Obsidian note-author re-applies the same set of micro-decisions on every file: which heading level to start at, where to place horizontal rules, how to write tags, how to keep bold from breaking. This skill packages those decisions in one authoritative place so:

1. **You stop re-deciding.** Open the file, follow the conventions, run the self-check, save.
2. **Other writing skills delegate to it.** Review-note skills, lecture-note skills, future writing skills — all defer convention authority here when they detect the vault signal `.claude/skills/obsidian-write/SKILL.md`.
3. **CJK authors get a real fix for emphasis breakage**, not just "be careful with bold."

It is **opinionated but layered** — Core conventions every Obsidian user benefits from, Recommended layers for specific setups (Make.md, CJK), Optional for personal operational policy (PARA, 5-axis tags).

## Output language follows the user

This skill is **convention infrastructure**, not a content generator. The conventions are written in English so any audience can read them, but **the notes you produce follow the user's language**.

- Korean request → Korean note (CJK emphasis-breakage procedure kicks in)
- English request → English note
- Japanese / Chinese → same as Korean (CJK procedure applies)
- Mixed → dominant language drives, per-segment checks run as needed

Never translate the user's content into English just because the conventions are in English.

## Why CJK authors care the most

CommonMark's flanking rule means `**bold**` breaks when punctuation sits *inside* the delimiters and a word character sits *outside* with no whitespace. In English this happens occasionally:

```
❌ word**"text"**here       ← breaks
✅ word "**text**" here
```

In Korean / Japanese / Chinese this happens **constantly**, because particles, postpositions, and joining characters attach to `**` without whitespace:

```
❌ **활용(exploitation)**과     ← Korean closing-particle attaches to `)**`
✅ **활용**(exploitation)과     ← keep only the Korean term bold; gloss outside
```

This skill:
- Captures the master rule in one line + 6 breakage patterns + universal fix
- Ships a CJK-specific extra procedure (`ref/cjk-language-extra-checks.md`)
- Includes a post-write grep 4-pack that catches the high-confidence breakages

## Core feature list

- **Convention SSoT** — Heading depth · horizontal rule · indentation · emphasis · sticker · tags · PARA, all in one file
- **Tiered adoption** — Core / Recommended / Optional; take what fits, ignore what doesn't
- **CJK emphasis-breakage guard** — Master rule + 6 patterns + safe rewrites + grep 4-pack
- **Delegation interface** — Vault signal lets other writing skills auto-defer (no manual coordination needed)
- **Post-write self-check** — Stage 1 narrow grep (high confidence) + Stage 2 wide flanking grep (advisory) + Stage 3 hr placement
- **Worked examples** — Four medium-typical Obsidian notes (academic, essay, guide, technical reference) you can clone
- **Reference material** — Deep-dive on CommonMark flanking + per-parser behavior + CJK-specific procedure

## Directory structure

```
obsidian-write/
├── SKILL.md                              # 11-section convention SSoT + self-check
├── README.md                             # this file
├── LICENSE                               # MIT
├── ref/
│   ├── emphasis-breakage-deep-dive.md    # CommonMark flanking spec walkthrough +
│   │                                       per-parser behavior + full risky-char catalog +
│   │                                       myth-busting (smart quotes, live-preview, `_..._`)
│   ├── cjk-language-extra-checks.md      # Korean/Japanese/Chinese-specific procedure —
│   │                                       when to run, what to check, why CJK is different
│   ├── obsidian-syntax-reference.md      # Obsidian Flavored Markdown catalog —
│   │                                       wikilinks, block IDs, embeds, callouts (full type list),
│   │                                       properties, comments, highlight, math, mermaid,
│   │                                       footnotes, task list extensions, HTML subset
│   └── obsidian-plugin-essentials.md     # Plugin guide for first-time users — Required /
│                                           Recommended / Compatible tiers with "why install"
│                                           rationale, 4-stage rollout plan, Linter ↔ §10
│                                           overlap analysis
└── examples/
    ├── example-academic-note.md          # Course / study note (e.g., university lecture)
    ├── example-essay.md                  # Reflective essay (e.g., self-analysis)
    ├── example-guide.md                  # How-to / walkthrough (e.g., game / tooling guide)
    └── example-tech-reference.md         # Analytical reference (e.g., framework deep-dive)
```

## Installation

```bash
npx skills add rhino-ty/obsidian-write
```

[vercel-labs/skills](https://github.com/vercel-labs/skills) CLI pulls the SKILL.md from this GitHub repo and installs it into Claude Code, Cursor, Codex, and other supported agents. Options:

- `-g` / `--global` — install at user level (available across all your projects)
- `-a <agent>` — install into a specific agent only (e.g., `claude-code`)
- `--all` — auto-accept + install into every detected agent

> **Companion skills (recommended for full review/blog flow)**:
> ```bash
> npx skills add rhino-ty/polymedia-review-skill
> npx skills add rhino-ty/review-myblog-converter
> ```

## Usage flow

```
User writes / edits a .md note in an Obsidian vault
  ↓
obsidian-write triggers (or is delegated to by another skill)
  ↓
Apply Core conventions (Heading § Horizontal-rule § Indentation § Emphasis)
  ↓
Apply Recommended where applicable (CJK procedure if Korean/Japanese/Chinese; sticker if Make.md)
  ↓
Apply Optional per user policy (PARA path, 5-axis tags, ADR-style writing)
  ↓
Write/Edit the file
  ↓
Post-write self-check (Stage 1 mandatory; Stage 2/3 advisory)
  ↓
Pass → report done.  Hits → fix per §6 patterns, re-run, then report.
```

## Trigger phrases (examples)

- "Format this note according to Obsidian conventions"
- "Did my bold break anywhere?"
- "Run self-check on this file"
- "Write a new note on \<topic\>" (within a vault)
- Any other writing skill firing inside the vault — this skill is auto-delegated

### Trigger keywords

The skill triggers in **8 languages**. Speak in your own language.

| Language | Keywords |
|---|---|
| 🇰🇷 한국어 | 옵시디언, 옵시디언 노트, 노트 작성, 강조 깨짐, 볼드 깨짐, 헤더 규칙, 태그 5축, sticker, 스티커, frontmatter, PARA, vault 컨벤션, self-check, 의사결정 기록, ADR |
| 🇺🇸 English | obsidian, obsidian write, note convention, markdown convention, emphasis breakage, bold breakage, heading rule, tag axis, frontmatter sticker, vault convention, self-check, PARA, ADR |
| 🇯🇵 日本語 | オブシディアン, ノート作成, マークダウン, 強調が壊れる, 太字が壊れる, 見出し, タグ, バルト規約, セルフチェック |
| 🇨🇳 中文 | Obsidian, 笔记写作, 笔记规范, 强调失效, 加粗失效, 标题, 标签, Vault 规范, 自查 |
| 🇪🇸 Español | obsidian, nota, convención de notas, énfasis roto, encabezado, etiqueta |
| 🇫🇷 Français | obsidienne, note, convention, gras cassé, en-tête, étiquette |
| 🇩🇪 Deutsch | obsidian, notiz, konvention, hervorhebung gebrochen, überschrift, tag |
| 🇮🇹 Italiano | obsidian, nota, convenzione, grassetto rotto, intestazione, etichetta |

### Does **not** trigger for

- Plain markdown outside an Obsidian vault (this skill is vault-specific)
- Interactive visualizations / `dataviewjs` widgets (use a visualization-focused skill)
- Authoring a review note itself — use [polymedia-review-skill](https://github.com/rhino-ty/polymedia-review-skill); it delegates to this skill for format
- Authoring a lecture note itself — use a domain-specific lecture-note skill; it delegates here
- Logseq / Notion / Bear / plain markdown ecosystems (different convention sets)
- "Convert my note to a blog post" — use [review-myblog-converter](https://github.com/rhino-ty/review-myblog-converter)

## Plugin compatibility matrix

Obsidian itself is minimal — most of this skill's value materializes once you've installed a few specific plugins. The matrix below sorts them into three tiers; full installation order, "why install each one", and a 4-stage rollout plan for first-time users are in [`ref/obsidian-plugin-essentials.md`](ref/obsidian-plugin-essentials.md).

| Plugin | Tier | Why install | Skill section affected |
|---|---|---|---|
| **Make.md** | 🔴 Required | Renders `sticker: emoji//{hex}` as actual icons; folder spec note UI | SKILL.md §2 + folder-spec example |
| **Dataview** | 🔴 Required | Makes frontmatter properties queryable; powers in-vault dashboards | SKILL.md §5 typed properties |
| **Templater** | 🟡 Recommended | Automates the `## Minimal template` blocks in `examples/`. Two keystrokes vs. two minutes per new note | All `examples/` |
| **Periodic Notes** | 🟡 Recommended | Auto-creates daily / weekly / monthly notes by date; enables sustainable journaling | `example-daily-note.md` |
| **Linter** | 🟡 Recommended | Auto-formats markdown on save. **Complements** §10 self-check — Linter is broad GFM coverage, this skill is CJK emphasis-specific. Run both, not one or the other | §10 (see plugin ref for full comparison table) |
| **Tasks** | 🟡 Recommended | Surfaces `- [ ]` checkboxes across the vault as queryable task lists with due-date/priority | `syntax-reference §12` |
| **Tag Wrangler** | 🟡 Recommended | Bulk-rename and merge tags. Without it, §7's "quarterly pruning" is impractical and the 5-axis tag model decays | §7 operating principles |
| **Excalidraw** | 🟢 Compatible | Hand-drawn unstructured diagrams (where Mermaid feels too rigid) | Independent |
| **Citations** | 🟢 Compatible | Zotero integration for academic literature notes | `example-tech-reference.md` pattern |
| **Hover Editor** | 🟢 Compatible | Inline preview + edit of wikilinked notes — fastens MOC traversal | `example-moc.md` workflow |
| **MetaEdit / Metadata Menu** | 🟢 Compatible | UI for editing frontmatter properties without typing YAML | §5 typed properties |
| **Smart Connections** | 🟢 Compatible | AI-suggested related notes via embedding similarity | Discovery side of Zettelkasten |
| **Advanced Tables** | 🟢 Compatible | Spreadsheet-like editing of markdown tables | §1.5 comparative analysis tables |
| **Outliner** | 🟢 Compatible | Logseq-style outline manipulation | `example-essay.md` outlines |

**Don't install everything on day 1.** The plugin ref documents a 4-stage rollout — Day 1 (Required), Week 2 (Templater + Periodic Notes), Month 2 (Tag Wrangler + Linter), then add others only when you feel the specific friction each one addresses. See [`ref/obsidian-plugin-essentials.md`](ref/obsidian-plugin-essentials.md) for the rationale of each plugin and a "first 5 minutes" setup for the Required and Recommended tiers.

## Model recommendation

This skill is mostly *rule application + grep*, so it's tolerant of lighter models. But it includes judgment calls (when does a Stage 2 hit count as a real break? which axis does a tag fall under?) that benefit from stronger reasoning when the note is complex.

- ✅ Strong: Claude Opus / Sonnet 4.6+ · Gemini 2.5 Pro · GPT-o3 — for complex notes, ambiguous tag axis decisions, CJK + Latin mixed segments
- ✅ Acceptable: Claude Haiku 4.5+ · GPT-4o-mini — for simple notes and pure mechanical self-check
- ❌ Avoid: heavily quantized local models that mis-handle Unicode regex

## License

MIT. See [LICENSE](LICENSE).

## Credits

- **CommonMark spec** — the flanking rule that this skill ultimately codifies
- **Niklas Luhmann's Zettelkasten** — the "tags as the weakest connector" intuition behind the 5-axis model (§7)
- **Tiago Forte — PARA Method** — the optional folder classification (§8)
- **Andy Hunt & David Thomas — *The Pragmatic Programmer*** — the ADR-style decision logging spirit (§1)
- **Make.md plugin** — the `sticker: emoji//{hex}` frontmatter convention (§2)
- **Companion skills** — [polymedia-review-skill](https://github.com/rhino-ty/polymedia-review-skill) · [review-myblog-converter](https://github.com/rhino-ty/review-myblog-converter)
