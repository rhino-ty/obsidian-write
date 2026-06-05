# example-tech-reference.md

> A reference analytical / technical deep-dive note. Imagine this is `PARA/3. Resource/dev-references/why-javascript-chose-prototypes.md`. Shows conventions applied to a longer analytical note that draws from external sources but contributes its own synthesis.

---

## The note itself

````markdown
---
sticker: emoji//2753
created: 2026-06-05
source_paper: "Wilson Steen, 'Classes vs. Prototypes — Some Philosophical and Historical Observations', 1996"
source_url: "http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.56.4713"
tags:
  - javascript
  - language-design
  - literature-note
---

> **Note type**: a literature note. Synthesizes Steen's 1996 paper with my own observations about how JavaScript inherited its prototype semantics. The paper is the primary source; the modern-JS commentary is mine.

## The question

Why does JavaScript use prototypes instead of classes? Every JS textbook describes *how* prototypes work — `__proto__`, prototype chain, `Object.create` — but rarely *why* Brendan Eich and the early ECMA committee picked this model when class-based OOP was the dominant paradigm in 1995.

This note works through Steen's argument that prototypes are not a degenerate form of classes but a *philosophically distinct* model with its own coherent logic.

## The two models

### Class-based OOP (Smalltalk, Java, C++)

- A class is a **template**. It defines the shape of objects.
- An instance is a **manifestation** of the template.
- Inheritance is **template extension**: a subclass inherits and refines the template.
- Identity lives at the class level. "Is this object a Dog?" → check its class.

### Prototype-based OOP (Self, JavaScript)

- A prototype is **another object**. There is no separate "template" abstraction.
- New objects are created by **cloning** an existing object and modifying it.
- Inheritance is **delegation**: when a property isn't found on the object, look it up on the prototype object.
- Identity lives at the object level. "Is this object like Buddy?" → trace its delegation chain.

The asymmetry: class-based systems have **two kinds of things** (classes and instances); prototype-based systems have **one kind of thing** (objects, some of which serve as prototypes for others).

## Steen's philosophical reading

Steen argues this is not a technical choice but a **stance on what categories are**.

The class-based model is **Platonic**: there exists an ideal Dog (the class), and individual dogs (instances) are imperfect realizations of that ideal. Categories are prior to and shape examples.

The prototype-based model is **Wittgensteinian**: there is no Platonic ideal. There are particular dogs. The category "Dog" emerges from family resemblance among the particular dogs we've encountered. Categories are downstream of examples.

> This is the most interesting move in the paper for me. JS's prototype model is often described as "limitation" or "weird" — Steen reframes it as a coherent philosophical commitment.

## How this maps to JS quirks

If you take the Wittgensteinian framing seriously, several "weird" JS behaviors become legible:

### Why `this` is dynamically scoped

In a class system, `this` refers to the instance under construction — a stable, template-defined notion. In a prototype system, there's no stable "instance"; `this` has to refer to whatever object the function is currently being applied to. Hence the runtime context binding and the `bind` / `call` / `apply` family.

This isn't a JS *bug*; it's the consistent consequence of the model.

### Why hoisting feels strange

Class systems can compile-time-link declarations because the template is known statically. Prototype systems delay binding until runtime because objects are mutable and prototypes can be reassigned. Hoisting is the partial concession — declarations are surfaced, but assignments are not — to give the parser some statically resolvable structure.

### Why ES6 `class` is described as "syntactic sugar"

ES6 classes don't change the underlying model. They give us a class-like *syntax* (`class Foo extends Bar`) but the runtime still does prototype-chain lookup. This is consistent with the Wittgensteinian framing: the philosophical commitment didn't change, the surface ergonomics did.

## What I think the paper gets right

Steen's framing — prototypes as a philosophical commitment, not a workaround — explains JS more cleanly than the standard "Eich didn't have time" narrative does.

