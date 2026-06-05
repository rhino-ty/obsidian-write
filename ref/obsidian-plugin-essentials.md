# Obsidian Plugin Essentials

> A first-time-friendly guide to the Obsidian plugins that matter for *this* skill's conventions — sorted into three tiers: **Required**, **Recommended**, and **Compatible**. Each entry answers "what is this plugin, why might I want it, and how does it interact with the conventions in `SKILL.md`?"
>
> If you've never installed an Obsidian plugin: open **Settings → Community plugins → Turn on community plugins → Browse**, search by name, click *Install*, then *Enable*.

## Why plugins matter for this skill

Obsidian itself is deliberately minimal — links, search, basic markdown rendering. That minimalism is a strength (nothing breaks because there's not much to break), but it also means that **most of the value of this skill's conventions only shows up once you've installed a few specific plugins**.

Without plugins:
- `sticker: emoji//1f48a` in frontmatter is just text — no visual icon
- `dataview` code blocks in your notes render as literal code
- Folder spec notes work but folder emoji doesn't appear in the sidebar
- The 5-axis tag model still organizes tags, but bulk-renaming a tag is manual file-by-file work

With the right plugins:
- Sticker emojis render as folder/note icons in the sidebar
- Frontmatter properties become queryable, sortable, dashboard-able
- Folder colors and stickers turn a 100+ folder vault from grayscale text walls into scannable visual hierarchy
- Tag renames propagate across the whole vault in one click

This guide tells you *which plugins, in what order, and why*.

## The three tiers

| Tier | Meaning | When to install |
|---|---|---|
| **Required** | This skill's conventions *assume* this plugin to deliver their full value. Without it, you still get most of the convention benefit, but some features (sticker rendering, dataview dashboards) are inert | Right away, before adopting the conventions seriously |
| **Recommended** | Greatly improves day-to-day Obsidian use *and* synergizes with this skill's conventions. Not strictly required, but every recommended plugin removes a meaningful friction point | After you've used the vault for 1–2 weeks and feel where the friction is |
| **Compatible** | Specialized plugins for specific use cases (academic writing, hand-drawn diagrams, advanced metadata UIs). Pick selectively based on what you actually do | Only when you hit the specific problem the plugin solves |

A common new-user mistake is installing 20 plugins on day one. Resist that — you can't tell what's load-bearing vs. what's noise until you've used the vault long enough to feel friction. Stick to Required first. Add Recommended one at a time when you hit the pain point each one addresses.

---

## Required tier

These two plugins make this skill's conventions *actually do what they describe*.

### 1. Make.md

**What it does in one sentence**: Adds a visual metadata layer to your vault — sticker emojis, colors, and category badges on folders and notes, manageable through a UI sidebar called *Spaces*.

**Why a first-time user might want it**:
Obsidian's default sidebar is text-only. After 30 folders and 200 notes, it becomes a wall of gray text where you scan-and-skip rather than scan-and-find. Make.md lets you tag folders and notes with emojis and colors, turning the sidebar from text-scanning into icon-scanning. The cognitive load drops dramatically.

**Pain it solves**:
- "Where was that note again?" — visual icons drastically improve recall
- Folder discovery — 50+ folder vaults become navigable
- Sense of progress — colored areas read as "actively used" vs. "archived"

**Who benefits most**:
- PARA / LATCH / Zettelkasten users (any folder-classification approach)
- Visual learners and people who prefer scanning to searching
- Vaults with 100+ folders or 500+ notes

**Relationship with this skill**:
- **Required for §2** — `sticker: emoji//{hex}` frontmatter only renders as a visual icon when Make.md (or a compatible folder-emoji plugin) is installed. Without it, the field exists in your file but doesn't show up anywhere.
- **Required for folder spec notes** — the `_filters` and `color` frontmatter fields used in `example-folder-spec-note.md` are Make.md's syntax.
- Conflict with: none known.

**Install + first 5 minutes**:
1. Settings → Community plugins → Browse → "Make.md" → Install → Enable
2. Settings → Make.md → enable "Spaces" (sidebar panel)
3. Right-click any folder → "Set sticker" → pick an emoji
4. Make.md auto-creates the folder-spec note (same name as folder) with the sticker frontmatter

**Watch out**:
- Syncthing / iCloud / Dropbox: a `.makemd/` folder appears with `superstate.mdc` and `fileCache.mdc`. These can produce sync conflicts — usually safe to ignore or .gitignore
- Some themes may render stickers in slightly different positions
- Make.md has its own command palette (separate from Obsidian's) — worth learning

**Alternatives if you don't want Make.md**:
- *Folder Notes* + *Iconize* — split functionality across two plugins
- Manual: skip sticker entirely and don't use that field. The rest of this skill's conventions still work.

---

### 2. Dataview

**What it does in one sentence**: Turns your vault into a queryable database — write SQL-like queries that produce dynamic tables, lists, and JavaScript-rendered visualizations from your frontmatter and inline metadata.

**Why a first-time user might want it**:
Your notes already contain structured data (frontmatter properties, tags, dates), but Obsidian's default UI only lets you see it one note at a time. Dataview lets you ask questions: "show me all book reviews from this year sorted by rating", "list every project with `status: in-progress`", "count notes I haven't reviewed in 6 months". This transforms a vault from a *collection* into a *system*.

**Pain it solves**:
- "How many books did I read this year?" — answerable in 5 seconds, not a manual count
- "Which projects are blocked?" — surfacing data already in your notes
- "What did I write in 2025 Q4?" — time-bounded retrospectives without scrolling

**Who benefits most**:
- People who use frontmatter (anyone following SKILL.md §5)
- Anyone who runs reviews (weekly, quarterly, year-end retros)
- Knowledge workers who need to surface patterns from their notes

**Relationship with this skill**:
- **Required for full §5 value** — SKILL.md §5 documents typed properties (`rating`, `status`, `priority`). Without Dataview, those properties are inert metadata. With Dataview, they become a dashboard.
- **Required for `scripts/audit-vault.sh` companion patterns** — while the audit script itself is shell-based, queries equivalent to its output can be expressed as Dataview blocks for in-vault use
- **Companion to `obsidian-data-viz`** — that skill uses Dataview's JS API (`dataviewjs`) for interactive visualizations. This plugin is the substrate both rely on.
- Conflict with: nothing direct. Heavy Dataview queries on large vaults (5000+ notes) can be slow — cache results when possible.

**Install + first 5 minutes**:
1. Settings → Community plugins → Browse → "Dataview" → Install → Enable
2. Settings → Dataview → enable "JavaScript Queries" and "Inline JavaScript Queries"
3. In any note, add a code block:
   ````
   ```dataview
   LIST FROM #book
   ```
   ````
4. Switch to Reading View — see all notes tagged `#book` as a clickable list

**Quick query recipe book**:

```
LIST FROM #project
WHERE status = "active"

TABLE rating, file.cday AS "Created"
FROM "Reviews"
WHERE rating >= 8
SORT rating DESC

TASK FROM ""
WHERE !completed AND due AND date(due) <= date(today)
```

**Watch out**:
- Query language has two dialects: DQL (SQL-like) and DataviewJS (JavaScript). Start with DQL.
- "Refresh interval" setting controls how often queries re-run. Default is fine for most use; turn down on huge vaults.

---

## Recommended tier

These plugins solve specific friction points that almost every vault eventually hits.

### 3. Templater

**What it does in one sentence**: Generates new notes from templates with dynamic content — date stamps, frontmatter pre-fills, user-prompt-driven fields, and JavaScript-powered logic.

**Why a first-time user might want it**:
You'll create the same kind of note (daily journal, weekly review, book note, project spec) many times. Filling in the same fields manually wastes minutes per note. Templater fills them in for you.

**Synergy with this skill**:
Each `examples/example-*.md` file in this skill ends with a `## Minimal template to start from` section. Those minimal templates are *exactly* what Templater excels at automating. Copy the minimal template into a Templater template file, replace `<placeholders>` with `<% tp.system.prompt("Subject") %>` and `<% tp.date.now("YYYY-MM-DD") %>`, and now creating a new academic note is two keystrokes instead of two minutes.

**Pain it solves**:
- "I always forget to set `created:` field" — Templater pre-fills it
- "Today's daily note frontmatter is the same as yesterday's but the date changes" — exactly Templater's use case

**Install + first 5 minutes**:
1. Install → Enable
2. Create a folder `Templates/` in your vault
3. Settings → Templater → set "Template folder location" to `Templates/`
4. Copy a `## Minimal template` block from any `examples/example-*.md` into a new file in `Templates/`
5. Replace placeholders: `<YYYY-MM-DD>` → `<% tp.date.now("YYYY-MM-DD") %>`
6. Trigger: command palette → "Templater: Create new note from template"

**Watch out**:
- "Trigger Templater on new file creation" can cause unexpected behavior — leave off until you know what you're doing
- User scripts (custom JavaScript) live in a separate folder you configure separately

---

### 4. Periodic Notes (or Calendar)

**What it does in one sentence**: Manages daily / weekly / monthly / quarterly / yearly notes — auto-creating files in a date-based folder structure and linking adjacent periods.

**Why a first-time user might want it**:
The `example-daily-note.md` pattern in `examples/` is only sustainable if creating today's daily note is one keystroke. Periodic Notes makes it one keystroke. Without it, you'd type out `Daily/2026/2026-06-05.md` every day, which feels like nothing on day one and like friction on day fifty.

**Synergy with this skill**:
- Pairs with `example-daily-note.md` for automated daily journaling
- The `[[YYYY-Wnn]]` and `[[YYYY-MM]]` wikilinks in the daily example resolve to weekly/monthly notes that Periodic Notes creates automatically

**Install + first 5 minutes**:
1. Install → Enable
2. Settings → Periodic Notes → enable Daily / Weekly / Monthly notes
3. For each, set folder (e.g., `Daily/{{date:YYYY}}/`) and template (point to your Templater daily template)
4. Hotkey "Open today's daily note" — bind to `Ctrl+Shift+D` or similar

**Alternative**: the older *Calendar* plugin shows a small calendar in the sidebar and creates daily notes on click. Simpler, less flexible. Pick Calendar if you want a visual calendar widget, Periodic Notes if you want weekly/quarterly notes too.

---

### 5. Linter

**What it does in one sentence**: Auto-formats markdown on save — fixing common issues like inconsistent heading levels, trailing whitespace, and missing blank lines.

**⚠ Important relationship with this skill**:
Linter and this skill's §10 self-check **overlap, but neither fully replaces the other**. Understand the trade-off before relying on one alone:

| Concern | Linter | This skill's §10 |
|---|---|---|
| Trailing whitespace, mixed tabs/spaces | ✅ auto-fix | Partially (§5 covers tab indent) |
| Heading levels (no h1 if config says so) | ✅ auto-fix on save | Detects, doesn't auto-fix |
| CommonMark flanking emphasis breakage (`**활용(exploitation)**과`) | ❌ Not detected by default | ✅ Stage 1 grep catches it |
| CJK-specific particle attachment | ❌ Not aware | ✅ Check D specifically targets it |
| `==highlight==` flanking | ❌ Not detected | ✅ Same flanking rule as `**`, grep variants in syntax-reference §8 |
| Frontmatter property order | ✅ Configurable | Not addressed |
| `---` between h2 sections only | ✅ Configurable as a rule | ✅ §4 + Stage 3 grep |
| Numbered headers (`## 1. Topic`) | ✅ Configurable | ✅ Stage 1 grep (4) |

**Bottom line**: Linter catches more *general* markdown issues automatically (good for trailing whitespace, heading levels). This skill catches the *CJK-specific emphasis breakage* that Linter doesn't know about. **Run both**: Linter as a save-time auto-fixer, this skill's §10 grep as a CJK-targeted detector.

**Install + first 5 minutes**:
1. Install → Enable
2. Settings → Linter → enable "Run linter on save" if you want auto-fix
3. Pick rules — recommended starter set:
   - **Headings**: "No empty lines around headings", "Empty line around headings", "Headings must start at heading level X" (set X=2 to enforce our h2-start convention)
   - **YAML**: "Format YAML array", "Sort YAML keys"
   - **Spacing**: "Trailing spaces", "Remove multiple consecutive blank lines"
4. Important: **disable** any rule that conflicts with your existing notes until you're ready to bulk-fix them (e.g., "Strict line breaks" can rewrite a lot)

---

### 6. Tasks

**What it does in one sentence**: Extends GFM checkbox syntax with due dates, recurrence, priority, and a query interface for surfacing tasks across the vault.

**Why a first-time user might want it**:
The `- [ ] Task` checkbox in standard markdown is static — it sits in whatever note you put it in, invisible until you find that note. Tasks plugin queries surface every checkbox across your vault by due date, priority, or tag, turning them into an actionable list.

**Synergy with this skill**:
- `syntax-reference §12` already documents Tasks' emoji metadata format
- The extended task states from §12 (`- [/]`, `- [-]`, etc.) are partially Tasks-aware
- `example-folder-spec-note.md` and project notes benefit from Tasks queries surfacing project todos

**Install + first 5 minutes**:
1. Install → Enable
2. In a note, type: `- [ ] Buy milk 🗓 2026-06-10 🔁 every week`
3. In a separate "Tasks" note, query:
   ````
   ```tasks
   not done
   due before tomorrow
   ```
   ````

**Watch out**:
- Emoji metadata is the default — feels weird at first but reads fluently after a week
- "Auto-suggest" can pop emoji suggestions while you type — turn off if annoying

---

### 7. Tag Wrangler

**What it does in one sentence**: Adds bulk operations on tags — rename a tag everywhere, merge two tags, find unused tags.

**Why a first-time user might want it**:
SKILL.md §7's "quarterly pruning" — *consolidate / delete tags used by only 1-2 notes; merge spelling variants* — is a manual file-by-file edit without Tag Wrangler. With Tag Wrangler it's three clicks: right-click tag → rename → done.

**Synergy with this skill**:
- Directly enables §7 operating principles
- Without it, the 5-axis tag model degrades over time because pruning is too painful to do

**Install + first 5 minutes**:
1. Install → Enable
2. Open the Tags pane (Settings → Core plugins → Tags pane)
3. Right-click any tag → Tag Wrangler adds "Rename" and other options

**Watch out**:
- Bulk renames touch every note containing the tag — `git commit` before doing them
- A renamed tag's history is gone from the tag pane; if you want auditability, also note the change in a maintenance log

---

## Compatible tier

Pick these when you hit the specific problem each one solves.

### 8. Excalidraw

**What it does**: Hand-drawn diagrams (sketches, mind maps, flow diagrams) embedded as `.excalidraw` files inside the vault.

**Why you might want it**: Mermaid covers most structured diagrams, but some thinking needs *unstructured* sketching — boxes-and-arrows you'd draw on a whiteboard. Excalidraw is that whiteboard.

**Relationship with this skill**: Independent of conventions. Embeds as `.excalidraw` images in notes.

**When to install**: When you find yourself reaching for paper to draw something instead of writing.

---

### 9. Citations (with Zotero)

**What it does**: Pulls citation data from a Zotero library into Obsidian, generates literature notes from citation keys.

**Why you might want it**: If you're doing academic work and already use Zotero, this connects the two. The `example-tech-reference.md` pattern is a *light* version of literature notes — Citations gives you the heavy version with full bibliographic metadata.

**Relationship**: Pairs naturally with `example-tech-reference.md` and the `#literature-note` tag axis.

**When to install**: When you have 50+ academic papers and tracking them manually is too painful.

---

### 10. Hover Editor

**What it does**: Hover over a wikilink to see the target note's content in a popup — and *edit* it inline without opening a new tab.

**Why you might want it**: MOC navigation becomes much faster — you don't lose context flipping between tabs. The `example-moc.md` workflow especially benefits.

**Relationship**: Synergizes with all wikilink-heavy patterns (MOCs, folder spec notes, examples with cross-references).

**When to install**: When you find yourself constantly opening and closing notes from MOCs.

---

### 11. MetaEdit / Metadata Menu

**What it does**: UI for editing frontmatter properties without manually typing YAML.

**Why you might want it**: Typing `sticker: emoji//1f4d8` correctly is error-prone (which hex was it?). A UI dropdown makes property edits foolproof.

**Relationship**: Speeds up adoption of SKILL.md §5 typed properties.

**When to install**: If you find yourself making YAML typos in frontmatter.

---

### 12. Smart Connections / Copilot

**What it does**: AI-powered "related notes" suggestion based on embeddings of your vault content.

**Why you might want it**: Reveals connections between notes you wrote months apart that share semantic content but no explicit link. Surprising-and-useful, sometimes noise.

**Relationship**: Orthogonal to convention enforcement. Useful for the *discovery* side of Zettelkasten.

**When to install**: When you have 500+ notes and feel you're forgetting connections between them.

---

### 13. Advanced Tables

**What it does**: Spreadsheet-like editing of markdown tables — Tab to next cell, auto-format columns, sort, formulas.

**Why you might want it**: Markdown tables are tedious to write by hand. This makes them tolerable.

**Relationship**: Speeds up the comparative-analysis tables that §1.5 of SKILL.md encourages.

**When to install**: After you write your third tedious table by hand.

---

### 14. Outliner

**What it does**: Logseq-style outline manipulation in Obsidian — Tab/Shift-Tab to indent, drag bullets around like Workflowy.

**Why you might want it**: If you think in outlines more than prose, this makes Obsidian feel like an outliner.

**Relationship**: Compatible. `example-essay.md`-style notes that use outlines benefit.

**When to install**: If you've ever wished Obsidian behaved like Workflowy or Logseq.

---

## Plugin install order for new users

A pragmatic 4-stage rollout that gives you value progressively without overwhelming choice:

| Stage | When | Install |
|---|---|---|
| **Stage 1 — Day 1** | First open of new vault | Make.md, Dataview |
| **Stage 2 — Week 2** | After you have ~20 notes and feel the friction | Templater + Periodic Notes (daily notes only) |
| **Stage 3 — Month 2** | After your tag list grows past 30, or you start adopting the 5-axis model seriously | Tag Wrangler, Linter |
| **Stage 4 — As needed** | When the specific pain shows up | Tasks (when you have project lists), Excalidraw (when you start sketching), Citations (when you start academic writing), Hover Editor (when MOC navigation feels slow), etc. |

Resist installing everything at stage 1. The plugin ecosystem is vast, and your vault's needs only become legible after you've used it for a while.

## Settings that matter regardless of plugins

A few Obsidian core settings that interact meaningfully with this skill's conventions:

- **Settings → Files & Links → Use [[Wikilinks]]** — keep ON. This skill's conventions assume wikilinks.
- **Settings → Files & Links → Default location for new notes** — set to "Same folder as current file" so notes land near where you're thinking, not in vault root.
- **Settings → Editor → Strict line breaks** — leave OFF. The default GFM-style soft break behavior is what this skill assumes.
- **Settings → Editor → Use tab indent** — ON (matches §5).
- **Settings → Editor → Tab indent size** — your preference, but match it to whatever your other markdown tools use.

## Final note

Plugins are *power*, not *permission*. None of this skill's conventions *require* you to install plugins beyond Make.md and Dataview to deliver value. The other plugins remove friction so the conventions stay sustainable over years, not weeks.

If you're a first-time Obsidian user reading this: install Make.md and Dataview, write notes for two weeks using the conventions, *then* come back and pick recommended plugins based on the friction you actually felt. Most "must-have" plugin recommendations on the internet are someone else's friction, not yours.
