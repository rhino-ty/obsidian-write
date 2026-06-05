# Agent Context Files (CLAUDE.md / AGENTS.md / etc.)

> Reference for writing and maintaining the markdown files that AI coding agents read to understand a project — `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `.codex.md`, etc. For Obsidian vault owners, these live at the vault root and describe the vault's context to any agent navigating it. Referenced from `SKILL.md` §12.

## What this file covers

Every coding-AI tool reads some form of project-context file. The exact filename and conventions vary, but the *job* is the same: give the agent the context it needs to behave correctly in this specific project (vault).

This skill (obsidian-write) treats those agent context files as a **first-class write target** alongside regular vault notes — meaning when you ask the skill to "update the CLAUDE.md" or "write an AGENTS.md", it applies a tailored subset of vault conventions, not the full set.

The tailored subset is documented below. The catalog of agent context file formats is documented in §2. The "how to write good agent context" guidance is in §3.

## 1. Why agent context files matter (for Obsidian vault owners)

An Obsidian vault is unusual as a project context: it isn't a codebase. It's a personal knowledge base. When an AI coding agent walks into the vault directory, the conventions it might assume (test files, build configs, package.json, code patterns) don't apply. What *does* apply:

- The vault's organizing system (PARA, Johnny Decimal, flat folders)
- The writing conventions (this skill's §1–§7)
- Which skills are installed and what they do
- Which plugins are running and which conventions depend on them
- The note types that exist (daily, MOC, folder spec, project, etc.)
- The owner's voice and style (especially for skills like polymedia-review that mimic user voice)

Without an agent context file, every agent session re-discovers (or fails to discover) this information. With a good agent context file, the agent walks in already calibrated.

The vault root is the right place for these files — that's where agents look first.

## 2. Catalog: the agent context file landscape

Different agents read different files. Some converge on a common standard; many don't yet.

### CLAUDE.md (Claude Code)

The primary context file for **Claude Code** (Anthropic's CLI). Read at every session start. Lives at project root (or in subdirectories for scope-specific context).

- Filename: exactly `CLAUDE.md`
- Format: standard markdown
- Convention: free-form. Anthropic's docs recommend "instructions, context, and preferences"
- Scope inheritance: a `CLAUDE.md` in a subfolder is merged with (not replaces) the root one

If you only write one agent context file, write this one. Other agents read it too in many cases (more on cross-compatibility below).

### AGENTS.md (emerging cross-agent standard)

Pushed by the **Agents.md** initiative (<https://agents.md>) as a *cross-agent* convention — a single file readable by Claude Code, Codex, Cursor, Continue, and others. Adoption is uneven as of 2026 but growing.

- Filename: exactly `AGENTS.md`
- Format: standard markdown
- Convention: lightly structured. The proposal suggests sections like Setup, Conventions, Commands, Knowledge
- Cross-agent reads: yes, that's the point

If you maintain context for multiple agents, AGENTS.md is the right primary file. Some agents look for it; others fall back to their own format.

### AGENT.md (singular, less common)

Variant of AGENTS.md used by some setups. Treat as an alias unless your specific agent docs say otherwise. Usually safer to write AGENTS.md (plural) and symlink AGENT.md → AGENTS.md if a tool insists on the singular.

### .cursorrules (Cursor)

Cursor-specific rules file. Plain text (no formal markdown structure assumed). Lives at project root.

- Filename: exactly `.cursorrules` (with leading dot)
- Format: plain text / lightly structured. Cursor parses heuristically
- Convention: brief, imperative. "Always use X. Never do Y."

Cursor newer versions also read CLAUDE.md and AGENTS.md as fallback. If you don't use Cursor, skip this file.

### .codex.md (Codex CLI)

OpenAI Codex CLI's context file. Similar role to CLAUDE.md.

- Filename: exactly `.codex.md`
- Format: standard markdown
- Convention: like CLAUDE.md — instructions, context, preferences

Codex CLI also typically falls back to AGENTS.md.

### .windsurfrules (Windsurf)

Windsurf editor's rules file. Plain text.

- Filename: `.windsurfrules`
- Format: like `.cursorrules`

### Other / future

The space is evolving. New agents tend to either (a) adopt AGENTS.md, or (b) define their own `.{toolname}rules` file. If your specific agent isn't covered above, check the agent's documentation — but if it falls back to AGENTS.md, that's where you should put effort.

## 3. How to write good agent context for an Obsidian vault

The shape of useful agent context for a vault differs from a codebase. Here's the structure that consistently produces good agent behavior:

### 3.1 Vault owner (1-3 sentences)

Who maintains this vault, their working style, anything that should color the agent's tone.

```markdown
## Vault owner
- Name / handle
- Style: e.g., "values decision rationale over conclusions", "prefers terse over verbose"
- Domain: e.g., "primarily ML research notes plus a side journal"
```

### 3.2 Vault structure (the organizing system)

If you use PARA, say so. If you use flat folders, say so. The agent will infer if you don't tell it, and the inference is often wrong.

```markdown
## Vault structure (PARA)
PARA/
├── 1. Projects/      ← active projects
├── 2. Area/          ← ongoing maintenance
├── 3. Resource/      ← reference / interests
└── 4. Archives/
Templates/            ← shared templates
```

### 3.3 Active projects + active areas

A short table of what's currently live. The agent doesn't need every archive, but it should know what you're actively working on. Update this every quarter or when projects start/stop.

```markdown
## Active projects
| Project | Description | Folder spec note |
|---|---|---|
| Quarter Tracker | personal weekly/quarterly review tool | [[quarter-tracker]] |
| ...
```

### 3.4 Writing conventions

If you use this skill (obsidian-write), the agent context file is exactly where you delegate convention authority:

```markdown
## Writing conventions
Convention authority: this vault uses obsidian-write
(`.claude/skills/obsidian-write/SKILL.md`) for all formatting:
heading depth, emphasis-breakage rule, sticker frontmatter, 5-axis tag
model, post-write self-check, etc.

