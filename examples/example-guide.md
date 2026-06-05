# example-guide.md

> A reference how-to / walkthrough note. Imagine this is `PARA/3. Resource/game/overwatch/season-15-map-tank-guide.md`. Shows the convention set applied to a procedural, structured-by-content note rather than a structured-by-thinking note.

---

## The note itself

````markdown
---
sticker: emoji//1f3ae
created: 2026-06-05
game: Overwatch 2
season: 15
patch: "2026-05-21"
tags:
  - guide
  - overwatch
  - tank
  - context/season-15
---

> **Scope**: tank role only, season 15 maps + meta. Updated after the 2026-05-21 patch. Will go stale at season 16 — see the patch field for currency.

## How to use this guide

Each map gets four sections: a one-line read of the geometry, the tank pick I'd default to, the second-best alternative, and a positioning note for the opening fight. Skim by section header. The "opening fight" note is the most situational — the rest are stable across MMRs.

## Quick lookup table

| Map | Default tank | Alt pick | Why default |
|---|---|---|---|
| King's Row | Reinhardt | Sigma | Tight corners reward shield uptime |
| Hanaoka | Doomfist | Winston | Multi-level geometry rewards dive |
| Suravasa | Sigma | Orisa | Long sightlines, ranged tank wins |
| Esperança | Winston | Doomfist | Vertical play, dive tanks dominate |
| Throne of Anubis | Reinhardt | Ramattra | Choke-heavy attack lanes |
| Antarctic Peninsula | Orisa | Sigma | Open spaces, sustain tank survives |

## Per-map breakdown

### King's Row

Reads as a shield map. Three tight chokes on attack (statue, first-point arch, hotel) all reward shield uptime and slow methodical pushes. The wide spaces on second and third points punish dive tanks who overextend without bubble.

- **Default**: Reinhardt — pin potential into walls + shield value on every choke
- **Alt**: Sigma — kinetic grasp counters the burst-damage DPS picks (Soldier, Sojourn) that dominate this map's sightlines
- **Opening fight**: take the statue choke aggressive on attack. Defenders who don't contest statue cede the high ground at first point.

### Hanaoka

A multi-level Japan-themed push map. Defender's spawn opens onto multiple flanking routes. Vertical play is the meta-defining feature.

- **Default**: Doomfist — punch combo across the rooftops creates kill opportunities a brawler can't replicate
- **Alt**: Winston — bubble jump-pad uptime is genuine on this map; supports usually can't peel
- **Opening fight**: dive the back-line support before they reach high ground. Once they're set, the dive is dead.

### Suravasa

A flowing map with long lines of sight broken by curved cover. Reinhardt's shield can't pin the full distance; Doomfist gets walked back by ranged DPS.

- **Default**: Sigma — long-range presence + grasp negates ranged poke
- **Alt**: Orisa — javelin spin breaks Genji / Tracer dive attempts; spear poke matches sightline range
- **Opening fight**: rock-throw the spawn doorway as enemy team exits. Hit-rate is high because of the corridor angle.

### Esperança

Vertical Portuguese coastal map. Roofs everywhere, ground floor is a death corridor.

- **Default**: Winston — sustained jump uptime + Reinhardt counter (electrocute breaks shield)
- **Alt**: Doomfist — slam combos off rooftops onto support back-line
- **Opening fight**: jump onto first-point roof before the timer ends. Establishing the roof first denies enemy dive a landing pad.

### Throne of Anubis

Attack-favored map with two thin choke points. Defender team has to hold a narrow funnel.

- **Default**: Reinhardt — pin potential into chokes is highest in the game on this map
- **Alt**: Ramattra — nemesis form clears chokes when shield breaks
- **Opening fight**: attackers — feed shield value into the first choke for 8–10 seconds, force defender support cooldowns, then push.

### Antarctic Peninsula

A trio of small maps (Sub-Base, Icebreaker, Labs). All three favor sustain tanks because positions are open and there's no shield value to take.

- **Default**: Orisa — javelin + fortify cycle wins the sustain war
- **Alt**: Sigma — grasp absorbs the burst damage that one-shots low-armor tanks here
- **Opening fight**: depends on sub-map. Sub-Base: contest the elevator. Icebreaker: contest the dock. Labs: contest the open arena center.

## Universal opening-fight rules

> Tank-agnostic. Apply on every map after the per-map advice above.

1. Don't engage at full HP with all cooldowns burned. Bait one or two before committing.
2. Track which supports are alive before each push. A solo support after first-fight = the team needs to push *now*.
3. Bubble / shield / fortify *covers the highest-value target*, not your own face. Tank survival is downstream of support survival.
4. When your team is dying around you, walking back to spawn alive is worth more than a heroic stand. The next fight is 10 seconds away.

