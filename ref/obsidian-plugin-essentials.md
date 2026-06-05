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

## AI guidance pattern: install → verify → confirm

When this skill recommends a plugin to the user (during onboarding, or when a convention isn't rendering as expected), the AI agent should follow a 4-step pattern — not "click these buttons" and move on:

1. **Explain why** — 1–2 sentences from the plugin's "Why a first-time user might want it" section. Never ask the user to install something without telling them what it solves.
2. **Walk through install** — the "Install + first 5 minutes" block of the plugin entry.
3. **Verify it worked** — the "Verify the install worked" block. Run the checks yourself if you have the access; otherwise describe each check and what the user should see.
4. **Ask for confirmation** — explicitly ask the user to confirm the verification result before proceeding with conventions that depend on the plugin. Example: *"Can you see the Spaces panel on the sidebar now, and does an existing folder's emoji show up when you look at it? Tell me what you see before we adopt the sticker convention."*

### Why the verify step is mandatory, not optional

Obsidian plugins fail silently in three predictable ways:

| Silent-failure mode | What the user sees | Why it matters |
|---|---|---|
| Installed but not enabled | The plugin appears in "Installed plugins" list, but the toggle is off. Conventions referencing it appear to be "broken" | A new user often misses that *install* and *enable* are two separate clicks |
| Enabled but missing follow-up setting | Plugin is on, but a feature toggle (e.g., Dataview's "Enable JavaScript Queries") is off by default. Half the plugin works, half doesn't | Many plugins ship with conservative defaults that require an explicit opt-in for the most-recommended feature |
| Enabled and configured but UI didn't refresh | Plugin should work but the sidebar/panel hasn't redrawn yet. Looks broken until reload | Obsidian needs `Ctrl+R` or restart for some plugin loads — easy to forget |

Without the verify step, the user adopts conventions assuming the plugin works. The convention silently fails (sticker = plain text, not an icon; dataview block = literal code, not a table). The user loses trust in the skill before they understand why.

The verify step + explicit user confirmation is the cheapest insurance against this trust loss. **Don't skip it, even when the install looks trivially successful.**

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

**Verify the install worked**:
1. Settings → Community plugins → confirm "Make.md" toggle is ON in the *Installed* section
2. Look at the sidebar — a new **Spaces** panel should be visible (usually left side, near or below the file explorer)
3. Right-click any folder → confirm "Set sticker" appears in the context menu
4. Open a note that has `sticker: emoji//1f48a` in frontmatter → switch to Reading View → confirm 💊 emoji renders (in the note's tab title, or in the file explorer per theme)

If the Spaces panel doesn't appear: Settings → Make.md → enable "Spaces" → reload Obsidian (`Ctrl+R` or full restart).
If the sticker emoji doesn't render: verify the frontmatter is **exactly** `sticker: emoji//1f48a` (no spaces around `//`, hex in lowercase, no quotes around the value).

**Tell the user**: After walking them through install, ASK explicitly: *"Can you see the Spaces panel in the sidebar? And does the sticker emoji actually render on a note that has the frontmatter?"* Wait for confirmation on both before proceeding to adopt §2 sticker conventions. If only the Spaces panel appears (no sticker render), the user's frontmatter syntax is likely slightly off — walk them through creating a fresh note with the exact syntax to debug.

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

**Verify the install worked**:
1. Settings → Community plugins → confirm "Dataview" toggle is ON
2. Settings → Dataview → **confirm both "Enable JavaScript Queries" AND "Enable Inline JavaScript Queries" are ON** — these are OFF by default after install. This is the most common silent-failure for new Dataview users
3. In a test note, add this block and save:
   ````
   ```dataview
   LIST FROM "" LIMIT 5
   ```
   ````
4. Switch to Reading View → confirm 5 note names appear as a clickable list (the `FROM ""` means "the whole vault")

If the dataview block renders as literal code (with the backticks visible in Reading View): plugin isn't enabled. Re-check step 1, reload Obsidian.
If the list is empty even though the vault has notes: try `LIST FROM ""` exactly with empty quoted path — that's the "whole vault" syntax.
If block syntax works but inline `= dv.current().file.name` doesn't: the second JavaScript toggle (Inline) is off — go back to step 2.

**Tell the user**: ASK explicitly: *"Did the test dataview block render as a list with 5 note names? And in Settings → Dataview, are **both** JavaScript Queries toggles turned on?"* Both must confirm positive before §5 typed properties + dashboard usage is reliable. The second-toggle gotcha bites every new Dataview user — don't skip checking it.

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

**Verify the install worked**:
1. Settings → Community plugins → confirm "Templater" toggle is ON
2. Settings → Templater → confirm "Template folder location" matches where you actually put templates (e.g., `Templates/`, exact path)
3. Run command palette → "Templater: Create new note from template" → pick your template → confirm a new note opens with `<% tp.date.now(...) %>` replaced by today's actual date

If `<% ... %>` appears as literal text in the new note: either Template folder location is wrong (Templater doesn't recognize the file as a template) or the new note wasn't created via the Templater command.
If the command palette doesn't show "Create new note from template": plugin not enabled, or Obsidian needs reload.

**Tell the user**: ASK: *"When you created a new note from a template, did the `<% tp.date %>` get replaced by today's actual date (like `2026-06-05`)?"* If yes, the minimal-template-to-Templater automation pipeline works. If no, the most likely cause is the Template folder location setting pointing somewhere wrong — confirm the path matches.

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

**Verify the install worked**:
1. Settings → Community plugins → confirm "Periodic Notes" toggle is ON
2. Settings → Periodic Notes → confirm Daily Notes is enabled and folder format string is set (e.g., `Daily/{{date:YYYY}}/`)
3. Run command palette → "Periodic Notes: Open today's daily note" → confirm the note opens at the right path (e.g., `Daily/2026/2026-06-05.md` for today)
4. Confirm the filename matches today's date in the configured format

If the daily note opens in vault root instead of the configured folder: folder format string likely has a typo. Use `{{date:YYYY}}` not `{{YYYY}}`.
If the command isn't available in the palette: Daily Notes isn't enabled in Periodic Notes settings.
If the new note is blank when you expected a templated note: the template path setting points to a file that doesn't exist or to a folder instead of a template file.

**Tell the user**: ASK: *"When you ran 'Open today's daily note', did the file open at the expected path with today's date as the filename? And did it pre-fill with your template content?"* All three must confirm before the `example-daily-note.md` workflow is sustainable.

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

**Verify the install worked**:
1. Settings → Community plugins → confirm "Linter" toggle is ON
2. Settings → Linter → **leave "Run linter on save" OFF for the first verification** (avoids accidental mass edits on existing notes)
3. Create a test note with a deliberate issue — e.g., trailing whitespace at the end of a line, or extra blank lines between paragraphs
4. Run command palette → "Linter: Lint current file"
5. Confirm the issue is auto-fixed in place

If no fix happens: the rule for that issue isn't enabled. Settings → Linter → Rules → toggle the relevant rule on (e.g., "Trailing spaces").
If Linter rewrites things you didn't want changed: turn off that specific rule. Linter is opt-in per rule, not all-or-nothing.

**Tell the user**: ASK: *"When you ran Linter on the test file, did it fix the issue you put in? And did it leave alone anything you didn't want changed?"* Once both confirm, the user can flip "Run linter on save" ON. **Critical to mention**: Linter and this skill's §10 grep are complementary, not redundant — see the table at the top of this section. Encourage running both, not picking one. New users sometimes assume Linter "covers everything" and disable §10's CJK-emphasis-specific checks, which silently fails on Korean / Japanese / Chinese content.

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

**Verify the install worked**:
1. Settings → Community plugins → confirm "Tasks" toggle is ON
2. In a test note, type: `- [ ] Test task 🗓 2026-12-31 ⏫`
3. Confirm in Reading View that the date and priority emoji render as styled metadata (not as literal emoji characters in plain text)
4. In a separate note, add a query block:
   ````
   ```tasks
   not done
   ```
   ````
5. Confirm the test task appears in the query result

If the emoji metadata isn't being parsed (no due date showing as styled metadata): the emoji must be the exact unicode character. Copy-paste from the Tasks documentation if typing fails — `🗓` (U+1F5D3) vs `📅` (U+1F4C5) look similar but only the first works.
If the query renders as literal code in Reading View: plugin isn't enabled.

**Tell the user**: ASK: *"In the test task, does the due date show up as styled metadata (highlighted / boxed), not as a literal emoji + date string? And does the test task appear in the query result?"* Both must confirm before §12's task list extensions work as documented.

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

**Verify the install worked**:
1. Settings → Community plugins → confirm "Tag Wrangler" toggle is ON
2. Settings → Core plugins → confirm "Tags pane" is enabled (Tag Wrangler depends on it)
3. Open the Tags pane (usually right sidebar) → right-click any existing tag → confirm "Rename tag" appears in the context menu (alongside other Tag Wrangler options)

If the right-click menu only shows standard Obsidian options (no Tag Wrangler entries): the plugin isn't enabled, or the Tags pane isn't open in the visible sidebar.
If the Tags pane itself is missing: enable Settings → Core plugins → Tags pane, then reopen Obsidian.

**Tell the user**: ASK: *"When you right-click a tag in the Tags pane, do you see Tag Wrangler-specific options like 'Rename tag'?"* If yes, the SKILL.md §7 quarterly pruning workflow is now feasible. Emphasize that bulk-rename operations touch every note containing the tag — recommend committing a vault git snapshot (or backup) before the first rename, and proceeding one tag at a time the first few times.

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
