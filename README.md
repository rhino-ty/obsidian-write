# obsidian-write

> 옵시디언 vault 노트 작성·편집 시 적용할 보편 컨벤션 SSoT(Single Source of Truth) skill.
> Heading(h2~h4) · 구분선(`---` h2 사이) · 들여쓰기(탭) · **CommonMark flanking 강조 깨짐 룰**(한국어 노트 필수) · sticker frontmatter · 5축 태그 모델 · PARA 분류.

[![Made with](https://img.shields.io/badge/Made%20with-Claude%20Skills-blueviolet)](https://docs.claude.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Korean optimized](https://img.shields.io/badge/Korean-optimized-blue)](#왜-한국어-사용자에게-특히-유용한가)

## 한 줄 요약

옵시디언 노트 작성할 때마다 반복적으로 떠오르는 규칙(Heading 깊이, 강조 깨짐, 태그 정책 등)을 한 곳에 모은 *권위 문서*. 다른 옵시디언 작성 스킬이 vault에서 이 파일을 발견하면 컨벤션을 이쪽에 위임한다.

## 누구에게 필요한가

- **한국어로 옵시디언 노트를 쓰는 사용자** — 한국어 조사(`이다`, `의`, `과`) 때문에 `**볼드**`가 영어보다 훨씬 자주 깨지는 문제를 마스터 룰 + 5종 깨짐 패턴 + 안전 수정 패턴 + grep self-check로 해결
- **여러 작성 스킬을 vault에 두는 사용자** — polymedia-review-skill(리뷰)·강의 노트 스킬·미래의 옵시디언 작성 스킬이 모두 이 한 곳을 참조하도록 위임 인터페이스 제공
- **PARA 방법론 + 5축 태그 + Make.md 이모지 패턴 채택자** — 검증된 컨벤션 묶음

## 채택 옵션 (코어 vs 권장 vs 선택)

| 분류 | 항목 | 적용 조건 |
|---|---|---|
| 코어 | Heading · 구분선 · 들여쓰기 · 강조 깨짐 룰 | 옵시디언이면 무조건 |
| 권장 | sticker frontmatter | Make.md 또는 폴더 이모지 관리 시 |
| 선택 | ADR 스타일 · 5축 태그 · PARA 분류 | 자기 운영 정책과 맞으면 |

코어 4개만 채택해도 옵시디언 노트 렌더링 깨짐은 거의 0. 나머지는 *opinionated* — 한 명의 사용자가 자기 vault에서 검증한 패턴.

## 왜 한국어 사용자에게 특히 유용한가

CommonMark flanking 규칙 — `**` 안쪽에 문장부호(`)`, `"`, `.` 등) + 바깥쪽에 단어문자가 있으면 강조가 죽는다. 영어는 단어 뒤 공백·구두점이라 잘 안 걸리지만, 한국어는 조사(`과`, `이다`, `의`)가 공백 없이 붙어서 *훨씬 자주* 깨진다.

```
❌ **활용(exploitation)**과   ← 한국어 학술 노트 최빈 케이스
✅ **활용**(exploitation)과   ← 한글 용어만 볼드, 영문병기 바깥
```

이 스킬은:
- 마스터 룰 한 줄 + 깨지는 패턴 5종 + 안전 수정 패턴 카탈로그
- 저장 후 자동 grep 4종(닫는 쪽·여는 쪽·h1·헤더 번호) — Stage 1만 깨끗하면 통과
- false positive 광범 grep 2종 (검증 보조)

## 트리거 예시

```
- "이 노트 마크다운 검사해줘"
- "강조 깨졌나 봐줘"
- "옵시디언 컨벤션대로 정리"
- "self-check 돌려"
- 새 .md 파일 작성 (vault 안)
- 다른 작성 스킬이 vault에서 노트를 만들 때 자동 위임
```

## 외부 스킬과의 관계

| 스킬 | 영역 | 위임 관계 |
|---|---|---|
| [polymedia-review-skill](https://github.com/rhino-ty/polymedia-review-skill) | 리뷰 노트 (책·게임·영화·음악) | 노트 시스템 어댑터에서 이 스킬 시그널 감지 → 자동 위임 |
| [review-myblog-converter](https://github.com/rhino-ty/review-myblog-converter) | 옵시디언 → 블로그 톤 변환 | 입력만 받아 변환, 직접 충돌 없음 |

미래의 옵시디언 작성 스킬도 동일한 위임 인터페이스(`.claude/skills/obsidian-write/SKILL.md` 존재 감지)로 연결 가능.

## 설치

Claude Code · Cursor · Codex 등 AI agent 환경의 스킬 디렉토리(`.claude/skills/` 또는 `~/.claude/skills/`)에 이 repo를 clone:

```bash
git clone https://github.com/rhino-ty/obsidian-write.git
```

또는 vault 안 `.claude/skills/` 아래에 두고 git submodule로 관리.

## 라이선스

MIT. 자유롭게 채택·수정. 강조 깨짐 룰(SKILL.md §6)은 한국어 사용자에게 특히 가치 있음.
