# example-fix-before-after.md

> A worked example of finding and fixing emphasis-breakage in an existing vault note. Walks through the full loop: open broken note → run `SKILL.md §10` Stage 1 grep → interpret hits → apply `SKILL.md §6` safe-rewrite patterns → re-grep to confirm. This is the most common usage pattern after Day 1 of adopting this skill.

---

## Scenario

You've been writing Korean academic notes for a year. You install this skill, run a vault audit per `ref/cjk-language-extra-checks.md §6`, and one note comes back with the most hits:

```
PARA/2. Area/computer-security/8강. 인증 및 접근통제.md
```

The note opens, looks plausibly fine in Live Preview, but in Reading View several bold spans render as literal `**asterisks**`. The grep audit confirmed there are 11 breakage instances. This walkthrough fixes them.

---

## The broken note (excerpt — before)

````markdown
---
sticker: emoji//1f510
created: 2025-11-12
reviewed: []
tags:
  - cs
  - security
  - concept
---

> **선행 강의**: 7강 (대칭키 암호). **이어지는 강의**: 9강 (보안 프로토콜).

## 인증의 3요소

인증(authentication)은 **사용자가 주장하는 신원이 진짜인지 검증**하는 절차다. 이를 위한 근거는 전통적으로 세 가지로 분류된다.

| 요소 | 영문명 | 예시 |
|---|---|---|
| 지식 기반 | something you know | 비밀번호, PIN |
| 소유 기반 | something you have | OTP 토큰, 스마트카드 |
| 생체 기반 | something you are | 지문, 홍채, 얼굴 |

각 요소가 **단독으로 사용되면(single-factor)**보안이 약하다. 두 요소 이상을 결합하면 **다중요소 인증(MFA, Multi-Factor Authentication)**이라고 한다.

## 접근통제 모델 — DAC vs MAC vs RBAC

세 가지 모델은 **누가 권한을 결정하는가**라는 질문에서 갈린다.

### DAC (임의적 접근통제)

- **자원 소유자(owner)**가 권한을 부여
- 유연하지만, 권한 위임 추적이 어려움
- 예: Unix 파일 시스템의 `chmod`

### MAC (강제적 접근통제)

- **시스템(security policy)**이 권한을 강제
- 사용자가 권한을 임의로 바꿀 수 없음
- 예: SELinux의 라벨 기반 정책

### RBAC (역할 기반 접근통제)

- **역할(role)**을 매개로 권한을 부여
- 사용자 → 역할 → 권한 매핑
- 대규모 조직에서 가장 흔함

## 비교

| 모델 | 권한 결정자 | 유연성 | 일관성 |
|---|---|---|---|
| **DAC**(임의적) | 자원 소유자 | 높음 | 낮음 |
| **MAC**(강제적) | 시스템 | 낮음 | 높음 |
| **RBAC**(역할 기반) | 관리자 | 중간 | 높음 |

## 자기 점검 질문

1. **MFA(Multi-Factor Authentication)**가 단일 요소보다 강한 이유는?
2. **DAC**과 **MAC**의 가장 큰 차이는 무엇인가?
3. **RBAC**에서 사용자 ↔ 권한 사이에 역할을 두는 이유는?
````

---

## Run Stage 1 grep

```bash
cd "PARA/2. Area/computer-security"

# Stage 1 (1) — closing-side break: punct inside `**` + word char outside
grep -nP '[\)\]"'\''\.,:;!?\$…—–]\*\*[가-힣A-Za-z0-9]' "8강. 인증 및 접근통제.md"
```

Output:

```
22:각 요소가 **단독으로 사용되면(single-factor)**보안이 약하다.
22:**다중요소 인증(MFA, Multi-Factor Authentication)**이라고 한다.
43:| **DAC**(임의적) | 자원 소유자 | 높음 | 낮음 |
44:| **MAC**(강제적) | 시스템 | 낮음 | 높음 |
45:| **RBAC**(역할 기반) | 관리자 | 중간 | 높음 |
51:1. **MFA(Multi-Factor Authentication)**가 단일 요소보다 강한 이유는?
```

6 hits. All are the same pattern: bold ending with `)` immediately followed by a Korean particle.

```bash
# Stage 1 (2) — opening-side break
grep -nP '[가-힣A-Za-z0-9]\*\*["\(\[\$「『]' "8강. 인증 및 접근통제.md"
```

Output:

```
43:| **DAC**(임의적) | 자원 소유자 | 높음 | 낮음 |
44:| **MAC**(강제적) | 시스템 | 낮음 | 높음 |
45:| **RBAC**(역할 기반) | 관리자 | 중간 | 높음 |
```

3 hits — but wait, these are *also* the table-row entries from above. The Stage 1 (1) grep already caught the closing `**` against `)`, and Stage 1 (2) caught the opening `**` against `(` after `DAC`/`MAC`/`RBAC`. *Both sides break in these three cases* — the worst pattern from `SKILL.md §6 Pattern 3`.

