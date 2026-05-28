---
description: vault의 무결성을 점검하고 정리할 항목을 보고한다
---

## 컨텍스트 (먼저 읽기)

- **Vault root**: `__VAULT_ROOT__/`
- 모든 스캔은 vault root 기준으로 실행하세요(`grep -r`, `find`, frontmatter 파싱 등). 호출 시 cwd가 vault가 아니어도 마찬가지.
- 작업 전에 `__VAULT_ROOT__/AGENTS.md`를 읽어 컨트랙트(폴더 규칙, frontmatter 표준)를 적용하세요. lint 기준이 컨트랙트에서 옵니다.

vault 전체를 스캔해 **수리할 수 있는 문제**를 보고합니다. 자동 수리는 하지 않고 보고만 — 사용자가 어떤 항목을 수리할지 결정합니다.

## 점검 항목

1. **깨진 wikilink**: `[[X]]` 인데 `X.md`가 존재하지 않는 경우.
2. **고아 노트**: 어떤 노트에서도 링크되지 않는 노트 (Daily, Meeting 제외 — 시간성 노트는 고아일 수 있음).
3. **누락 frontmatter**: 필수 필드(`title`, `created`, `type`, `status`) 누락 또는 빈 값.
4. **Inbox 정체**: `00-Inbox/`에 30일 이상 묵은 노트.
5. **TODO 미해결**: 본문에 `# TODO` 또는 `[ ]` 인데 7일 이상 손대지 않은 항목.
6. **type/folder 불일치**:
   - `type: meeting`인데 `07-Meetings/`가 아닌 곳에 있음 등.
7. **빈 MOC**: 노트 모음이 비어 있는 MOC.
8. **frontmatter `updated` < `git log` 최근 수정**: 노트를 고치고 `updated` 갱신을 잊은 경우.
9. **중복 후보**: 제목/H1이 너무 유사한 노트 쌍 (편집 거리 기반).
10. **CJK 파일명**: NFD/NFC 이슈 가능성 있는 파일 (ASCII slug 권장).

## 출력 형식

```
## 🔍 Vault Lint Report — 2026-01-01 17:00

총 노트: 142  |  깨진 링크: 3  |  고아: 5  |  Inbox 정체: 2  |  CJK 파일명: 1

### 🔗 깨진 wikilink (3)
- 02-Notes/oauth-flow.md → [[jwt-bestpractice]] (이 노트 없음)
- ...

### 🪂 고아 노트 (5)
- 02-Notes/random-thought.md (아무 노트에서도 링크 안 됨)
- ...

### 📋 frontmatter 누락 (2)
- 00-Inbox/20260101-...md  → title, type 누락
- ...

### 🕒 Inbox 정체 (2, 30일+)
- 00-Inbox/20260101-...md (37일 전)

### 🔁 TODO 7일+ 미진행 (4)
- 03-Projects/<slug>/README.md: "[ ] 로고 변경" (8일)

### ⚠️ CJK 파일명 (1)
- 02-Notes/한글노트.md → ASCII slug 권장 (예: korean-thoughts.md)

### 권장 액션
1. `/wiki-promote 00-Inbox/20260101-...` — 정체 처리
2. 02-Notes/random-thought.md 를 어디에 연결할지 결정
3. CJK 파일명을 ASCII로 rename
```

자동 수정은 사용자가 명시적으로 `--fix <category>`를 줬을 때만 (예: `/wiki-lint-vault --fix frontmatter`). 그것도 한 카테고리씩.

추가 입력: $ARGUMENTS (선택 — `--fix <category>`)