When creating or editing any .md note in this vault, follow obsidian-write
SKILL.md §1-§7 and run §10 Stage 1 grep before reporting completion.
```

That single delegation paragraph saves you from repeating the conventions inline. The agent reads the agent context file, sees the delegation, and walks into the skill for the full ruleset.

### 3.5 Installed skills

List the AI skills installed in the vault so the agent knows what's available without searching `.claude/skills/`.

```markdown
## Installed skills
- obsidian-write — vault writing conventions SSoT (this is the authority)
- polymedia-review-skill — book/game/movie/music review notes (auto-delegates to obsidian-write)
- knou-note-writer — lecture notes for a specific university (delegates to obsidian-write for format)
- obsidian-data-viz — dataviewjs interactive visualizations
- ...
```

### 3.6 Active plugins and their effect

The agent needs to know which plugins drive conventions vs. which are decorative.

```markdown
## Active plugins (relevant to writing)
- Make.md ✅ — sticker frontmatter renders as folder/note icons
- Dataview ✅ — frontmatter properties are queryable
- Tag Wrangler ✅ — bulk tag operations enabled
- Linter ❌ — not installed; obsidian-write §10 grep is the only emphasis check
- Periodic Notes ❌ — daily notes are created manually
```

This lets the agent reason about which conventions are *enforced* (because the plugin renders them) vs. *aspirational* (the convention is recorded but the renderer isn't installed).

### 3.7 Voice / style preferences

Optional but valuable if you have skills that mimic your voice (polymedia-review-skill mode B, for example).

```markdown
## Voice and style
- Korean and English mixed; default to user's prompt language
- Prefer ADR-style decision logging in project notes (context → decision → rationale → consequences)
- "Strikethrough don't delete" for deprecated decisions
```

### 3.8 External paths

If your vault syncs with external systems, note them.

```markdown
## External
- Vault path: /Users/.../obsidian-private
- Sync: Syncthing across desktop + mobile
- Companion repos: github.com/user/obsidian-write (skill source)
```

## 4. This skill's conventions when writing agent context files

Agent context files are markdown but they aren't *vault notes* in the same sense. Some conventions apply, some don't:

| Convention | Apply to CLAUDE.md / AGENTS.md? | Why |
|---|---|---|
| **§3 Heading depth (h2~h4)** | ✅ Yes | Obsidian Inline Title still renders the filename as h1; in-body h1 would still duplicate |
| **§3 No numbered headers** | ⚠️ Exception OK | Agent context files benefit from explicit section numbers like SKILL.md/ref/ do. Numbered headers are *acceptable* here. (Same exception logic as the skill's own docs — see SKILL.md §3 exception clause) |
| **§4 Horizontal rule between h2** | ✅ Yes | Same visual logic |
| **§5 Tab indentation** | ✅ Yes | Standard |
| **§6 Emphasis flanking rule** | ✅ Yes (especially for CJK) | Agent context can be Korean / Japanese / Chinese; same fragility applies |
| **§2 Sticker frontmatter** | 🟢 Optional | Agents don't read sticker; Obsidian users opening the file in-vault might want one. Add `sticker: emoji//1f916` (🤖) if you like |
| **§7 5-axis tag model** | ❌ Skip | Agent context files aren't part of the vault's classification axis. Tagging them gets noisy |
| **§8 PARA path** | ❌ Skip | Agent context files live at vault root, not under PARA/ |
| **§1 ADR-style** | ⚠️ Optional | Useful if you record agent-config decisions, but most agent context is descriptive, not decision-laden |
| **§10 Post-write self-check** | ✅ Yes | Run §10 Stage 1 grep after editing — CJK emphasis can break here too |

