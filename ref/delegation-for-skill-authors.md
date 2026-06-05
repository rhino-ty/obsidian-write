# Delegation Interface — for Skill Authors

> Reference for **developers of other Obsidian writing skills** (review-note skills, lecture-note skills, journal skills, etc.) — how to delegate convention authority to `obsidian-write` when your skill operates inside an Obsidian vault. Regular skill users don't need this file.

## Who this is for

If you're:
- Building a new skill that produces Obsidian notes (e.g., a meeting-note skill, an interview-transcript skill, a recipe-collection skill, a workout-log skill)
- Maintaining an existing skill that writes to vaults (e.g., a fork of polymedia-review-skill for a different medium)
- Forking obsidian-write itself for a different language or vault style

→ This file documents the interface your skill should detect and respect.

If you're a **user** of obsidian-write — just writing notes in your own vault — you don't need any of this. Stop reading and go back to `SKILL.md`.

## The core delegation principle

When a skill produces an Obsidian note inside a vault, *two domains overlap*:

1. **Domain-specific workflow** — what your skill uniquely does (an interview flow, a recipe-template fill, a workout-log structure). This is *your skill's* responsibility.
2. **Generic vault conventions** — heading depth, emphasis safety, sticker frontmatter, tag axis, PARA path. These belong to the vault, not to your skill.

`obsidian-write` is the *convention authority* for domain 2. If it's installed in the vault, your skill **defers** to it for all generic-vault concerns and focuses exclusively on domain 1.

## Detection signals

Your skill should detect `obsidian-write` by checking the working directory for **signals** in this priority order:

| Priority | Signal | Meaning |
|---|---|---|
| 1 | `.claude/skills/obsidian-write/SKILL.md` exists | Vault-local convention authority — **this is definitive, defer to it** |
| 2 | `.obsidian/` folder exists, signal 1 missing | Generic Obsidian vault — apply your skill's *built-in* Obsidian case |
| 3 | Neither signal | Not an Obsidian context — apply your skill's *plain markdown* case |

The `.claude/skills/obsidian-write/SKILL.md` signal is intentionally specific — it's the file the user (or their skill installer) creates when they want vault-local convention authority. Generic `.obsidian/` only tells you it's *an* Obsidian vault, not that the user has opted into these specific conventions.

## What's delegatable (the contract)

| Convention area | Delegatable? | Notes |
|---|---|---|
| Heading rules (h2~h4, no h1, no numbered headers) | ✅ Always | See `obsidian-write/SKILL.md` §3 |
| Horizontal rule (`---` between h2 sections only) | ✅ Always | §4 |
| Indentation (tabs, not spaces) | ✅ Always | §5 |
| Emphasis-breakage rule + CJK procedure | ✅ Always | §6 + `ref/cjk-language-extra-checks.md` — critical for CJK content |
| Sticker frontmatter format | ✅ Always | §2; your skill *may* provide medium-specific stickers (e.g., polymedia provides per-medium emojis like 📖 for book, 🎮 for game) |
| `==highlight==` flanking rule | ✅ Always | Same flanking rule as `**`; see §6 + syntax-reference §8 |
| Post-write self-check (Stage 1 + CJK Check D) | ✅ Always | §10 — your skill should invoke this before reporting completion |
| 5-axis tag model | ⚠️ Negotiable | If your skill has a domain-specific tag policy (e.g., polymedia uses `tags: [book]` per medium), that wins for those specific tags. The 5-axis model still applies to anything else |
| PARA path | ⚠️ Negotiable | If your skill defines a domain-specific path (e.g., `PARA/3. Resource/{medium}/reviews/{title}.md`), that wins. Default to whatever path policy you've defined |
| Your skill's own workflow (interviews, analysis, templates) | ❌ Never delegate | This is your skill's identity. `obsidian-write` must not interfere |

## Standard delegation flow

```
1. User triggers your skill (e.g., "write a review for Overwatch 2")
   ↓
2. Your skill runs its workflow (interview, data collection, template fill)
   ↓
3. Note-output phase begins
   ↓
4. Detect obsidian-write signal
   ├─ Found → step 5
   └─ Not found → apply your skill's built-in Obsidian case → skip to step 7
   ↓
5. Read obsidian-write/SKILL.md sections §2-§7 as the convention reference
   ↓
6. Apply conventions while writing — heading depth, no h1, hr placement,
   tabs, emphasis-safety, sticker format
   ↓
7. Write the file
   ↓
8. Run obsidian-write/SKILL.md §10 Stage 1 self-check grep
   ├─ All empty → continue
   └─ Hits → fix per §6 patterns + ref/emphasis-breakage-deep-dive.md
   ↓
9. If CJK content: also run ref/cjk-language-extra-checks.md
   procedure (Checks A, B, D)
   ↓
10. Report completion to user
```

