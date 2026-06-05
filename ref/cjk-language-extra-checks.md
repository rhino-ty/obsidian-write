# CJK Language Extra Checks

> When a note is written in Korean, Japanese, Chinese, or mixed CJK + Latin, run this extra procedure after `SKILL.md` §10 Stage 1. CJK particles, postpositions, and joining characters create breakage patterns that Stage 1's narrow grep can miss.

## 1. Why CJK is different

In **Latin** text, words are separated by spaces. Punctuation usually sits at the end of a word, with whitespace before the next word. This naturally satisfies CommonMark's flanking rule — `**bold**.` works because the closing `**` has a letter inside and `.` outside, then whitespace before the next word.

In **CJK** text:

| Language | Particles / joiners attached without whitespace |
|---|---|
| **Korean** (한국어) | 조사 (postpositional particles): 이/가/은/는/을/를/의/와/과/에/에서/으로/이다/이며/이고/하고/입니다 |
| **Japanese** (日本語) | 助詞 (particles): は/が/を/に/で/と/の/から/まで/より/って/だ/です |
| **Chinese** (中文) | 虚词 (function words): 的/了/着/过/也/都/还/就/才 (less attached than Korean/Japanese but still appears) |

These attach to whatever precedes them with **no whitespace**. When the preceding token ends with `**`, the closing delimiter sees a word character outside and (often) punctuation inside — which is exactly the breakage condition.

### Korean is the hardest case

Korean particles are mandatory and morphologically attached. Every noun in running prose has a particle. So `**term**`-then-particle is the *default* sentence structure:

```
**개념**이 (the concept is...)         ← 이 attaches
**기술**을 (the technology, accusative) ← 을 attaches
**방법**으로 (by means of...)          ← 으로 attaches
**결정**의 (of the decision)           ← 의 attaches
```

These are *safe* as written (letter inside `**`, particle outside). But the moment punctuation enters:

```
❌ **결정(decision)**으로
❌ **방법은,**즉
❌ **개념"강조"**이며
```

→ closing delimiter breaks.

### Japanese is similarly fragile

Japanese particles attach like Korean's, with similar fragility:

```
✅ **概念**は (the concept is)
✅ **技術**を (the technology, accusative)
❌ **概念(concept)**は    ← `)` inside + `は` outside → breaks
❌ **方法。**つまり       ← `。` (Japanese period) inside + `つ` outside → breaks
```

Also note: **Japanese punctuation** (`。`, `、`, `」`, `』`) are Unicode punctuation, so they trigger flanking failures identically to ASCII `.`, `,`.

### Chinese is the gentlest CJK case

Chinese has fewer mandatory particles (no postpositional inflection), and many sentences flow without attached function words. But it still hits breakage in technical writing:

```
❌ **概念(concept)**的实现       ← `)` inside + `的` outside → breaks
❌ **方法。**因此                 ← `。` inside + `因` outside → breaks
✅ **概念**(concept)的实现       ← fix
✅ **方法**。因此                ← fix
```

The mitigation: Chinese authors hit breakage less *frequently*, but the cases are identical when they do happen.

---

## 2. When to run this extra procedure

After SKILL.md §10 Stage 1 completes, run this extra check if **any of the following** is true:

- The note contains any Korean (한글) character
- The note contains any Japanese (ひらがな, カタカナ) — Han alone is ambiguous (could be Chinese)
- The note contains Han characters AND CJK punctuation (`。`, `、`, `」`)
- The user requested the note in a CJK language even if the current draft is mostly Latin

If unsure: **run it anyway**. The extra check is fast (just grep) and false-positives are cheap.

---

## 3. Extra grep procedure

These checks use Unicode property classes to catch all CJK scripts. Requires `grep -P` (Perl-compatible) with Unicode support.

### Check A — CJK closing-side break (extends Stage 1)

```bash
# Closing ** preceded by punctuation + followed by CJK character
grep -nP '[\)\]"'\''\.,:;!?\$…—–。、」』]\*\*[\p{Hangul}\p{Hiragana}\p{Katakana}\p{Han}]' *.md
```

Difference from Stage 1: this version includes CJK punctuation (`。`, `、`, `」`, `』`) on the *inside* of the closing `**`, which Stage 1 might omit on simpler grep environments.

### Check B — CJK opening-side break

```bash
# Opening ** preceded by CJK character + followed by opening punctuation
grep -nP '[\p{Hangul}\p{Hiragana}\p{Katakana}\p{Han}]\*\*["\(\[\$「『]' *.md
```

### Check C — Japanese-specific full-width punctuation break

```bash
# Closing ** against full-width Japanese/Chinese punctuation + CJK char outside
grep -nP '[。、！？：；]\*\*[\p{Hangul}\p{Hiragana}\p{Katakana}\p{Han}]' *.md
```

### Check D — Korean particle attached to bold + inner punctuation

This is the **#1 most common Korean breakage** — gloss + particle:

```bash
# **term(gloss)**Korean-particle
grep -nP '\)\*\*[이가은는을를의와과에로]\b' *.md
grep -nP '\)\*\*(이다|이며|이고|하고|입니다|으로|에서)' *.md
```

