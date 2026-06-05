---
name: obsidian-write
description: >
  Single Source of Truth (SSoT) skill for writing and editing notes in an
  Obsidian vault. Enforces a coherent set of conventions:
  Heading (h2~h4, no h1) + horizontal rule (`---` between h2 sections only)
  + indentation (Tab) + emphasis-breakage guard (CommonMark flanking rule)
  + sticker frontmatter (Make.md compatible) + 5-axis tag model
  (Status / Type / Domain / Topic / Context) + PARA classification.
  Post-write grep self-check (4 patterns) catches the most common Obsidian
  rendering breakage before you save.

  Opinionated skill — one Obsidian user codified the conventions they
  validated in their own vault. Particularly valuable for CJK
  (Korean / Japanese / Chinese) note authors: bold/italic markup is far more
  fragile in those languages because particles, postpositions, and joining
  characters attach to `**` without whitespace. This skill ships a dedicated
  procedure for that, see `ref/cjk-language-extra-checks.md`.

  Other Obsidian writing skills (polymedia-review-skill, knou-note-writer,
  future skills) can delegate convention authority to this skill when they
  detect the vault signal `.claude/skills/obsidian-write/SKILL.md`. That
  delegation interface is defined in §9.

  Output language follows the user's language. If the user requests a note
  in Korean, this skill produces a Korean note; English request, English
  note; and so on. The conventions (heading, tags, emphasis) are
  language-agnostic except where CJK-specific procedures kick in (§10).

  ALWAYS trigger when:
  (1) Creating a new .md note inside an Obsidian vault
  (2) Editing an existing .md note in ways that may violate conventions
      (heading depth, emphasis, tags, sticker, hr placement)
  (3) Another writing skill triggers inside the vault — this skill is
      auto-delegated as the convention authority for the output note
  (4) User asks for "note convention check", "emphasis breakage check",
      "self-check", "format validation"

  Triggers (Korean):
  옵시디언, 옵시디언 노트, 노트 작성, 노트 편집, 마크다운 작성, 강조 깨짐,
  볼드 깨짐, 헤더 규칙, 헤딩, 태그 5축, sticker, 스티커, frontmatter,
  PARA, vault 컨벤션, 볼트 컨벤션, self-check, 포맷 검증, 노트 검증,
  의사결정 기록, ADR

  Triggers (English):
  obsidian, obsidian write, obsidian note, note convention,
  markdown convention, emphasis breakage, bold breakage, heading rule,
  tag axis, frontmatter sticker, vault convention, self-check,
  format validation, PARA method, ADR

  Triggers (Japanese):
  オブシディアン, ノート作成, マークダウン, 強調が壊れる, 太字が壊れる,
  見出し, タグ, バルト規約, セルフチェック

  Triggers (Chinese):
  Obsidian, 笔记写作, 笔记规范, 强调失效, 加粗失效, 标题, 标签,
  Vault 规范, 自查

  Triggers (Spanish / French / German / Italian):
  obsidian, nota, convención, énfasis roto, encabezado, etiqueta,
  obsidienne, gras cassé, en-tête, étiquette,
  obsidian, hervorhebung gebrochen, überschrift, tag,
  obsidian, grassetto rotto, intestazione, etichetta

  Do NOT trigger for:
  - General markdown writing outside an Obsidian vault (this skill is
    vault-specific)
  - Interactive visualizations (use a dataviewjs-focused skill)
  - Review-note authoring itself (polymedia-review-skill owns that workflow;
    it delegates to this skill for convention enforcement)
  - Lecture-note authoring itself (knou-note-writer owns that workflow;
    it delegates to this skill for emphasis-breakage / heading checks)
  - Logseq · Notion · Bear · plain markdown (each ecosystem has its own
    conventions; this skill is Obsidian-only)
---

# obsidian-write — Obsidian Vault Writing Convention SSoT

> A single authoritative document for repeatedly-applied decisions when writing Obsidian notes: heading depth, emphasis-breakage rule, 5-axis tags, sticker frontmatter, PARA classification. Other writing skills delegate to this file as the convention authority via a vault signal.

## Quick Map