```bash
# CJK extra grep (ref/cjk-language-extra-checks.md §3 Check D)
grep -nP '\)\*\*(이|가|은|는|을|를|의|와|과|에|으로|에서|이다|이며|이고|하고|입니다)' "8강. 인증 및 접근통제.md"
```

Output:

```
22:각 요소가 **단독으로 사용되면(single-factor)**보안이 약하다.
22:**다중요소 인증(MFA, Multi-Factor Authentication)**이라고 한다.
51:1. **MFA(Multi-Factor Authentication)**가 단일 요소보다 강한 이유는?
```

3 hits — confirms the Korean gloss + particle pattern. Same lines as Stage 1 (1).

Total **unique** breakage lines: 22, 43, 44, 45, 51. Five lines.

---

## Diagnose each hit

### Line 22 — two breaks in one line

```
각 요소가 **단독으로 사용되면(single-factor)**보안이 약하다. 두 요소 이상을 결합하면 **다중요소 인증(MFA, Multi-Factor Authentication)**이라고 한다.
```

Pattern 4 from `SKILL.md §6`: Korean academic gloss + particle. Both bolds end with `)` and are followed by a Korean particle (`보안`, `이라고`).

**Fix** (`SKILL.md §6 Recipe A`): pull the gloss outside the bold.

```
각 요소가 **단독으로 사용되면**(single-factor) 보안이 약하다. 두 요소 이상을 결합하면 **다중요소 인증**(MFA, Multi-Factor Authentication)이라고 한다.
```

### Lines 43–45 — table cells

```
| **DAC**(임의적) | 자원 소유자 | 높음 | 낮음 |
| **MAC**(강제적) | 시스템 | 낮음 | 높음 |
| **RBAC**(역할 기반) | 관리자 | 중간 | 높음 |
```

Pattern 3 from `SKILL.md §6`: word-char on both sides of bold, punctuation inside. Both `**DAC**(임의적)` and `**MAC**(강제적)` and `**RBAC**(역할 기반)` break.

Wait — does `|` count as the "outside" character? Let's check. `|` is the table cell delimiter and acts as line-position punctuation, not as a word char. So actually `| **DAC**(임의적)` should be safe on the opening side (` ` after `|` is whitespace). But the closing `**DAC**` is followed by `(임의적)` directly — `(` is opening punctuation inside the bold? No, `(` is *outside* the closing `**` here.

Re-reading: `**DAC**(임의적)` — closing `**` is preceded by `C` (letter, inside the bold) and followed by `(` (punctuation, outside). The flanking rule says the closing must NOT be preceded by punctuation OR (preceded by punctuation AND followed by punctuation or whitespace). Here: preceded by letter (good), followed by `(` punctuation — actually this is fine for closing.

So `**DAC**(임의적)` *should not* break. Let me re-check the grep.

The grep `[가-힣A-Za-z0-9]\*\*["\(\[\$「『]` matches `C**(`. But that doesn't mean it breaks. This is a **Stage 1 (2) false positive** — the grep flags the case but the actual rendering is fine because:

- Outside closing `**`: `(` (punctuation, but flanking spec gives leniency for punctuation-flanking)
- Inside closing `**`: `C` (letter — safe)

Per `SKILL.md §10` advice: "Stage 1 hits are *almost* always real, but verify."

In practice: `**DAC**(임의적)` renders correctly. The grep flagged a borderline pattern that turns out to be safe. **No fix needed** on lines 43–45.

> ⚠️ Lesson: Even Stage 1 has occasional false positives at the *table-cell + word-immediately-after-bold + opening-paren* boundary. Always verify in Reading View.

### Line 51 — self-check question

```
1. **MFA(Multi-Factor Authentication)**가 단일 요소보다 강한 이유는?
```

Pattern 4 again. Closing `**` against `)` + Korean particle `가`.

**Fix**: pull the gloss outside the bold.

```
1. **MFA**(Multi-Factor Authentication)가 단일 요소보다 강한 이유는?
```

---

## The fixed note (excerpt — after)

````markdown
---
sticker: emoji//1f510
created: 2025-11-12
reviewed:
  - 2026-06-05      # newly added — note revisited & fixed today
tags:
  - cs
  - security
  - concept
---

> **선행 강의**: 7강 (대칭키 암호). **이어지는 강의**: 9강 (보안 프로토콜).

## 인증의 3요소

인증(authentication)은 **사용자가 주장하는 신원이 진짜인지 검증**하는 절차다. 이를 위한 근거는 전통적으로 세 가지로 분류된다.

| 요소 | 영문명 | 예시 |
|---|---|---|
| 지식 기반 | something you know | 비밀번호, PIN |
| 소유 기반 | something you have | OTP 토큰, 스마트카드 |
| 생체 기반 | something you are | 지문, 홍채, 얼굴 |

