# example-daily-note.md

> A reference daily note / journal entry. Imagine this is `Daily/2026/2026-06-05.md`. Daily notes are Obsidian's most ubiquitous note type — they're time-anchored, often the entry point for capturing fleeting thoughts before they're elevated into permanent notes. This example shows how the convention set adapts to a time-based, friction-minimizing format.

---

## The note itself

````markdown
---
sticker: emoji//1f4c5
created: 2026-06-05
tags:
  - daily
  - context/2026q2
weather: clear
mood: focused-tired
---

> **Date**: Thursday 2026-06-05 · **Energy**: 6/10 · **Sleep**: 7h

## Top priority today

Ship the obsidian-write skill ref + examples expansion. The CJK reference is the longest single piece — start there because if it's right the examples write themselves. If energy crashes mid-afternoon, examples can slide; the ref must be done.

## What happened

### Morning

- 9:00 — Got the polymedia + review-myblog repos updated for note-system adapter pattern. Two PRs pushed before coffee, surprisingly clean
- 10:30 — Started obsidian-write v0.1. Underestimated how much of the polymedia self-check carried over directly. Saved a lot of time, but had to rewrite for English-first audience
- 12:00 — Lunch + 30min walk. Noticed I was about to skip lunch and forced it. Good call — afternoon would have been worse

### Afternoon

- 13:30 — CJK reference. Hardest piece because the rule has to be *correct* enough that someone trusts it, but *short* enough that they read it. Settled on master rule + 6 patterns + grep
- 16:00 — Examples. Did academic + essay first; guide + tech-reference faster because the pattern was clear
- 18:30 — Decided to add MOC + folder-spec + daily-note + before-after. The original 4 felt incomplete. Daily-note feels meta to write *as* a daily note demo while writing today's actual daily note

### Evening

- 20:00 — Self-check on the whole repo. Caught the numbered-header self-contradiction in SKILL.md/ref/. Added the exception clause and moved on. Good catch
- 21:00 — Writing this daily note as the last thing before wrapping. Tomorrow: knou-note-writer delegation cleanup + README.ko.md

## Notes captured

> Things I noticed today that may want to become permanent notes later. None of these are commitments to write — they're flags for [[2026-W23-review]] (this Friday) to decide on.

- The pattern "MOC's Open threads section becomes the writing backlog" is worth a dedicated essay. It's how I actually use MOCs vs how MOCs are usually documented
- ADR numbering is the *one* case where numbered IDs are correct because the number IS the identifier. Worth a one-liner in SKILL.md §3 maybe — or just leave it implicit in the folder-spec example
- Stickers can be thematic, not just type-based. The essay example uses 🛡 because the essay is about tanking, not because shield = essay. Worth noting somewhere

## TODO that didn't get done

- [ ] knou-note-writer delegation cleanup — Task #3 in this session. Pushed to tomorrow
- [ ] Review last week's [[2026-W22]] retro to see if any threads from there relate to today's work
- [ ] Look at the obsidian-write README from a non-Korean reader's perspective. The English is fine but the CJK pitch needs to land in the first paragraph

## Tomorrow's top priority

knou-note-writer delegation cleanup. The boilerplate self-check section can be replaced with a single reference to obsidian-write §10 + ref/cjk-language-extra-checks.md. Saves ~200 lines.

## Related

- [[2026-W23]] — week index
- [[2026-06]] — month index
- [[MOC - daily-practice]]

## Yesterday

[[2026-06-04]]
````

---

## Conventions applied

- §2 *Frontmatter sticker* — `1f4c5` (📅, calendar) — universal for daily/journal notes. Custom fields `weather` and `mood` are opinionated personal extensions; SKILL.md doesn't mandate them
- §3 *Heading* — h2 sections (Top priority, What happened, Notes captured, TODO that didn't get done, Tomorrow's top priority, Related, Yesterday), h3 for time-of-day breakdown
- §4 *Horizontal rule* — none (the time-of-day h3s and the recurring h2 structure provide enough visual rhythm)
- §6 *Emphasis* — bold used sparingly (just in the header callout for date/energy/sleep). Daily notes don't need heavy emphasis; they're fleeting
- §7 *Tags* — Type (`#daily`), Context (`#context/2026q2` — temporal scope). Two tags. Daily notes are sparsely tagged because they're date-indexed already and don't need additional discoverability
- §11 *Cross-links* — weekly + monthly index, MOC, previous day. The wikilink pattern at the bottom enables traversal in both directions

### Why daily notes deserve special treatment

Daily notes have **the opposite optimization target** from regular notes. Permanent notes optimize for *re-readability* — careful tagging, structure, conventions. Daily notes optimize for *write-friction* — getting thoughts down in under 60 seconds. Heavy conventions kill the format.

The compromise this skill recommends:
- Minimal frontmatter (sticker, created, 2 tags max)
- Loose internal structure (h2 sections OK, but don't agonize)
- Stage 1 self-check still applies (don't break bold accidentally)
- BUT: skip Stage 2/3 advisory grep on daily notes. The cost-benefit doesn't work.

The **Notes captured** section is the highest-leverage part of a daily note. It's the bridge to permanent notes — items there get reviewed in the weekly retro and either elevated, deferred, or dropped.

Stage 1 self-check on this file: zero hits. Pass.

---

## Minimal template to start from

````markdown
---
sticker: emoji//1f4c5
created: <YYYY-MM-DD>
tags:
  - daily
  - context/<YYYY-Qn>
---

> **Date**: <Weekday YYYY-MM-DD> · **Energy**: <1–10> · **Sleep**: <hours>

## Top priority today

<1–3 sentences. The ONE thing that, if done, makes today a success.>

## What happened

### Morning

- <time> — <event>

### Afternoon

- <time> — <event>

### Evening

- <time> — <event>

## Notes captured

> Fleeting thoughts to consider for permanent notes. Decided in the weekly retro.

- <thought>
- <thought>

## TODO that didn't get done

- [ ] <item>
- [ ] <item>

## Tomorrow's top priority

<seed the next day>

## Related

- [[<YYYY-Wnn>]]
- [[<YYYY-MM>]]
- [[MOC - daily-practice]]

## Yesterday

[[<YYYY-MM-DD>]]
````

### Variation: minimum-viable daily note (for low-energy days)

````markdown
---
sticker: emoji//1f4c5
created: <YYYY-MM-DD>
tags:
  - daily
---

## What I did

- <one bullet, can be terse>

## What I'm carrying forward

- <one bullet>

## Tomorrow

<one line>
````

Even this skeleton — three sections, ~10 lines — preserves the value of having *something* daily. Empty daily notes break the streak more than terse ones.