| Scenario | What happens |
|---|---|
| User writes a new `.md` directly in the vault | This skill's full conventions apply + post-write grep self-check |
| User edits an existing `.md` (heading / emphasis / tag changes) | Conventions applied to the changed region + verification of touched area |
| Another skill (polymedia / knou-note-writer / etc.) triggers in the vault | That skill owns its workflow (interview, lecture analysis); *format conventions* of the produced note are delegated here |
| Outside the vault (plain markdown / Logseq / Notion / Bear) | This skill is inactive — host skill applies its own generic-markdown case |

## Core vs Recommended vs Optional

| Tier | Items | Apply when |
|---|---|---|
| **Core** (all Obsidian users) | Heading (§3) · Horizontal rule (§4) · Indentation (§5) · Emphasis-breakage rule (§6) | Always in Obsidian |
| **Recommended** (CJK authors) | CJK-specific emphasis-breakage procedure (§10 + `ref/cjk-language-extra-checks.md`) | Note is written in Korean, Japanese, Chinese, or mixed CJK + Latin |
| **Recommended** (Make.md or folder emoji users) | Sticker frontmatter (§2) | Make.md plugin or folder-emoji management is in use |
| **Optional** (your operational policy) | Writing style §1 · 5-axis tags §7 · PARA §8 | Your vault adopts these specific patterns |

Adopting only the four core items already eliminates almost all Obsidian rendering breakage. The rest is *opinionated* — patterns one user validated in their own vault. Take them if they fit; ignore if not.

---

## Output Language Policy

This skill is convention infrastructure, not a content generator. The convention text in this file is in English so any audience can read it, but **the notes you produce follow the user's language**.

- User writes in Korean → produce Korean notes. CJK emphasis-breakage procedure (§10) kicks in.
- User writes in English → produce English notes. CJK procedure is skipped (or run as a sanity pass anyway, since it's cheap).
- User writes in Japanese / Chinese → same as Korean. CJK procedure applies.
- User mixes languages → the dominant language drives §10; mixed segments run the relevant checks per language.

**Never translate the user's content into English just because this skill is in English.** Conventions are language-agnostic; voice and substance stay in the user's language.

---

## 1. Writing Style (Decision Logging)

1. **Record the why, not just the what** — conclusions decay without their reasoning. Six months later you should still see *why* you chose this path.
2. **ADR-style structure** — Context → Decision → Rationale → Consequences. Use this for any non-trivial decision recorded in a note.
3. **TODO markers** — Mark unresolved items with `TODO:` so they grep cleanly.
4. **Preserve deprecated decisions** — Use ~~strikethrough~~ rather than deleting, so the historical context survives.
5. **Tables for comparative analysis** — Markdown tables for trade-off matrices, not prose lists.
6. **Inline personal commentary** — Drop your own thinking, doubts, half-formed reactions into the note. Notes are for you, not for an audience.

> A note that only states the final decision is a dead artifact. A note that captures the deliberation is a living tool.

---

## 2. Frontmatter (Sticker / Folder Emoji)

**Note emoji**: Don't put emoji in the filename. Put it in frontmatter `sticker` using Make.md compatible format:

```yaml
---
sticker: emoji//{unicode-codepoint(lowercase hex)}
---
```

Examples:
- `sticker: emoji//1f48a` → 💊
- `sticker: emoji//1f34a` → 🍊
- `sticker: emoji//1f4d6` → 📖 (book)
- `sticker: emoji//1f3ae` → 🎮 (game)
- `sticker: emoji//1f3ac` → 🎬 (movie)
- `sticker: emoji//1f3b5` → 🎵 (music)
- `sticker: emoji//1f9e0` → 🧠 (thinking / essay)
- `sticker: emoji//1f4d8` → 📘 (academic note)

**Folder emoji**: Don't put emoji in the folder name (sync / cross-platform breakage). Use the `.md` file that shares the folder's name (a "folder spec note") and put sticker in its frontmatter:

```yaml
---
_filters: []
sticker: emoji//1f48a
color: ""
---
```

The folder spec note doubles as a place to record what the folder is *for* — directory README-style context.

---

## 3. Heading Rules

Obsidian's *Inline Title* renders the filename as h1. Using h1 in the body produces a duplicate title. Therefore:

- Body starts at **h2 (`##`)**
- Body ends at **h4 (`####`)** maximum
- `h1` (`#`) is **forbidden in the body**

```markdown
##(h2)  — main section
###(h3) — subsection
####(h4) — detail
```

Deeper hierarchy: use `**bold labels**` inside the body. Don't create h5 / h6.

**No numbered headers**: `## 1. Topic` ❌ → `## Topic` ✅. Outline view gets cluttered with numbers and reordering breaks them.

> This diverges from the CommonMark MD041 lint, but Obsidian is the deployment target — in-vault readability beats portability here.

> **Exception for skill documents**: This skill's own files (`SKILL.md`, `README.md`, `ref/*.md`) use numbered headers (`## 1. Title`) because they're primarily consumed on GitHub where numbered section scanability outweighs Obsidian-outline concerns. The convention applies to *vault notes you write*, not to convention documents that ship to external consumers — `examples/*.md` simulate vault notes and therefore avoid numbered headers themselves.

---

## 4. Horizontal Rule (`---`)

`---` is **only used between h2 sections**. Never between h3s — they're siblings under the same h2 context, separated by blank lines.

```markdown
## H2 Section A
... content ...

### H3 sub A-1
... content ...

### H3 sub A-2
... content ...

---

## H2 Section B
```

Exception: frontmatter delimiters at top of file.

---

## 5. Indentation

List sub-items use **tabs**, not spaces. Obsidian's behaviors (toggle, fold, drag) are tab-based:

```markdown
- Top-level item
	- Second level (1 tab)
		- Third level (2 tabs)
```

---

## 6. Emphasis (`**`, `*`, `_`) — CommonMark Flanking Rule

> The **single most important rule** for CJK note authors. Bold/italic markup breaks far more often in CJK text than in Latin text because of how particles attach to words.

### Master Rule (one line)

> **If the character immediately inside `**` is not a letter (Han / Latin / digit), it's at risk.** Whitespace, line-start, or line-end on the outside saves it.

Verified consistent across three parsers (cmark · markdown-it · @lezer/markdown). Direct consequence of CommonMark's flanking rule.

### When it breaks

Both conditions must hold simultaneously:
1. **Outside** the `**` has a word character (Han / Latin / digit) attached *without whitespace*
2. **Inside** the `**` (right against the delimiter) has Unicode punctuation: `"` `'` `(` `)` `.` `,` `:` `—` `!` `?` `;` `$`

**Either delimiter alone is enough to kill the entire bold.** Opening and closing delimiters are judged independently.

### Quick examples (CJK / Korean — the worst case)

```
❌ **활용(exploitation)**과     ← closing ** preceded by `)`, followed by Korean particle `과`
✅ **활용**(exploitation)과     ← keep only the Korean term bold; English gloss outside

❌ 이건**"한 우물 파기"**이다  ← both sides break
✅ 이건 "**한 우물 파기**" 이다  ← punctuation outside the bold

❌ **결론적으로,**이렇게       ← closing ** preceded by `,`, followed by `이`
✅ **결론적으로**, 이렇게      ← comma outside
```

