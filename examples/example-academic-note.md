# example-academic-note.md

> A reference academic / study note showing every convention from `SKILL.md` applied in context. Imagine this is the file `PARA/2. Area/computer-networks/lec03-tcp-handshake.md` in someone's vault. The conventions notes appear *outside* the example body, at the bottom.

---

## The note itself

````markdown
---
sticker: emoji//1f4d8
created: 2026-06-05
reviewed: []
tags:
  - cs
  - networking
  - concept
  - review-needed
---

> **Course context**: Prereq lecture 2 (Link-layer framing). Next lecture 4 (TCP congestion control). This lecture defines the connection setup mechanism that lectures 4–7 build on.

## Why this lecture matters

TCP's three-way handshake is the most cited piece of computer-networks coursework in interviews, but the reason it works is rarely explained well. Most material describes *what* happens (SYN → SYN-ACK → ACK) without addressing *why* three messages are necessary instead of two or four. This note builds the rationale step by step so the procedure becomes derivable, not memorized.

## Glossary

- **SYN** (synchronize) — the initial sequence-number announcement. A flag in the TCP header
- **ACK** (acknowledge) — confirms received sequence number. Also a flag
- **ISN** (initial sequence number) — a per-connection random starting number for byte ordering
- **RTT** (round-trip time) — one full request + response cycle

## The handshake itself

```
Client                              Server
  |                                   |
  |---- SYN, seq=x ----------------->|
  |                                   |
  |<--- SYN-ACK, seq=y, ack=x+1 -----|
  |                                   |
  |---- ACK, ack=y+1 ---------------->|
  |                                   |
  |     [connection established]      |
```

Three messages. Each carries the sequence-number that the *other side* will acknowledge in the next message.

## Why three messages (not two, not four)

### The two-message argument (and why it fails)

A naive design: client sends SYN, server sends SYN-ACK, done. Two messages, half the handshake cost.

**Failure mode**: the server cannot tell whether the client's original SYN is a current request or a delayed duplicate from a previous attempt. If a stale SYN arrives, the server allocates a connection, sends SYN-ACK, and the client (who is not currently trying to connect) discards it. The server is left holding state for a connection that will never receive data — a resource leak.

### The three-message argument

By requiring the client to send a final ACK, the server confirms the client is *currently active* and not a delayed-duplicate scenario:

1. Client SYN — claims "I want to connect with my ISN = x"
2. Server SYN-ACK — claims "I want to connect with my ISN = y, and I received your x"
3. Client ACK — confirms "I received your y; we're synchronized"

After step 3, both sides agree on (a) the other side is reachable *right now*, (b) the other side's ISN. Data transfer can begin.

### Could we do it in four?

Yes, but each extra message adds 0.5 RTT to connection setup. The standardized form minimizes setup latency while guaranteeing the agreement property above.

## Sequence-number negotiation

Both sides choose independent ISNs (`x` and `y`), starting from a randomized value. This is not just procedural — it's a security property.

> If ISNs were predictable, an attacker could spoof a third packet (ACK with the predicted `y+1`) and inject data into the connection without observing the SYN-ACK. The randomization prevents this attack class (TCP sequence-prediction).

## State machine (simplified)

```
CLIENT                             SERVER
CLOSED  ─SYN sent─►  SYN_SENT      CLOSED  ─SYN recv─►  SYN_RCVD
SYN_SENT  ─SYN-ACK recv─►  ESTAB   SYN_RCVD  ─ACK recv─►  ESTAB
```

The asymmetry: client moves to ESTAB after step 2, server after step 3. Brief window where client thinks the connection is live but server hasn't confirmed yet.

## Common confusion: handshake vs slow-start

The handshake is the **3-message exchange** establishing the connection. Slow-start is the **congestion-control algorithm** that runs *after* the handshake to ramp up sending rate gradually. Different mechanisms, different lectures.

- Handshake → this lecture
- Slow-start → lecture 4

## Self-check questions (active recall)

> Don't write the answers here. Cover the note and try to answer aloud before checking.

1. Why does the closing ACK in the handshake exist? What would fail without it?
2. What property does randomizing the ISN protect against?
3. After step 2 (SYN-ACK), is the connection considered established by both sides?
4. In what state does the server sit between receiving the initial SYN and the final ACK?

## Related notes

- [[lec02-link-layer-framing]] — covers the layer below
- [[lec04-tcp-congestion-control]] — covers slow-start, the next mechanism that runs on this connection
- [[MOC - networking]] — primary entry point if browsing by topic

## TODO

- TODO: Find the canonical RFC 793 quote for "three-message constraint is a worst-case agreement protocol" — I remember it being explicit
- TODO: Verify whether the simplified state machine above is accurate for TCP Fast Open (RFC 7413). Suspect it's not.
````

---

## Conventions applied (commentary outside the note body)

- §1 *Writing style* — context paragraph at top, ADR-style "two-message vs three-message" decision rationale, explicit TODO markers at the end
- §2 *Frontmatter sticker* — `1f48a` (📘) for academic notes; `reviewed: []` array for spaced repetition
- §3 *Heading* — starts at h2, no h1, no numbered headers
- §4 *Horizontal rule* — none used in body (this is a single-topic note; hr would over-segment)
- §5 *Indentation* — sub-bullets use tabs (visible in the ASCII state machine and TODO list)
- §6 *Emphasis* — every `**bold**` has letters immediately inside; glosses like `**ISN** (initial sequence number)` keep parentheses outside the bold (would have broken Stage 1 grep otherwise)
- §7 *Tags* — five-axis: Domain (`#cs`, `#networking`), Type (`#concept`), Status (`#review-needed`). Total 4 tags, in the 2–5 sweet spot
- §8 *PARA* — placed in `2. Area/` (ongoing learning, not a one-shot project)
- §11 *Cross-links* — wikilinks to prereq/follow-up lectures and the topic MOC

Stage 1 self-check on this file: zero hits. Pass.

---

## Minimal template to start from

Copy this skeleton to start a new academic note. Replace the angle-bracketed placeholders.

````markdown
---
sticker: emoji//1f4d8
created: <YYYY-MM-DD>
reviewed: []
tags:
  - <domain>          # e.g., cs, math, psychology
  - <subtopic>        # e.g., networking, statistics, cognitive-science
  - concept           # or: literature-note / proof / problem-set
  - review-needed     # initial status
---

> **Course context**: <prereq lecture, follow-up lecture, where this fits>

## Why this lecture matters

<2–3 sentences. What problem does this lecture's mechanism solve that the previous lecture left open?>

## Glossary

- **<term>** — <definition>
- **<term>** — <definition>

## <Main mechanism / theorem / procedure>

<derivation, diagram, or stepwise explanation>

## Why this design (not alternatives)

### The naive alternative

<2-message handshake, greedy algorithm, etc. — and why it fails>

### The accepted form

<why the textbook procedure is the way it is — failure modes the naive form has>

## Self-check questions

> Don't write the answers here. Cover the note and try to answer aloud.

1. <conceptual probe>
2. <edge-case probe>
3. <alternative-design probe>

## Related notes

- [[<prereq-note>]]
- [[<follow-up-note>]]
- [[MOC - <domain>]]

## TODO

- TODO: <fact to verify against primary source>
- TODO: <follow-up reading>
````

