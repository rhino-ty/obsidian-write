# PARA Classification

> Reference for users adopting Tiago Forte's PARA folder structure. Referenced from `SKILL.md` §8. *Optional* — if your vault uses a different organizing system (Johnny Decimal, LATCH, Bullet Journal, flat folders, etc.), skip this entirely.

## What PARA is

PARA is a four-folder hierarchy that classifies notes by *actionability* rather than by topic:

```
PARA/
├── 1. Projects/     ← active projects (deadlines, deliverables)
├── 2. Area/         ← ongoing areas of responsibility (study, certifications, health, hobbies you actively maintain)
├── 3. Resource/     ← reference material, interests, things you might want later
└── 4. Archives/     ← completed / abandoned items (kept for searchability, not active management)
```

The original definition is from Tiago Forte's *Building a Second Brain*. The Obsidian-adjacent adaptation differs slightly — most users add a `4. Archives` folder rather than archiving in-place.

## Why PARA at all (and when to skip it)

**Use PARA when**:
- You're not sure where notes should live (PARA forces a decision)
- You have many notes that *should* eventually be archived but you can't bring yourself to delete (PARA gives them a home)
- You consistently confuse "this is a current project" with "this is a long-running area"

**Skip PARA when**:
- You're a programmer with strong Johnny Decimal habits (PARA's `1. Projects` namespace collides with JD's `10–19`)
- Your vault is heavily topic-driven and you want folders like `cs/`, `math/`, `essays/` instead of actionability-driven ones
- You prefer flat folders + heavy tagging
- You're already happy with whatever you've got

This skill's conventions are **PARA-friendly but not PARA-required**. Sticker frontmatter, 5-axis tags, emphasis-breakage rules, and self-check work in any folder layout.

## Decision rules — which folder does a note go in?

The cleanest discriminators:

| Question | Yes → | No → |
|---|---|---|
| Has a deadline or planned end? | **1. Projects** | next question |
| Are you actively maintaining it (will keep being relevant for 6+ months)? | **2. Area** | next question |
| Is it interesting / useful / might-want-later but not actively maintained? | **3. Resource** | **4. Archives** |

A common mistake: treating Areas as Resources (passive collection). Areas should be things you *actively touch* — current learning, ongoing health, present-job responsibilities. Last year's certifications go to Archives.

## Moving notes between PARA folders

Notes graduate frequently:
- Project ships → archive the project folder to `4. Archives/`
- Area becomes inactive (changed jobs, dropped a hobby) → move to `4. Archives/`
- Resource starts driving regular activity → promote to `2. Area/`

This is a *feature*, not friction. The PARA insight is that classification by actionability is the only stable axis — topics shift, but "is this currently driving my behavior?" is always answerable.

## Folder overview note