### Quick examples (English — happens but rarer)

```
❌ word**"text"**here           ← both sides break (no whitespace + punct inside)
✅ word "**text**" here

❌ conclusion**(note)**follows  ← same pattern
✅ conclusion (**note**) follows
```

### Universal fix

Put `**` so that the character immediately inside is a letter. If you need punctuation adjacent to bold, move it outside or extend the bold to include the particle.

### Deep-dive

See `ref/emphasis-breakage-deep-dive.md` for:
- Full CommonMark flanking spec walkthrough
- Per-parser behavior comparison
- All 6 breakage patterns with safe rewrites
- The "risky characters" full catalog
- Myth-busting (smart quotes, live-preview "bugs", `_..._` alternative)

---

## 7. Five-Axis Tag Model

Tags are **horizontal metadata** — orthogonal to folders and links.

- **Folders** — primary classification (1:1)
- **Links / MOC** — explicit intentional connections
- **Tags** — calling notes from a different axis (a *weak* connector, in Luhmann's Zettelkasten sense)

### The five axes (use tags only along these)

| Axis | Examples | Could be a folder? |
|---|---|---|
| **Status** (state / action) | `#review-needed` `#draft` `#evergreen` `#exam-critical` | ❌ varies over time |
| **Type** (note kind) | `#concept` `#literature-note` `#adr` `#guide` `#essay` | ⚠️ strongly horizontal |
| **Domain** (field / subfield) | `#cs` `#database` `#math` `#psychology` | ❌ forbidden if folder already covers |
| **Topic** (primary concept) | `#deep-learning` `#regularization` | ⚠️ prefer wikilink if a `[[X]]` MOC exists |
| **Context** (situational / meta) | `#mobile` `#review-2026q2` | ❌ ephemeral / meta |

### Forbidden

- Tag with the same name as the containing directory (duplicates the classification axis)
- Free-form tags outside the 5 axes (taxonomy decays)

### Naming

- lowercase + kebab-case + singular (`#literature-note` ✅, `#Literature_Notes` ❌)
- Keep native language (`#복습-필요`, `#推荐`), English singular (`#book` ≠ `#books`)
- Pick one writing system per concept: `#deep-learning` ↔ `#딥러닝` — don't mix

### Operating principles

- **2~5 tags per note** is the sweet spot. 10+ is tag-explosion noise.
- **A Topic tag accumulating 5+ notes → graduate to a MOC**: create `MOC - {topic}.md`, switch primary navigation to wikilinks, keep the tag only as a search aid.
- **Status tags need an expiry**: `#exam-critical` is time-bound — note expiry in frontmatter (`tag-expires: 2026-06`) or it becomes a ghost tag.
- **Quarterly pruning**: consolidate/delete tags used by only 1–2 notes; merge spelling variants.

### Wikilink vs Tag — decision

- Want to see concept clustered → separate `[[X]]` MOC note + wikilinks
- Want fast search only → tag
- Both → wikilink primary, tag secondary

---

## 8. PARA Classification (Optional)

If you adopt Tiago Forte's PARA method, the four-folder structure:

```
PARA/
├── 1. Projects/     ← active projects (deadlines, deliverables)
├── 2. Area/         ← ongoing areas of responsibility (study, certifications, health)
├── 3. Resource/     ← reference material, hobbies, interests
└── 4. Archives/     ← completed / abandoned items
```

### Folder spec note

Each Project / Area / Resource folder has a `.md` file with the same name as the folder. That file holds the folder's stack, key notes, status, and folder sticker.

### Medium-first Resource layout

Don't scatter reviews / walkthroughs / memos across work-specific folders. Group them inside a **medium folder**:

```
PARA/3. Resource/
├── game/
│   ├── overwatch/         ← walkthroughs / tactics
│   ├── eatventure/
│   └── reviews/           ← review notes
├── music/
│   ├── vocal/             ← practice, theory
│   └── reviews/
└── book/
    ├── reading-list.md
    └── reviews/
```

Recommended path for review notes (convention shared with external writing skills):
- `PARA/3. Resource/{medium}/reviews/{title}.md`

---

## 9. Delegation Interface (for Other Skills)

This skill is the **convention authority** for other Obsidian writing skills in the same vault.

### Delegation signal

Other writing skills detect this skill by checking the working directory:

| Signal | Meaning |
|---|---|
| `.claude/skills/obsidian-write/SKILL.md` exists | This skill is the vault-local convention authority. Other skills *must* defer to it. |
| `.obsidian/` exists but signal above does not | Generic Obsidian vault — host skill applies its own Obsidian case |
| Neither | Not an Obsidian context — host skill applies plain markdown |

### What's delegated

| Area | Delegatable? | Notes |
|---|---|---|
| Heading rules (§3) | ✅ | Always |
| Horizontal rule (§4) | ✅ | Always |
| Indentation (§5) | ✅ | Always |
| Emphasis-breakage rule (§6) + CJK procedure (§10) | ✅ | Critical for CJK |
| Sticker frontmatter (§2) | ✅ | External skill may provide medium-specific sticker (e.g., polymedia provides per-medium emojis) |
| 5-axis tag model (§7) | ⚠️ | If external skill has its own tag policy, that wins |
| PARA path (§8) | ⚠️ | If external skill defines its own path policy, that wins |
| External skill's own workflow (interview, analysis, etc.) | ❌ | This skill must not interfere |

### Example flow

```
User: "Write a review for Overwatch 2"
  ↓
polymedia-review-skill triggers — starts maieutic interview
  ↓
Interview + 4D rubric (polymedia's own domain)
  ↓
Note-write phase: polymedia detects vault signal
  → finds .claude/skills/obsidian-write/SKILL.md
  → defers heading / hr / emphasis / sticker / PARA path to this skill
  ↓
Post-write self-check: §10 grep 4-pack runs
  ↓
Done
```

---

## 10. Post-Write Self-Check (Mandatory)

Run immediately after Write / Edit, **before** reporting completion to the user. Don't wait to be asked.

### Two-stage strategy

Stage 1 is a narrow grep that catches real breakage. Stage 2 is a wider grep for borderline cases that need human judgment.

#### Stage 1 — High-confidence breakage patterns

```bash
cd "<note folder>"
TARGET="*.md"   # or a specific file

# (1) Closing-side break: inside-punct + ** + word-character outside (CJK-heavy)
grep -nP '[\)\]"'\''\.,:;!?\$…—–]\*\*[가-힣\p{Han}\p{Hiragana}\p{Katakana}A-Za-z0-9]' $TARGET

# (2) Opening-side break: word-char outside + ** + opening punct inside
grep -nP '[가-힣\p{Han}\p{Hiragana}\p{Katakana}A-Za-z0-9]\*\*["\(\[\$「『]' $TARGET

# (3) h1 in body (forbidden) — exclude `# comment` inside code blocks
for f in $TARGET; do
  awk -v file="$f" '/^```/{in_code = !in_code; next}
                    !in_code && /^# /{print file ":" NR ": " $0}' "$f"
done

# (4) Numbered headers (`## 1. Topic` only — does not flag `802.1X` etc.)
grep -nE '^##+ [0-9]+\. ' $TARGET
```

If Stage 1 returns zero lines, the note has likely passed. Any hits are almost certainly real — fix with §6 patterns immediately.

> ⚠️ For check (3), a naive `grep -nE '^# '` falsely flags `# comment` lines inside Python / Bash code blocks. The awk version tracks the code-block toggle correctly.

#### Stage 2 — Wide flanking grep (advisory)

```bash
# (5) Closing-side suspects: non-word-char inside + word-char outside
grep -nP '(?<=[^\s\w가-힣\p{Han}\p{Hiragana}\p{Katakana}])\*\*(?=[\w가-힣\p{Han}\p{Hiragana}\p{Katakana}])' $TARGET

# (6) Opening-side suspects: word-char outside + non-word-char inside
grep -nP '(?<=[\w가-힣\p{Han}\p{Hiragana}\p{Katakana}])\*\*(?=[^\s\w가-힣\p{Han}\p{Hiragana}\p{Katakana}])' $TARGET
```

These don't know whether each `**` is opening or closing, so they also flag the inverse case (which is actually safe). Walk each hit manually:

1. Identify which side of the bold pair the matched `**` belongs to
2. Check what's *inside* (against the delimiter, on the bold's side)
3. Inside is a letter → false positive (master rule: safe)
4. Inside is punctuation + outside is a letter → real break → fix per §6