## How to announce delegation in your skill's SKILL.md

Add a section like this to your skill's SKILL.md (adapt to your skill's structure):

```markdown
## Delegation to obsidian-write

This skill writes Obsidian notes. When the vault has `obsidian-write`
installed (detection signal: `.claude/skills/obsidian-write/SKILL.md`
exists), this skill **defers convention authority** to it. Specifically:

- Heading depth, hr placement, indentation, emphasis-breakage rule,
  sticker frontmatter format → from obsidian-write §2-§6
- Post-write self-check → from obsidian-write §10 + ref/cjk-...

This skill retains authority over:
- [domain-specific item 1] — e.g., the interview workflow
- [domain-specific item 2] — e.g., the 4D rating rubric
- [domain-specific paths or tags] — e.g., `book/`, `game/`, etc.

When obsidian-write isn't detected, this skill applies its own
generic Obsidian case (defined below) or plain markdown.
```

## Companion skill examples

For real implementations, see:

- **[polymedia-review-skill](https://github.com/rhino-ty/polymedia-review-skill)** — `SKILL.md` "Note system adapter" section
  - Detects signal → delegates heading / hr / emphasis / sticker / PARA path
  - Retains 4-dimension rubric, per-medium templates, interview workflow
- **`knou-note-writer`** (this user's vault-local skill) — example of intra-vault delegation
  - Pre-delegation: 407 lines, self-check duplicated locally
  - Post-delegation: 296 lines (~27% smaller), §F-G ~200 lines collapsed into a one-paragraph pointer to `obsidian-write §10` + `ref/cjk-language-extra-checks.md`
  - Retained: lecture-note-specific grep (exam-meta phrases, virtual-exam-box markers)

Both cases show the same shape: domain-specific content stays, generic conventions delegate.

## Versioning and stability

`obsidian-write` follows informal semver in the 0.x range:
- **Patch** (0.2.1, 0.2.2) — bug fixes, ref content additions, no convention changes
- **Minor** (0.3, 0.4) — new conventions added, possibly new sections in SKILL.md, but existing convention text remains valid
- **Major** (1.0, 2.0) — convention shape changes that may require delegating skills to update

For delegation stability, target the section *content* (e.g., "emphasis-breakage rule") rather than the section *number* (e.g., "§6"). Section numbers may renumber when new sections are added; the content semantics stay stable.

When obsidian-write makes a breaking change, the CHANGELOG.md will document the migration path for delegating skills.

## How to avoid common delegation mistakes

### Mistake 1 — Re-implementing instead of delegating

Symptom: your skill ships its own emphasis-breakage grep, its own heading-depth check, its own sticker format definition.

Fix: detect the signal, delegate. If your skill *adds* something obsidian-write doesn't cover (e.g., a domain-specific marker like polymedia's `**기출 패턴 N** (※ ...)` virtual-exam-box), keep *only* that domain-specific addition. The generic emphasis check delegates.

### Mistake 2 — Treating signal as binary instead of priority

Symptom: your skill checks `.obsidian/` and proceeds without checking the more specific signal first.

Fix: check the most specific signal first. The priority order is:
1. `.claude/skills/obsidian-write/SKILL.md` exists
2. `.obsidian/` exists
3. Neither

### Mistake 3 — Overriding non-negotiables

Symptom: your skill writes `h1` headings inside vault notes because "my template uses h1".

Fix: non-negotiables (heading depth, no h1) are non-negotiable. Adapt your template to start at h2.

### Mistake 4 — Skipping the post-write self-check

Symptom: your skill reports "done" without running §10 grep.

Fix: invoke the grep before reporting completion. CJK content + emphasis-breakage is the most common silent-failure mode.

## Reference paths

When delegating from another skill, the canonical file paths your skill should read:

```
.claude/skills/obsidian-write/SKILL.md                                # main conventions
.claude/skills/obsidian-write/ref/emphasis-breakage-deep-dive.md      # §6 deep-dive
.claude/skills/obsidian-write/ref/cjk-language-extra-checks.md        # §10 CJK procedure
.claude/skills/obsidian-write/ref/obsidian-syntax-reference.md        # §11 syntax catalog
.claude/skills/obsidian-write/ref/obsidian-plugin-essentials.md       # plugin context
.claude/skills/obsidian-write/ref/para-classification.md              # §8 PARA (this folder's sibling)
```

If the vault has a different mounting layout (e.g., `~/.claude/skills/` global install), adapt the prefix but the relative structure under `obsidian-write/` is stable.