## 5. The "single agent context file or many?" question

You have three options:

### Option A — Single file (CLAUDE.md), let other agents fall back

Most pragmatic for most vaults. Write a thorough CLAUDE.md. Modern Cursor and Codex both fall back to reading it. Skip the rest.

Verdict: **default choice**. Saves maintenance overhead.

### Option B — AGENTS.md as primary, agent-specific files as override

Use AGENTS.md as the canonical "any agent" context. Add CLAUDE.md only when there's Claude Code-specific content (e.g., specific commands, specific MCP setup). Symlink `.codex.md → AGENTS.md` or skip it.

Verdict: best if you use multiple agents regularly and want a single source of truth.

### Option C — Per-agent file, no cross-fallback

Maintain CLAUDE.md, AGENTS.md, .cursorrules, .codex.md all separately. Each tuned to that specific agent's strengths.

Verdict: high maintenance, only worthwhile if the agents differ enough that one-size doesn't fit.

### Symlink strategy

If you want one source of truth but multiple filenames (so each agent finds *something*):

```bash
# Vault root
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md .codex.md
# .cursorrules is plain text — different format, can't symlink directly
```

This works at the filesystem level. Git tracks the symlinks. Obsidian respects them. Sync tools (Syncthing, iCloud) handle them inconsistently — verify on your setup.

## 6. Updating agent context as the vault evolves

Treat agent context as documentation that decays without maintenance:

- **Quarterly** — review "Active projects", "Active plugins", update what's changed
- **On skill install/uninstall** — update "Installed skills" the same day
- **On structural change** (PARA migration, folder reorg) — update structure section
- **On new convention adoption** (e.g., adopting this skill) — add the delegation paragraph

Stale agent context is worse than no agent context — it pollutes the agent's assumptions with outdated facts.

## 7. Worked example skeleton

A minimal but useful CLAUDE.md / AGENTS.md template for an Obsidian vault using this skill:

````markdown
## Vault owner
- Name: <name>
- Style: <decision-logging preference, terseness, etc.>
- Domain focus: <primary subject areas>

## Vault structure
<paste your PARA or folder tree here>

## Writing conventions

Convention authority: `obsidian-write` skill installed at
`.claude/skills/obsidian-write/SKILL.md`. Follow SKILL.md §1-§7
for all formatting; run §10 Stage 1 grep before reporting completion.
For CJK content, also run `ref/cjk-language-extra-checks.md` Check D.

## Active projects

| Project | Folder | Status |
|---|---|---|
| <project> | <path> | <status> |

## Installed skills

- obsidian-write (vault writing authority)
- <other skills with one-line purpose>

## Active plugins relevant to writing

- Make.md ✅
- Dataview ✅
- <other plugins> ✅/❌

## External

- Vault: <path>
- Sync: <method>
- <companion repos if any>
````

Adapt to your situation. The goal is "an agent walking in cold understands the vault within ~30 seconds of reading."

## 8. What this skill *won't* do for agent context

This skill doesn't:
- Pick which agent context format you should use (that depends on your agents)
- Maintain content sync between multiple agent context files if you have them (use symlinks or your own discipline)
- Decide what's worth documenting (you know your vault; the skill helps you format what you decide to write)

It does:
- Apply the writing conventions in §4 above to whatever agent context file you ask it to write/edit
- Suggest the delegation paragraph if you're writing context for an agent that will work with skills
- Run the §10 post-write self-check on the file before reporting completion