When a Project / Area / Resource folder needs context (what's in here and why, key notes, status), write it in an **overview note**: `{folder} overview.md` inside the folder, named in the vault's language (`{폴더명} 개요.md` in a Korean vault). Write one only when there is something to say. An empty overview is noise.

```
PARA/1. Projects/quarter-tracker/
├── quarter-tracker overview.md   ← overview note (this file)
├── architecture.md
├── retros/
│   ├── q1-2026.md
│   └── q2-2026.md
└── decisions/
    └── adr-001.md
```

```yaml
---
sticker: lucide//info
created: 2026-04-15
tags:
  - project
  - active
status: in-progress
deadline: 2026-09-30
---
```

Why these choices:

- **Every overview note shares one sticker (`lucide//info`).** The folder already has its own icon in the icon plugin (SKILL.md §2). If the overview carried the same icon, the file explorer would show the folder and a lookalike file right under it.
- **Not the same name as the folder.** A same-name note sits in the explorer as a duplicate of its folder unless a plugin hides it. `… overview` reads as what it is.
- **The folder's icon does not live here.** Set it in the icon plugin (`ref/obsidian-plugin-essentials.md` §1).

A fully worked overview note is in `examples/example-folder-overview-note.md`.

### Make.md users: the folder spec note

Make.md stores a folder's icon in a note with the **same name as the folder** (`quarter-tracker/quarter-tracker.md`) and writes its own `_filters` and `color` fields next to `sticker`. On Make.md that note is where the folder's icon and context live, and the Spaces navigator folds it into the folder. The body conventions are the same as an overview note. Without Make.md it still works as a README, you just lose the icon and see it as a separate file.

### Leaving Make.md

1. Move folder icons into the new icon plugin. Keep note `sticker`s as they are and generate the plugin's settings from them (`ref/obsidian-plugin-essentials.md` §1, Option A)
2. For each folder spec note: if it has a body **or** inbound links, rename it to `{folder} overview.md`, set its sticker to the shared overview icon, and rewrite the links. If it has neither, it only carried the icon. Delete it
3. Verify links against the pre-migration state, not just "zero broken now". Count broken links before and after with the same checker and compare the lists

One vault did this for 141 folder spec notes: 100 became overviews, 41 were deleted, 148 links were rewritten, and the broken-link list was identical before and after. Two traps it hit:

- **Links inside tables are written `[[Target\|alias]]`.** A matcher that takes everything before `|` reads the target as `Target\` and skips it, and a checker built the same way reports it broken both before and after, so the comparison hides the miss. Strip the trailing backslash in both
- **Filenames may be NFD on macOS.** Compare names after NFC normalization, and give the renamed file the same normalization form as its folder

## Medium-first Resource layout

Don't scatter reviews / walkthroughs / memos across work-specific folders. Group them inside a **medium folder**:

```
PARA/3. Resource/
├── game/
│   ├── overwatch/         ← walkthroughs / tactics
│   ├── eatventure/
│   └── reviews/           ← review notes (Kingdom Come Deliverance 2, etc.)
├── music/
│   ├── vocal/             ← practice, theory
│   └── reviews/
├── book/
│   ├── reading-list.md
│   └── reviews/
└── movie/
    └── reviews/
```

The medium-first layout makes companion-skill paths predictable. `polymedia-review-skill` writes reviews to:

```
PARA/3. Resource/{medium}/reviews/{title}.md
```

When you grow new media (audiobooks, podcasts, comics), add a new medium folder rather than scattering its content across topic-based folders.

## When the PARA folder structure fights you

If you find yourself unable to decide between Projects and Areas, or feel your Resource folder is becoming a junk drawer, the issue is usually one of two things:

1. **The "project" doesn't have a clear ship condition.** Either define one (and put it in Projects), or accept it's actually an Area (ongoing).
2. **The "resource" is being passively collected with no read-rate.** Time to either start reading it (Area) or admit you won't (Archives).

PARA doesn't fix indecision about what your work is. It surfaces it.

## Combining PARA with the 5-axis tag model

Folders answer "what am I doing with this?" (actionability). The 5-axis tag model (see `SKILL.md` §7) answers "what is this about?" (topic, status, type, domain, context). They're orthogonal.

Example: a note about `[[cache invalidation]]` written for an active project lives at `PARA/1. Projects/quarter-tracker/notes/cache-invalidation.md`. Its tags might be `#cs`, `#concept`, `#evergreen`. Folder = where I'm using this. Tags = what concept it covers + its lifecycle state.

A common new-PARA mistake is duplicating folder-info as tags. Don't tag `#projects` if the note is in `1. Projects/` — that's redundant. See `SKILL.md` §7 "Forbidden" rules.

## Migrating an existing vault to PARA

If your existing vault doesn't use PARA and you want to adopt it:

1. **Don't migrate everything at once.** Create `PARA/` next to your existing structure
2. Move *one* current project there, write its overview note if it needs one, work in it for a week
3. If it feels right, move the next project. Otherwise, abandon the migration — PARA isn't for you, and that's fine
4. Resources and Archives can sit unmigrated for months — they're low-frequency access, no urgency

The point is to validate the *actionability axis* on a small sample before reorganizing your whole vault. Heavy upfront reorganization often gets abandoned mid-way and leaves you with two competing structures.

## Reference

- Tiago Forte — *Building a Second Brain* (Atria, 2022) — original PARA definition
- Forte's PARA article: <https://fortelabs.com/blog/para/>
- This skill's `example-folder-overview-note.md` — a fully worked overview note for a project folder