### Check E — Mixed CJK + Latin in same bold span

Sometimes the bold span itself mixes scripts, which is fine, but check anyway:

```bash
# Bold containing both CJK and Latin — usually OK but worth eyeballing
grep -nP '\*\*[^*]*[\p{Hangul}\p{Hiragana}\p{Katakana}\p{Han}][^*]*[A-Za-z][^*]*\*\*' *.md
grep -nP '\*\*[^*]*[A-Za-z][^*]*[\p{Hangul}\p{Hiragana}\p{Katakana}\p{Han}][^*]*\*\*' *.md
```

---

## 4. Common CJK breakage scenarios → fixes

### Korean — academic gloss + particle (highest frequency)

```
❌ **활용(exploitation)**과 탐사(exploration)
✅ **활용**(exploitation)과 탐사(exploration)

❌ **강화학습(RL)**에서 가장 중요한
✅ **강화학습**(RL)에서 가장 중요한
```

### Korean — quoted concept + particle

```
❌ 이건 **"한 우물 파기"**이다
✅ 이건 "**한 우물 파기**"이다

❌ - **"핵심 개념"**이란
✅ - "**핵심 개념**"이란
```

### Korean — math in academic note + particle

```
❌ **데이터 $D$**에 적용
✅ **데이터** $D$**에 적용**    ← split into two bolds (intentional emphasis)
✅ **데이터 $D$에 적용**         ← extend bold over the particle
```

### Japanese — particle + comment punctuation

```
❌ **概念。**つまり次のような
✅ **概念**。つまり次のような

❌ **手法(method)**は
✅ **手法**(method)は
```

### Chinese — title + function word

```
❌ **概念。**因此我们需要
✅ **概念**。因此我们需要

❌ **方法(method)**的实现
✅ **方法**(method)的实现
```

### Mixed CJK + Latin — code reference + particle

```
❌ `useState`**훅**의 동작        ← actually safe; `useState` ends with letter inside ` `, **훅** is bold with letters inside
✅ same                          ← already OK

❌ **`useState` hook**을           ← closing ** against ` (backtick) + Korean particle outside → breaks
✅ **`useState` hook**으로 알려진  ← still broken
✅ The **`useState`** hook 을      ← split
✅ `useState` 훅을 **사용해서**    ← reorganize so bold doesn't hug backtick
```

---

## 5. The final verification step for CJK notes

Before reporting "done" to the user, for any CJK note:

1. ✅ Stage 1 (SKILL.md §10) — all four grep checks return empty
2. ✅ Check A and B above (this file) — return empty
3. ✅ If Japanese: Check C returns empty
4. ✅ If Korean: Check D returns empty
5. ✅ Check E hits eyeballed (mostly false-positives, but quick to verify)
6. ✅ Visually scan the note in Reading View if any complex emphasis exists (math + bold + particle is the worst combination)

Only after all six pass is the note "ready". CJK-language notes that pass only Stage 1 may still have hidden breakage.

---

## 6. Editing existing CJK vault — bulk audit

To find existing breakage across a whole CJK vault:

```bash
cd /path/to/vault

# All Korean breakage candidates
grep -rnP '[\)\]"'\''\.,:;!?\$…—–。、」』]\*\*[\p{Hangul}]' --include='*.md' .

# All Japanese breakage candidates
grep -rnP '[\)\]"'\''\.,:;!?\$…—–。、」』]\*\*[\p{Hiragana}\p{Katakana}]' --include='*.md' .

# All Chinese-only (Han without kana) candidates — may include false positives from Japanese kanji
grep -rnP '[\)\]"'\''\.,:;!?\$…—–。、」』]\*\*[\p{Han}]' --include='*.md' .

# Korean academic gloss pattern (highest signal)
grep -rnP '\)\*\*(이|가|은|는|을|를|의|와|과|에|으로|에서|이다|이며|이고|하고|입니다)' --include='*.md' .
```

Expect a CJK-heavy vault accumulated over years to have **hundreds of hits**. Don't try to fix all at once — prioritize:

1. Active study/work notes (PARA Projects + Areas)
2. Recently edited notes (`find . -name '*.md' -mtime -30`)
3. Notes that ranked high in search/MOC traffic
4. Everything else (Resource, Archives) — fix on touch, not in bulk

---

## 7. Editor settings that help

While this skill is convention-as-prompt (not a linter), these editor setups reduce the rate of breakage at type-time:

- **Obsidian Linter plugin** — enable "Move emphasis around punctuation" rules. Won't catch everything (CJK particle awareness is limited) but catches Latin patterns reliably.
- **Markdownlint extension (VS Code)** with the "no-emphasis-as-heading" rule
- **Prettier-markdown** — non-Obsidian but useful for export pipelines

None of these replace the SKILL.md §6 internalization or this extra CJK procedure. They're at-type-time safety nets.

---

## 8. Acknowledgments

The CJK fragility was originally documented by Korean Obsidian users on the Korean Markdown Forum and consolidated into the rule set this skill packages. Patterns 4–6 (list items, math, mixed scripts) emerged from actual Korean academic note corpora.
