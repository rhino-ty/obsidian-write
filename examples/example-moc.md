# example-moc.md

> A reference MOC (Map of Content) — Obsidian's primary navigation pattern. Imagine this is `PARA/2. Area/computer-networks/MOC - networking.md`, the index note for a knowledge area that has grown past 5+ Topic-tag uses (graduating from `#networking` to a proper MOC, per SKILL.md §7 operating principle).

---

## The note itself

````markdown
---
sticker: emoji//1f5fa
created: 2026-06-05
tags:
  - moc
  - networking
status: active
---

> **What this is**: the primary navigation index for everything I have on computer networking. Use this instead of searching `#networking` once a topic has enough notes to deserve a landing page.

## How this MOC is organized

Three layers. The **foundational** layer is for re-readable derivations (handshakes, congestion control). The **practical** layer is for procedures and references. The **forks** layer is for related-but-distinct subtopics that may eventually graduate to their own MOC.

A note appears here when it crosses a usefulness threshold — referenced from another note, useful for review, or load-bearing in my mental model. Notes that are stub-level stay in `#networking` tag search only.

## Foundational — derivations and proofs

The mechanisms whose *reasoning* matters more than their procedural details. Re-read these when interview prep or when trying to extend the mental model.

- [[lec03-tcp-three-way-handshake]] — why three messages, not two
- [[lec04-tcp-congestion-control]] — slow-start, AIMD, the fairness/efficiency trade-off
- [[lec05-tcp-fast-retransmit]] — how RTT estimation drives loss detection
- [[lec06-tcp-congestion-window]] — bdp = bandwidth × RTT, the window-sizing rationale
- [[why-quic-replaces-tcp]] — head-of-line blocking and the case for UDP-based transport

## Practical — procedures and references

Skim-friendly notes. Look these up when troubleshooting or for fact-recall.

- [[tcp-handshake-debug-checklist]] — wireshark capture patterns for handshake failures
- [[common-tcp-error-codes]] — RST, RST-ACK, KEEPALIVE responses
- [[netstat-and-ss-command-reference]] — what each output column means
- [[mtu-mss-and-fragmentation-cheatsheet]] — when to suspect MTU mismatch

## Forks — adjacent areas that may graduate

When any of these accumulates 4+ notes, fork it to its own MOC and remove from this list.

- [[MOC - http-and-rest]] — already graduated; the protocol layer above TCP
- [[wireshark-techniques]] — 2 notes so far; may graduate
- [[dns-resolution-deep-dive]] — 3 notes; close to graduating
- [[load-balancer-patterns]] — 1 note; stays here for now

## Open threads — what I haven't written yet

Notes that *should* exist but I haven't written. Listing them here as TODO triggers.

- [ ] TLS handshake in detail (currently a one-liner reference)
- [ ] BGP routing — I've avoided this and shouldn't have
- [ ] gRPC vs REST trade-offs — interview-relevant
- [ ] eBPF for network observability — emerging area

## Pruning log

- 2026-04-12 — removed `tcp-old-experiments` link (note archived to `4. Archives/`)
- 2026-03-20 — promoted `MOC - http-and-rest` from a forks entry to its own MOC

## Related MOCs

- [[MOC - distributed-systems]] — networking is the substrate; consensus protocols live there
- [[MOC - cs-interview-prep]] — networking section pulls from this MOC's foundational layer
- [[MOC - operating-systems]] — kernel-side network stack is a fork between OS and this MOC
````

---

## Conventions applied

- §2 *Frontmatter sticker* — `1f5fa` (🗺, world map) — semantic choice for a navigation index. The `status` field is an opinionated extension marking the MOC's lifecycle (active / dormant / graduated)
- §3 *Heading* — h2 sections (How this is organized, Foundational, Practical, Forks, Open threads, Pruning log, Related MOCs), no h1, no numbered headers
- §4 *Horizontal rule* — none (the h2 structure does the visual segmentation)
- §6 *Emphasis* — bold for layer names (`**foundational**`, `**practical**`, `**forks**`) is letters-only inside the delimiters, safe
- §7 *Tags* — Type (`#moc`), Domain (`#networking`). Just 2 tags — MOCs themselves are sparse-tagged because they ARE the navigation; using more tags defeats the purpose
- §11 *Cross-links* — every entry is a wikilink. The MOC is *pure* connectivity; if you're writing prose paragraphs in a MOC, it's drifting toward an essay

### Why this MOC pattern works

The 3-layer structure (Foundational / Practical / Forks) handles three failure modes of bare topic indexes:

1. **Topic-tag search** returns every note alphabetically — no signal about importance. MOC layers convey *re-read frequency*.
2. **Unorganized MOC** becomes a wall of wikilinks. Layer grouping limits each section to 5–8 entries.
3. **Forks** prevents the MOC from sprawling into adjacent areas — it acknowledges "this could be its own thing" without forcing the split prematurely.

The **Open threads** section is the most-used part for the author — it's the writing backlog, surfaced where they'll see it during navigation.

Stage 1 self-check on this file: zero hits. Pass.

---

## Minimal template to start from

````markdown
---
sticker: emoji//1f5fa
created: <YYYY-MM-DD>
tags:
  - moc
  - <domain>          # the area this MOC indexes
status: active        # or: dormant / graduated
---

> **What this is**: the primary navigation index for <domain>. Use this instead of searching `#<domain>` once the area has accumulated 5+ notes.

## How this MOC is organized

<2–3 sentences. Layering rationale.>

## Foundational

<derivations / proofs / re-readable mechanisms>

- [[<note>]] — <one-line purpose>

## Practical

<procedures / references / skim-friendly>

- [[<note>]] — <one-line purpose>

## Forks

<adjacent topics that may graduate to their own MOC>

- [[<note or sub-MOC>]] — <count of related notes, graduation threshold>

## Open threads

<notes that should exist; writing backlog>

- [ ] <topic>
- [ ] <topic>

## Pruning log

- <date> — <change>

## Related MOCs

- [[MOC - <adjacent-domain>]]
````
