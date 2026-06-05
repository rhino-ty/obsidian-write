# Emphasis-Breakage Deep Dive

> The full CommonMark flanking spec walkthrough, per-parser behavior comparison, all six breakage patterns with safe rewrites, the risky-character catalog, and myth-busting. Referenced from `SKILL.md` §6.

## 1. Why this happens — CommonMark flanking rule

CommonMark defines emphasis delimiters (`*` and `_`) using two predicates: **left-flanking** and **right-flanking**.

### Left-flanking delimiter run

A delimiter run is **left-flanking** if:
1. It is **not followed by Unicode whitespace**, AND
2. Either:
   - It is **not followed by a Unicode punctuation character**, OR
   - It is followed by a punctuation character AND **preceded by Unicode whitespace or a punctuation character**.

### Right-flanking delimiter run

A delimiter run is **right-flanking** if:
1. It is **not preceded by Unicode whitespace**, AND
2. Either:
   - It is **not preceded by a Unicode punctuation character**, OR
   - It is preceded by a punctuation character AND **followed by Unicode whitespace or a punctuation character**.

### How it interacts with `**`

For `**` to act as a *opening* bold delimiter, it must be **left-flanking**. For it to act as a *closing* bold delimiter, it must be **right-flanking**. If both conditions are satisfiable, `*` (single) is *intraword*-restricted; `**` is more permissive but still bound by these rules.

The pathological case for **`**`** in mixed text:

| Position | Outside char | Inside char | Result |
|---|---|---|---|
| Opening `**` | word | whitespace | ✅ left-flanks, OK |
| Opening `**` | word | punctuation | ❌ not left-flanking → does not open |
| Closing `**` | whitespace | word | ✅ right-flanks, OK |
| Closing `**` | word | punctuation | ❌ not right-flanking → does not close |

When *one* delimiter fails to flank correctly, the pair never matches, and the entire span renders as literal asterisks.

### Spec reference

CommonMark 0.31.2 §6.2 — Emphasis and strong emphasis.
<https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis>

The flanking rule was introduced to prevent `snake_case_variable` from rendering as emphasis. The same protection that helps Latin programmers hurts CJK note-authors because their particles look like word characters to the regex.

---

## 2. Per-parser behavior

All four reference parsers agree on the flanking-rule outcomes for the patterns in this skill:

| Parser | Used by | Behavior |
|---|---|---|
| **cmark** | GitHub-Flavored Markdown, GitLab, Pandoc | Strict CommonMark — breaks per spec |
| **markdown-it** | Obsidian (legacy mode), many Node tools | CommonMark-compliant — breaks identically |
| **@lezer/markdown** | Obsidian (Live Preview), CodeMirror 6 | Lezer's incremental parser follows the same flanking logic — breaks identically |
| **marked** | Many JS frameworks | Approximate CommonMark with quirks — *mostly* identical, occasional permissive divergence |

**Key takeaway**: this is not an Obsidian-specific bug or a Live-Preview quirk. The same Korean line breaks on GitHub, GitLab, Pandoc, and Notion's import.

### How to verify yourself

Take any pattern from §3 below, paste it into:
- <https://spec.commonmark.org/dingus/> (cmark reference)
- <https://markdown-it.github.io/>
- Obsidian Reading View

All three produce the same broken render.

---

## 3. The six breakage patterns

### Pattern 1 — Closing-side, word-char outside (most common)

```
**text(gloss)**word        ← `)` inside + word char outside → breaks
**bold.**next               ← `.` inside + word outside → breaks
**conclusion,**however      ← `,` inside + word outside → breaks
**활용(exploitation)**과    ← `)` inside + Korean particle 과 → breaks
```

**Fix** — move punctuation outside, or extend bold to include the trailing word:

```
**text**(gloss) word        ✅
**bold**. next              ✅
**conclusion**, however     ✅
**활용**(exploitation)과    ✅
```

### Pattern 2 — Opening-side, word-char outside