Eich did have constraints (Netscape's 10-day deadline), but he also had **influences**: Self (the prototype-based language from Sun) was a deliberate research project. Picking Self's model over Java's wasn't accidental.

## What I think the paper underemphasizes

The class-based vs prototype-based distinction has gotten **harder to feel** since 1996. Real-world JS code is mostly written in a class-like idiom even when the runtime is prototypes. TypeScript's type system is a Platonic overlay on a Wittgensteinian runtime. ES6+ syntactic sugar smooths the seam.

A 2026 follow-up to Steen would need to address: how much philosophical commitment survives the layers of ergonomic abstraction we've added? My intuition: less than Steen's framing suggests, but more than zero. The places where the philosophy still bites are the bug surfaces: dynamic `this`, prototype pollution, the inability to fully freeze a prototype chain.

## How to use this in interviews

Most JS interviews ask "explain prototypes" mechanically. If you've internalized the Wittgensteinian framing, you can answer mechanically *and* gesture at why the model is coherent. That second half makes the answer memorable in a way pure mechanics doesn't.

> Sample answer skeleton:
> 1. "Prototypes are objects, not templates. When you create a new object, JavaScript links it to a prototype object and delegates missing properties to it."
> 2. "This is sometimes described as a limitation, but it's actually a coherent design choice — class-based OOP commits to Platonic categories, prototype-based commits to Wittgensteinian family resemblance."
> 3. "This is also why `this` is dynamic and why hoisting feels strange — they're consequences of the model, not bugs."

## Related

- [[lec03-execution-context-and-this]] — companion technical note on `this` resolution
- [[review - the-pragmatic-programmer]] — peripherally related discussion of mental models
- [[MOC - language-design]] — primary entry point for this topic
- [[lec02-hoisting]] — covers the mechanism this note's philosophical framing explains

## TODO

- TODO: Read Self's original 1987 paper (Ungar & Smith) to verify Steen's characterization
- TODO: Cross-check against the ECMA TC39 archives for the 1995 decision rationale (might exist; Brendan Eich blogged about it)
- TODO: Write a follow-up "modern JS layers on top of prototypes" note
````

---

## Conventions applied

- §1 *Writing style* — distinguishes paper's argument from my synthesis (§1.6 personal commentary), inline TODOs for follow-up reading (§1.3)
- §2 *Frontmatter sticker* — `2753` (❓, question mark) — chosen because the central frame is a "why" question. Custom fields `source_paper` and `source_url` cite the literature source
- §3 *Heading* — h2 sections (Question, Two models, Steen's reading, Mapping to JS, What he gets right, What he underemphasizes, Interview use, Related, TODO), h3 for sub-points, no h1, no numbered headers
- §4 *Horizontal rule* — none used (the analytical arc is one continuous argument; hrs would interrupt the flow)
- §6 *Emphasis* — bold for technical terms on first introduction (`**template**`, `**delegation**`); blockquote for "the most interesting move" personal-commentary callout instead of bold (avoids hugging punctuation)
- §7 *Tags* — Domain (`#javascript`, `#language-design`), Type (`#literature-note`) — three tags, in the sweet spot. `#literature-note` signals this is synthesis-of-external-material, not pure original thought
- §8 *PARA* — `3. Resource/dev-references/` (reference material, not active project)
- §11 *Cross-links* — wikilinks to related lecture notes, MOC, and follow-up notes

The `> Sample answer skeleton` block at the end is a small opinionated pattern — using a blockquote inside a section to embed a structured answer template. Useful for notes that will be retrieved during interview prep.

Stage 1 self-check on this file: zero hits. Pass.

---

## Minimal template to start from

````markdown
---
sticker: emoji//2753
created: <YYYY-MM-DD>
source_paper: "<Author, 'Title', Year>"   # if a paper-based literature note
source_url: "<URL>"
tags:
  - <domain>               # e.g., javascript, distributed-systems, linguistics
  - <subdomain>            # e.g., language-design, consensus, semantics
  - literature-note        # signals synthesis-of-external-material vs original
---

> **Note type**: <literature note / analytical essay / framework deep-dive>. <what the external source is + what your contribution is>

## The question

<the central "why" question. Most reference notes are stronger when oriented around a question rather than around a topic.>

## The two (or three) models / positions / approaches

### <Model A>

- <defining feature>
- <how it handles the central question>

### <Model B>

- <contrasting feature>
- <how it handles the central question differently>

## <Author>'s reading / argument

<reconstruct the source's argument. What's the move that gives the paper / book its identity?>

> <the most interesting move quoted directly or paraphrased. Worth a callout.>

## How this maps to <modern context / your work / observable behavior>

### Why <observation 1>

<the author's framing predicts this observation>

### Why <observation 2>

<another consequence>

## What I think the source gets right

<your assessment, not a summary>

## What I think the source underemphasizes

<the gap or limitation. A literature note without this section is a fan letter.>

## How to use this in <interview / practice / argument>

> Sample structure: <a usable framing>

## Related

- [[<companion-note>]]
- [[MOC - <domain>]]

## TODO

- TODO: <primary-source verification>
- TODO: <follow-up reading>
````