각 요소가 **단독으로 사용되면**(single-factor) 보안이 약하다. 두 요소 이상을 결합하면 **다중요소 인증**(MFA, Multi-Factor Authentication)이라고 한다.

## 접근통제 모델 — DAC vs MAC vs RBAC

세 가지 모델은 **누가 권한을 결정하는가**라는 질문에서 갈린다.

### DAC (임의적 접근통제)

- **자원 소유자**(owner)가 권한을 부여
- 유연하지만, 권한 위임 추적이 어려움
- 예: Unix 파일 시스템의 `chmod`

### MAC (강제적 접근통제)

- **시스템**(security policy)이 권한을 강제
- 사용자가 권한을 임의로 바꿀 수 없음
- 예: SELinux의 라벨 기반 정책

### RBAC (역할 기반 접근통제)

- **역할**(role)을 매개로 권한을 부여
- 사용자 → 역할 → 권한 매핑
- 대규모 조직에서 가장 흔함

## 비교

| 모델 | 권한 결정자 | 유연성 | 일관성 |
|---|---|---|---|
| **DAC**(임의적) | 자원 소유자 | 높음 | 낮음 |
| **MAC**(강제적) | 시스템 | 낮음 | 높음 |
| **RBAC**(역할 기반) | 관리자 | 중간 | 높음 |

## 자기 점검 질문

1. **MFA**(Multi-Factor Authentication)가 단일 요소보다 강한 이유는?
2. **DAC**과 **MAC**의 가장 큰 차이는 무엇인가?
3. **RBAC**에서 사용자 ↔ 권한 사이에 역할을 두는 이유는?
````

---

## Re-run grep to confirm

```bash
# All Stage 1 + CJK extra
grep -nP '[\)\]"'\''\.,:;!?\$…—–]\*\*[가-힣A-Za-z0-9]' "8강. 인증 및 접근통제.md"
grep -nP '\)\*\*(이|가|은|는|을|를|의|와|과|에|으로|에서|이다|이며|이고|하고|입니다)' "8강. 인증 및 접근통제.md"
```

Output: empty.

Stage 1 (2) still returns the three table-cell lines (as expected — they're rendering correctly despite triggering the grep). Document this as the verified-safe exception, move on.

---

## Lessons from this exercise

1. **Korean academic notes with English glosses are the highest-frequency breakage source.** If your vault has lecture notes with `**한국어 용어(English Gloss)**Korean particle` patterns, expect double-digit hits on first audit.

2. **The fix is mechanical.** All five breakage lines used `Recipe A` (move the gloss outside the bold). Once you've internalized this, you can edit at type-time without referring back.

3. **Stage 1 has rare false positives at `**WORD**(.. ..)` table cells.** Verify the actual render in Reading View when the grep flags a pattern that "looks fine" in Live Preview.

4. **Updating `reviewed:` frontmatter at fix-time is a useful habit.** The fixed note now has a record that 2026-06-05 was when it was last revisited, supporting any spaced-repetition workflow.

5. **The fix is also a chance to re-tag.** While in the file, check if any obsolete tags should drop or new ones added. Don't make this a separate pass.

---

## Conventions applied (to this example itself)

- §3 *Heading* — h2 sections (Scenario, Before, Run Stage 1 grep, Diagnose, After, Re-run, Lessons, Conventions), h3 for individual hit diagnoses
- §6 *Emphasis* — every `**bold**` in the demonstration code is intentional; the broken examples are flagged as ❌ explicitly so the grep self-check (if run on this example file) would flag them as expected behavior — they're teaching code, not real prose
- §11 *Cross-links* — none; this is a standalone demo

Note on false-positive: when you run Stage 1 grep on *this* example file, it WILL flag the broken examples shown in `## The broken note (excerpt — before)`. That's expected; the broken code is the *content* of the example. False-positive in the sense that "the broken code is intentional".

---

## Minimal template to start from

This example is workflow-shaped, not note-shaped, so the "template" is really a checklist:

```
1. Identify candidate note (vault audit grep, or someone reported breakage)
2. Open file. Run SKILL.md §10 Stage 1 grep 4-pack
3. Run ref/cjk-language-extra-checks.md §3 grep if CJK
4. List the breakage lines
5. For each: identify which SKILL.md §6 pattern (1-6) it is
6. Apply matching SKILL.md §6 fix recipe (A-D)
7. Update `reviewed:` frontmatter to today's date (optional)
8. Re-run grep to confirm
9. Open Reading View, scan for any visually-broken bold that grep missed
10. Save
```

Keep this checklist in your weekly maintenance routine if your vault is CJK-heavy. Once-a-quarter audit + on-touch fixes balance thoroughness with effort.