## Counter-pick triggers

When to switch off the default tank into a counter:

| Enemy comp signal | Switch to |
|---|---|
| Double-sniper (Widow + Hanzo) | Winston dive — break sightlines |
| Bastion sentry locked in | Doomfist or Sigma — break or absorb |
| Mauga sustain tank | Zarya or Sigma — burst through sustain window |
| Pharah/Echo air comp | Sigma or Sojourn (DPS swap needed too) |
| Mei + Reaper brawl | Sigma — kinetic grasp on Mei wall + Reaper TP |

## Patch sensitivity

> Updated 2026-05-21 patch. Will go stale.

- **Sigma** kinetic grasp absorption cap raised → Sigma viability up
- **Doomfist** punch cooldown reduced 0.5s → dive tank meta strengthens on Hanoaka / Esperança
- **Orisa** javelin spin damage reduced 5% → still meta on Antarctic Peninsula but less dominant on Suravasa

Future patch likely to nerf Doomfist again; alt picks in the table may shift.

## Related

- [[review - overwatch-2]] — broader take on the game itself
- [[MOC - overwatch]] — index of strategy notes
- [[overwatch-supports-season-15]] — pair this guide with support knowledge

## TODO

- TODO: Add a screenshot per map (deferred — taking the screenshots is a 30-min task)
- TODO: Test Ramattra alt-pick on Anubis against full dive comps — current advice is from brawl matches only
````

---

## Conventions applied

- §1 *Writing style* — scope statement at top with currency information (the patch field + warning that the note will go stale), TODOs marked at the end (§1.3)
- §2 *Frontmatter sticker* — `1f3ae` (🎮, game controller); custom fields `game`, `season`, `patch` because this note has currency-sensitive metadata
- §3 *Heading* — h2 sections (How to use, Quick lookup, Per-map, Universal rules, Counter-pick, Patch, Related, TODO), h3 for individual maps, no h1, no numbered headers
- §4 *Horizontal rule* — none used (the h2-grouped structure already provides clear separation; hr between h2s would feel over-engineered for a guide format)
- §5 *Indentation* — tabs (list items in counter-pick triggers; bullet alignment in per-map sections)
- §6 *Emphasis* — every bolded hero name (`**Reinhardt**`, `**Sigma**`, etc.) is followed by an em-dash + space, not punctuation flush against `**`. Safe.
- §7 *Tags* — Type (`#guide`), Topic (`#overwatch`), Topic narrow (`#tank`), Context (`#context/season-15` — note the slash indicating temporal scoping; the season-15 tag should expire when season 16 launches)
- §8 *PARA* — `3. Resource/game/overwatch/` per the medium-first Resource layout
- §11 *Cross-links* — wikilinks to companion review, MOC, and support guide

The currency metadata (`patch` field + "will go stale" notes) is an opinionated extension — not in the SKILL.md core conventions but a useful pattern for time-sensitive reference notes.

Stage 1 self-check on this file: zero hits. Pass.

---

## Minimal template to start from

````markdown
---
sticker: emoji//1f3ae
created: <YYYY-MM-DD>
<domain-specific currency field>: <value>   # e.g., season: 15, version: "1.4.2", patch: "2026-05-21"
tags:
  - guide
  - <topic>                  # e.g., overwatch, react, cooking
  - <subtopic>               # e.g., tank, hooks, korean-cuisine
  - context/<scope>          # e.g., context/season-15  ← signals temporal scoping
---

> **Scope**: <what this guide covers and what it does NOT cover>. Updated <date>. Will go stale at <event/date> — see the currency field above.

## How to use this guide

<2–3 sentences. How is it structured? What can you skim vs need to read?>

## Quick lookup table

| <category> | <recommendation> | <alternative> | <why> |
|---|---|---|---|
| <case 1> | <main pick> | <alt> | <one-line reason> |
| <case 2> | <main pick> | <alt> | <one-line reason> |

## Per-<unit> breakdown

### <Unit 1>

<one-line geometry / character / situation read>

- **Default**: <pick> — <why this is the default>
- **Alt**: <alt pick> — <when to switch>
- **Opening / key moment**: <situational note>

### <Unit 2>

<repeat structure>

## Universal rules

> <unit>-agnostic. Apply after the per-<unit> advice above.

1. <rule>
2. <rule>

## Counter-pick / fallback triggers

| <signal in the situation> | <switch to> |
|---|---|
| <signal> | <action> |

## Currency notes

> <when this guide will need updating; which fields are most volatile>

## Related

- [[<companion-guide>]]
- [[MOC - <topic>]]
````