```
word**(parenthetical)** here    ← `(` inside opening + word outside → breaks
word**"quote"** here            ← `"` inside opening + word outside → breaks
이건**"한 우물 파기"**이다       ← both sides break
```

**Fix**:

```
word (**parenthetical**) here   ✅
word "**quote**" here           ✅
이건 "**한 우물 파기**" 이다     ✅
```

### Pattern 3 — Both sides simultaneously

```
word**"text"**word
이건**(괄호 안)**이다
3rd**「concept」**구현
```

Both opening and closing fail to flank. Even more clearly broken.

**Fix**: move punctuation outside on both sides.

### Pattern 4 — List items, closing-side

Bullet `- ` provides whitespace before the opening `**`, saving the opening side. But the closing side still breaks if punctuation is inside + word outside:

```
- **"core concept"**means         ← closes against `"` + `means` outside → breaks
- **결론(요약)**으로              ← Korean equivalent
- **option A.**and                 ← `.` inside + `and` outside
```

**Fix** — punctuation outside on the closing side:

```
- "**core concept**" means        ✅
- **결론**(요약)으로              ✅
- **option A**. and                ✅
```

### Pattern 5 — Math inside bold (academic notes)

```
**dataset $D$**applies     ← closing `**` immediately after `$` + word outside → breaks
**smallest $x$ in $p-1$**case
```

The `$` (math delimiter) is punctuation. Closing `**` against `$` plus a word char outside → breaks.

**Fix** — pull the math outside the bold, or extend the bold to include the trailing word:

```
**dataset** $D$ applies    ✅  ← cleanest
**dataset $D$ applies**    ✅  ← extend bold
```

### Pattern 6 — Emoji or symbol mid-bold

Final character of bold is `·`, `&`, or similar middle-dot symbol:

```
**A·B·C·**however           ← closing `·` + word outside → breaks
**word & **next             ← trailing space inside? actually OK if there's a space
```

**Fix** — make sure the final character inside `**` is a letter, not a connector punctuation:

```
**A·B·C**, however         ✅
**word and** next          ✅
```

---

## 4. The risky-character catalog

Characters that, when sitting *immediately inside* `**` (against the delimiter), make breakage likely if the outside is a word char.

| Class | Characters |
|---|---|
| **Basic punctuation** | `.` `,` `:` `;` `!` `?` |
| **Quotes & brackets** | `"` `'` `(` `)` `[` `]` `「` `」` `『` `』` `“` `”` `‘` `’` `«` `»` |
| **Dashes & ellipsis** | `—` `–` `…` |
| **Math & meta** | `$` `※` `~` `` ` `` `>` `/` `\` |
| **Risky only at the very end** | `·` `&` (middle position is safe, terminal breaks) |

Safe characters (won't trigger break by themselves, against `**`):

| Class | Characters |
|---|---|
| **Letters (any script)** | Latin · Han · Hiragana · Katakana · Hangul · Cyrillic · Greek · etc. |
| **Digits** | 0-9 |
| **Whitespace** | space, tab, newline (whitespace on both sides is always safe) |

---

## 5. Safe rewrite recipes

### Recipe A — Move the offender outside

Best for quotes, parentheses, English glosses next to bold:

```
❌ word**(note)**follows
✅ word (**note**) follows

❌ **활용(exploitation)**과
✅ **활용**(exploitation)과
```

### Recipe B — Extend the bold to include the trailing word

Best for math + particle, when you want the whole phrase emphasized:

```
❌ **data $D$**applies
✅ **data $D$ applies**
```

### Recipe C — Add whitespace on both sides

Sometimes the simplest fix; check if it changes the *meaning* of emphasis:

```
❌ word**bold**word
✅ word **bold** word     (now bold + spaces; may not match intent)
```

### Recipe D — Reorganize the sentence

If the bold target naturally hugs punctuation, rewrite to put the bold in a position where it doesn't have to:

```
❌ The **"key takeaway"**of this chapter
✅ The key takeaway of this chapter: **<actual phrase>**
```

---

## 6. Myth-busting

### "It's a Live Preview bug — Reading View renders fine"

No. Live Preview uses `@lezer/markdown`, Reading View uses `markdown-it` (Obsidian's variant). Both follow the same flanking rules. If it breaks in Live Preview, it breaks in Reading View too. You may just not have noticed.

### "SmartyPants ate my quotes"

SmartyPants (curly-quote conversion) is **orthogonal** to flanking. Curly `"` and `'` are also Unicode punctuation — they trigger the same flanking failures. SmartyPants makes nothing worse and nothing better. It just changes the visible glyph.

### "Use `_..._` instead, it's safer"

No, it's worse. The underscore has **intraword-emphasis restriction** that the asterisk doesn't — `_foo_bar_` is *never* emphasis, even when the asterisk would succeed. So underscores fail in *more* cases, not fewer.

### "Standalone `**"quote"**` always breaks"

Wrong. `**"quote"**` *by itself* on a line, with whitespace outside, renders fine. It breaks when a word char joins the outside:

```
**"quote"**          ✅ standalone — renders bold + quoted
**"quote"**rest       ❌ word outside → breaks
이건 **"인용"**이다    ❌ Korean particle outside → breaks
```

### "GitHub Markdown is more permissive"

GitHub uses cmark with extensions (GFM). The extensions add tables, task lists, strikethrough, autolinks — but the emphasis rules are pure CommonMark. No permissiveness on flanking.

### "I'll just escape with `\`"

`\**` produces a literal `*` followed by `*`. You can use it once or twice, but you can't escape the `*` inside an intended bold span without breaking the span. The fix is structural (move punctuation, reorganize), not escape-based.

---

## 7. Testing your own corpus

Run this against your vault to find existing breakage:

```bash
cd /path/to/vault

# Stage 1 closing-side break (highest signal)
grep -rnP '[\)\]"'\''\.,:;!?\$…—–]\*\*[가-힣\p{Han}\p{Hiragana}\p{Katakana}A-Za-z0-9]' --include='*.md' .

# Stage 1 opening-side break
grep -rnP '[가-힣\p{Han}\p{Hiragana}\p{Katakana}A-Za-z0-9]\*\*["\(\[\$「『]' --include='*.md' .
```

CJK heavy vault: expect many hits on first run. Latin-only vault: usually zero or near-zero.

For per-file batch fixing, see `SKILL.md` §10 Stage 1 grep + §6 fix patterns.

---

## 8. Why this skill encodes the rule rather than relying on a plugin

Obsidian community plugins like "Linter" and "Markdownlint" exist, but:

1. They don't catch flanking-rule breakage by default (the spec compliance requires Unicode-aware regex)
2. They run on save, not at AI-write time — the LLM that produced the broken text never sees the fix
3. They require setup per vault, vs this skill which is convention-as-prompt

Encoding the rule in this skill means the LLM **prevents** the break at write time, instead of relying on post-hoc linting.
