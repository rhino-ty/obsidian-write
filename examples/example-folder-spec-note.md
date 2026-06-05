# example-folder-spec-note.md

> A reference folder-spec note — the `.md` file that shares the parent folder's name and documents what the folder is *for*. Imagine this is `PARA/1. Projects/quarter-tracker/quarter-tracker.md`, the spec note inside the `quarter-tracker/` folder. SKILL.md §2 introduces this as the place to put folder emoji and folder-level context.

---

## The note itself

````markdown
---
_filters: []
sticker: emoji//1f4ca
color: "#3b82f6"
created: 2026-06-05
tags:
  - project
  - active
  - context/2026q2
status: in-progress
deadline: 2026-09-30
---

> **What this folder is**: working files for the personal quarter-tracker project. Code, design notes, scratch work, retrospectives. Public artifacts (blog posts, README) live separately in the project's git repo, not here.

## What this project is

A weekly + quarterly self-review tool. Captures what I worked on, what I delayed, what I learned, in a form that's quick to write (under 10 min weekly) and useful to re-read (quarterly retro). Targets the gap between "calendar" (too granular, no narrative) and "year-end review" (too coarse, too late).

## Why I'm building it

I've been writing weekly notes manually for 18 months. The pattern is consistent enough to deserve a tool, and the manual version has friction points (forgetting to do it, inconsistent format, no aggregation). The tool fixes the *consistency* problem without trying to replace the *thinking* part — it's a writing prompt + storage system, not an AI coach.

I built and abandoned an earlier version in 2025 because I over-engineered the UI. This time the constraint is: command-line only, plain markdown files, no UI until I've used the CLI version for 8 weeks.

## Decisions (ADR-style)

### ADR-001: plain markdown over SQLite

- **Context**: need to store weekly entries somewhere
- **Decision**: markdown files in a fixed directory structure (`YYYY/Wnn.md`)
- **Rationale**: portability (any editor can read), grep-able, fits Obsidian if I want to view inside the vault, no DB migration burden as schema evolves
- **Consequences**: aggregation requires parsing markdown; mitigated by treating it as a small batch job (quarterly), not a hot path

### ADR-002: terminal UI before web UI

- **Context**: the abandoned 2025 version sunk on UI engineering
- **Decision**: CLI only for v0–v3. Web UI considered only after 8+ weeks of CLI usage
- **Rationale**: forces me to validate the writing-prompt model before investing in presentation
- **Consequences**: less shareable in early stages — but the early version is for me, not for others

### ADR-003: prompts hardcoded, not configurable (v0)

- **Context**: tempting to make the weekly-review prompts user-editable
- **Decision**: hardcode the 6 prompts in v0
- **Rationale**: configurability is a substitute for committing to a format. I want to be forced to live with my prompts long enough to learn what's wrong with them
- **Consequences**: any prompt change requires a code edit until v2; acceptable for a personal tool

## Stack

| Layer | Choice | Notes |
|---|---|---|
| Language | Go | CLI binary, easy distribution to my other machines |
| Storage | Markdown files | See ADR-001 |
| Editor invocation | `$EDITOR` env var | Defaults to `vim`, works with anything |
| Aggregation | Go parser + template | Quarterly script, runs in <1s for a year of data |
| Distribution | `go install` from private GitHub | Personal use, no public release planned for v0–v3 |

## Key files

- [[quarter-tracker-architecture]] — high-level structure of the CLI
- [[quarter-tracker-prompts]] — current weekly + quarterly prompt sets
- [[quarter-tracker-retros]] — retrospective notes after each quarter of usage
- [[quarter-tracker-roadmap]] — what's deferred to v1, v2, etc.

## Status

- 2026-06-05 — v0.1 in active use for 6 weeks. Weekly entries consistent.
- 2026-05-28 — first quarterly aggregation run successfully (Q1 2026 retro generated)
- 2026-05-01 — v0.1 released to my own machines
- 2026-04-15 — project started

## Related

- [[MOC - personal-tools]]
- [[review - 2025-quarter-tracker-attempt]] — the abandoned earlier version, in essay form
````

---

## Conventions applied

- §2 *Frontmatter sticker* — `1f4ca` (📊, bar chart) — domain-appropriate. The `_filters: []` and `color` fields are Make.md plugin extensions for folder appearance; the `deadline` field is an opinionated personal extension for project tracking
- §3 *Heading* — h2 sections (What this folder is, What this project is, Why, Decisions, Stack, Key files, Status, Related), h3 for individual ADRs
- §4 *Horizontal rule* — none (the h2 structure suffices)
- §6 *Emphasis* — ADR `**Context**:`, `**Decision**:`, `**Rationale**:`, `**Consequences**:` — colon is *outside* the bold (after `**Context**` not inside). Safe.
- §7 *Tags* — Type (`#project`), Status (`#active`), Context (`#context/2026q2` — slash-namespaced for temporal scope). Three tags
- §1 *Writing style* — ADR-style decision logging applied throughout the "Decisions" section. Numbered ADRs (ADR-001, ADR-002) are the *one* exception where numbering is OK — ADRs are inherently sequential and the number IS the identifier. (h3 numbering in headers is still avoided because the ADR ID is in the title text, not as a section number.)
- §11 *Cross-links* — wikilinks to detail notes, MOC, retrospective

### Why folder-spec notes matter

Without one, a project folder is opaque. Six months later you don't remember what `quarter-tracker/` even was, why you picked Go, or what the earlier abandoned version was about. The folder-spec note is **the folder's README** — primary source of context for both your future self and any AI agent navigating the vault.

It also doubles as the place to attach the folder's `sticker` emoji (Make.md plugin reads it from this file), so you get the same artifact serving two functions.

Stage 1 self-check on this file: zero hits. Pass.

---

## Minimal template to start from

````markdown
---
_filters: []
sticker: emoji//<hex>     # see SKILL.md §2 for sticker code reference
color: ""                 # hex like "#3b82f6" if you want Make.md to color the folder
created: <YYYY-MM-DD>
tags:
  - <project-or-area>
  - <status>
  - context/<scope>
status: <in-progress / paused / done>
deadline: <YYYY-MM-DD>    # optional, for projects
---

> **What this folder is**: <1–2 sentence definition of the folder's role>

## What this <project / area> is

<2–3 paragraph longer description. Anchor your future self.>

## Why I'm doing this

<motivation. Especially important if the answer is non-obvious or evolves.>

## Decisions (ADR-style)

### ADR-001: <decision>

- **Context**: <situation that prompted the decision>
- **Decision**: <what was chosen>
- **Rationale**: <why this over alternatives>
- **Consequences**: <what this commits you to>

### ADR-002: <decision>

<repeat>

## Stack

| Layer | Choice | Notes |
|---|---|---|
| <area> | <choice> | <why> |

## Key files

- [[<note>]] — <one-line purpose>

## Status

- <date> — <change>

## Related

- [[MOC - <area>]]
````