#### Stage 3 — `---` between h3s (optional)

```bash
for f in $TARGET; do
  awk -v file="$f" '
  /^---$/ && NR > 5 { hr_line = NR; in_hr = 1; next }
  in_hr { if (/^$/) next
    if (!/^## /) print file ":" hr_line ": --- not followed by h2 → " $0
    in_hr = 0 }
  ' "$f"
done
```

### CJK note? Run the extra procedure

If the note is in Korean / Japanese / Chinese / mixed CJK, run **`ref/cjk-language-extra-checks.md`** procedure additionally. CJK particles attach to `**` differently from Latin, and the extra checks catch the breakages Stage 1/2 might miss.

### Pass condition

Stage 1 all empty → pass. Stage 2 is advisory (high false-positive rate). Stage 3 when suspected.

**Do not report "done" to the user without passing this self-check.**

---

## 11. Related Skills

External Obsidian writing skills that delegate to this one:

| Skill | Domain | Delegation |
|---|---|---|
| [polymedia-review-skill](https://github.com/rhino-ty/polymedia-review-skill) | Review notes (books, games, movies, music) | Detects this skill via signal in its "Note system adapter" section → auto-delegates |
| [review-myblog-converter](https://github.com/rhino-ty/review-myblog-converter) | Obsidian note → blog tone conversion | Input-only consumer; no direct convention overlap |
| Lecture / academic note skills (vault-local) | Course notes, study material | Delegates §6 + §10 self-check; keeps domain-specific grep (e.g., header-number rule, exam-meta phrases) |
| Interactive visualization skills (dataviewjs) | In-note interactive widgets | Owns code-block content; convention overlap minimal |

---

## License

MIT. Use the convention bundle if it fits your vault; modify freely. The CJK emphasis-breakage rule (§6, §10, `ref/`) is particularly valuable for Korean / Japanese / Chinese authors — even users who don't adopt the rest may want to keep these procedures.
