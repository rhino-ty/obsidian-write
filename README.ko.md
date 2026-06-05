# obsidian-write (한국어)

> 옵시디언 vault 노트 작성·편집 시 적용할 보편 컨벤션 SSoT(Single Source of Truth) 스킬.
> 헤더 깊이(h2~h4) · 구분선 위치 · 들여쓰기 · **CommonMark flanking 강조 깨짐 가드(한국어 최적화)** · sticker frontmatter · 5축 태그 모델 · PARA 분류 · 저장 후 grep self-check.

[![Made with](https://img.shields.io/badge/Made%20with-Claude%20Skills-blueviolet)](https://docs.claude.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![CJK optimized](https://img.shields.io/badge/CJK-optimized-blue)](#한국어-사용자에게-가장-가치-있음)
[![English README](https://img.shields.io/badge/English-README.md-blueviolet)](README.md)

---

## 이 스킬이 하는 일

모든 옵시디언 사용자는 노트 쓸 때마다 같은 미시 결정을 반복함 — 어느 헤더 레벨부터 시작할지, 구분선은 어디에 둘지, 태그는 어떤 축으로 쓸지, 볼드가 깨지지 않게 어떻게 쓸지. 이 스킬은 그 결정을 한 곳에 박아두는 *권위 문서*다.

1. **반복 결정이 사라진다.** 파일 열고, 컨벤션 따르고, self-check 돌리고, 저장.
2. **다른 작성 스킬이 위임한다.** 리뷰 노트 스킬, 강의 노트 스킬, 미래의 옵시디언 작성 스킬 모두 vault에서 `.claude/skills/obsidian-write/SKILL.md` 시그널을 감지하면 컨벤션 권위를 이쪽으로 위임함.
3. **한국어 작성자가 강조 깨짐을 진짜로 해결한다** — "볼드 조심해서 쓰자"가 아니라 마스터 룰 + 6패턴 + 안전 수정 + grep 검증.

**Opinionated 스킬**이지만 *계층화*돼 있음 — Core는 모든 옵시디언 사용자에게 가치, Recommended는 특정 설정(Make.md·한국어), Optional은 개인 운영 정책(PARA·5축 태그).

## 출력 언어는 사용자 언어를 따름

이 스킬은 **컨벤션 인프라**이지 컨텐츠 생성기가 아님. 컨벤션 자체는 다국어 청중을 위해 영어로 쓰여있지만 **생성하는 노트는 사용자 언어를 따름**.

- 한국어 요청 → 한국어 노트 (CJK 강조 깨짐 절차 자동 발동)
- 영어 요청 → 영어 노트
- 일본어 / 중국어 → 한국어와 동일 (CJK 절차 발동)
- 혼합 → 주된 언어 우선, 세그먼트별 검사

컨벤션이 영어라고 사용자 콘텐츠를 영어로 번역하지 *않음*.

## 한국어 사용자에게 가장 가치 있음

CommonMark의 flanking 규칙 때문에 `**볼드**`는 구분자 바로 안에 문장부호가 있고 바깥에 단어문자가 공백 없이 붙으면 깨짐. 영어에서는 가끔 발생:

```
❌ word**"text"**here       ← 깨짐
✅ word "**text**" here
```

한국어에서는 **계속** 발생함. 조사·어미가 공백 없이 `**`에 붙어서:

```
❌ **활용(exploitation)**과     ← 닫는 조사 `과`가 `)**` 다음에 붙음 → 깨짐
✅ **활용**(exploitation)과     ← 한글 용어만 볼드, 영문병기는 바깥
```

이 스킬은:
- 마스터 룰 한 줄 + 6 깨짐 패턴 + 보편 수정법
- CJK 전용 추가 절차 (`ref/cjk-language-extra-checks.md`)
- 저장 후 grep 4종 (Stage 1 — 잡히면 거의 진짜 깨짐)
- 한국어 학술 노트 최빈 케이스 ("영문 병기 + 조사")는 grep Check D로 정밀 포착

## 핵심 기능

- **컨벤션 SSoT** — 헤더·구분선·들여쓰기·강조·sticker·태그·PARA 한 곳에
- **계층 채택** — Core / Recommended / Optional, 자기 vault에 맞춰 선택
- **CJK 강조 깨짐 가드** — 마스터 룰 + 6 패턴 + 안전 수정 + grep 4-pack
- **위임 인터페이스** — vault 시그널로 다른 작성 스킬 자동 위임
- **저장 후 self-check** — Stage 1 좁은 grep (고신뢰) + Stage 2 광범 grep (보조) + Stage 3 hr 검증
- **모범 노트 8개** — 학습 / 수필 / 공략 / 정보성 / MOC / 폴더 스펙 / 데일리 / fix before-after
- **참고 자료** — CommonMark flanking 심화, 파서별 동작, CJK 전용 절차

## 디렉토리 구조

```
obsidian-write/
├── SKILL.md                              # 11절 컨벤션 SSoT + self-check
├── README.md                             # 영어 README
├── README.ko.md                          # 한국어 README (이 파일)
├── CHANGELOG.md
├── LICENSE                               # MIT
├── ref/
│   ├── emphasis-breakage-deep-dive.md    # CommonMark flanking 스펙 + 파서별 동작 +
│   │                                       6 패턴 + 위험 문자 카탈로그 + 통설 깨기
│   ├── cjk-language-extra-checks.md      # 한국어·일본어·중국어 전용 절차 — 언제 돌리고,
│   │                                       무엇을 검사하고, 왜 CJK가 다른지
│   ├── obsidian-syntax-reference.md      # Obsidian Flavored Markdown 카탈로그 —
│   │                                       위키링크, 블록 ID, 임베드, 콜아웃(풀 타입+별칭),
│   │                                       프로퍼티(1.4+ 타입), 코멘트, 하이라이트, 수식,
│   │                                       머메이드, 각주, 태스크 확장 상태, HTML 일부
│   ├── obsidian-plugin-essentials.md     # 첫 사용자 친화 플러그인 가이드 —
│   │                                       전제(Make.md/Dataview) / 권장 / 호환 3분류,
│   │                                       각 플러그인 "왜 필요한가" + 설치 + 검증 단계,
│   │                                       AI 안내 패턴(install→verify→confirm), 4단계 도입
│   ├── para-classification.md            # PARA 방법론 폴더 구조 + 폴더 스펙 노트 + 매체 중심
│   │                                       Resource 레이아웃 + 결정 룰 + 마이그레이션
│   │                                       (SKILL.md §8 분리 ref)
│   ├── delegation-for-skill-authors.md   # 다른 옵시디언 작성 스킬 개발자용 — 감지 시그널,
│   │                                       위임 가능/불가능 영역, 표준 위임 흐름, 흔한 실수,
│   │                                       버전 안정성 (SKILL.md §9 분리 ref)
│   └── agent-context-files.md            # CLAUDE.md / AGENTS.md / .cursorrules /
│                                           .codex.md / .windsurfrules 작성 — agent context
│                                           포맷 카탈로그, 옵시디언 vault용 8섹션 템플릿,
│                                           어떤 §1~§10 컨벤션 적용되는지, 단일/다중 파일
│                                           전략 + symlink 방법 (SKILL.md §12 분리 ref)
├── examples/
│   ├── example-academic-note.md          # 학습/강의 노트 (예: 컴퓨터 네트워크 강의)
│   ├── example-essay.md                  # 수필/자기 분석 노트
│   ├── example-guide.md                  # 공략/가이드 노트 (예: 게임 공략)
│   ├── example-tech-reference.md         # 정보성/분석 노트 (예: 논문 정리)
│   ├── example-moc.md                    # MOC (Map of Content) 인덱스 노트
│   ├── example-folder-spec-note.md       # 폴더 스펙 노트 (프로젝트/Area의 README 역할)
│   ├── example-daily-note.md             # 데일리 노트 / 저널
│   └── example-fix-before-after.md       # 깨진 노트 → grep → 수정 전과정 데모
└── scripts/
    └── audit-vault.sh                    # vault 전체 일괄 audit 셸 스크립트
```

각 example은 끝에 `## Minimal template to start from` 절을 포함해서 *완성 데모*와 *시작 스켈레톤* 둘 다 한 파일에 들어있음.

## 설치

```bash
npx skills add rhino-ty/obsidian-write
```

[vercel-labs/skills](https://github.com/vercel-labs/skills) CLI가 GitHub 레포에서 직접 SKILL.md를 가져와 Claude Code, Cursor, Codex 등 지원 에이전트에 설치. 옵션:

- `-g` / `--global` — 사용자 단위로 전역 설치 (모든 프로젝트에서 사용)
- `-a <agent>` — 특정 에이전트에만 설치 (예: `claude-code`)
- `--all` — 자동 확인 + 모든 에이전트에 설치

> **짝꿍 스킬 (옵시디언 + 리뷰 + 블로그 풀세트)**:
> ```bash
> npx skills add rhino-ty/polymedia-review-skill
> npx skills add rhino-ty/review-myblog-converter
> ```

## 사용 흐름

```
사용자가 옵시디언 vault에 .md 노트 작성·편집
  ↓
obsidian-write 트리거 (또는 다른 스킬이 이 스킬에 위임)
  ↓
Core 컨벤션 적용 (헤더 · 구분선 · 들여쓰기 · 강조)
  ↓
Recommended 적용 (CJK 절차 — 한국어/일본어/중국어 노트면, sticker — Make.md 쓰면)
  ↓
Optional 적용 (PARA 경로, 5축 태그, ADR 스타일 — 운영 정책에 맞으면)
  ↓
파일 저장·편집
  ↓
저장 후 self-check (Stage 1 필수, Stage 2/3 보조)
  ↓
통과 → 완료 보고.  잡힘 → §6 패턴으로 수정, 재검증, 보고.
```

## vault 전체 audit

```bash
# 전체 vault에서 깨짐 일괄 찾기
./scripts/audit-vault.sh /path/to/your/vault

# CJK 검사만 (한국어 vault용 빠른 모드)
./scripts/audit-vault.sh --cjk-only /path/to/your/vault

# 매 파일 진행 표시
./scripts/audit-vault.sh -v /path/to/your/vault

# 요약만 (CI에서 사용)
./scripts/audit-vault.sh -q /path/to/your/vault
```

종료 코드 0 = 깨끗, 비-0 = 깨짐 발견. CI 파이프라인 통합 가능.

## 트리거 발화 예시

- "이 노트 옵시디언 컨벤션대로 정리해줘"
- "볼드 깨진 데 있어?"
- "이 파일 self-check 돌려"
- "새 노트 작성 — \<주제\>" (vault 안에서)
- 다른 작성 스킬이 vault에서 발동하면 자동 위임

### 트리거 키워드 (한국어)

```
옵시디언, 노트 작성, 강조 깨짐, 볼드 깨짐, 헤더 규칙, 태그, 5축,
sticker, 스티커, frontmatter, PARA, vault 컨벤션, 볼트 컨벤션,
self-check, 포맷 검증, 노트 검증, 의사결정 기록, ADR
```

영어·일본어·중국어 등 다른 7개 언어 트리거는 [README.md](README.md) 참조.

### 트리거하지 않는 경우

- 옵시디언 vault 밖 일반 마크다운 작성 (이 스킬은 vault 전용)
- 인터랙티브 시각화 / `dataviewjs` 위젯 (시각화 전문 스킬 사용)
- 리뷰 노트 *자체* 작성 → [polymedia-review-skill](https://github.com/rhino-ty/polymedia-review-skill) (이 스킬에 포맷만 위임)
- 강의 노트 *자체* 작성 → 도메인 특화 강의 노트 스킬 (이 스킬에 위임)
- Logseq · Notion · Bear · 일반 마크다운 (각 생태계 컨벤션 다름)
- 옵시디언 노트 → 블로그 변환 → [review-myblog-converter](https://github.com/rhino-ty/review-myblog-converter)

## 모델 권장

이 스킬은 대부분 *규칙 적용 + grep*이라 가벼운 모델도 견딤. 다만 판단 호출(Stage 2 hit이 진짜 깨짐인지, 태그가 어느 축인지)은 복잡한 노트에서 강한 추론이 유리.

- ✅ 강함: Claude Opus / Sonnet 4.6+ · Gemini 2.5 Pro · GPT-o3 — 복잡한 노트, 애매한 태그 축 판단, CJK + Latin 혼합 세그먼트
- ✅ 적당: Claude Haiku 4.5+ · GPT-4o-mini — 단순 노트, 순수 기계적 self-check
- ❌ 피하기: 강한 양자화된 로컬 모델 — 유니코드 정규식 처리 부정확

## 라이선스

MIT. [LICENSE](LICENSE) 참조.

## Credits

- **CommonMark 스펙** — 이 스킬이 본질적으로 코드화하는 flanking 규칙
- **Niklas Luhmann의 Zettelkasten** — 5축 모델의 "태그는 가장 약한 연결" 직관 (§7)
- **Tiago Forte — PARA Method** — 선택적 폴더 분류 (§8)
- **Andy Hunt & David Thomas — *The Pragmatic Programmer*** — ADR 스타일 의사결정 기록 정신 (§1)
- **Make.md 플러그인** — `sticker: emoji//{hex}` frontmatter 규약 (§2)
- **짝꿍 스킬** — [polymedia-review-skill](https://github.com/rhino-ty/polymedia-review-skill) · [review-myblog-converter](https://github.com/rhino-ty/review-myblog-converter)
