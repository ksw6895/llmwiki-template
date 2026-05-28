---
description: 오늘 일일 노트를 열거나, 없으면 템플릿으로 생성한다
---

## 컨텍스트 (먼저 읽기)

- **Vault root**: `__VAULT_ROOT__/`
- 이 워크플로의 모든 vault-relative 경로(`01-Daily/`, `10-Templates/` 등)는 vault root 기준입니다. 호출 시 cwd가 vault가 아니어도 vault root에 절대경로로 풀어 쓰세요.
- 작업 전에 `__VAULT_ROOT__/AGENTS.md`를 읽어 컨트랙트(폴더 규칙, frontmatter, log 기록 의무)를 적용하세요.

오늘 날짜의 일일 노트(`01-Daily/YYYY-MM-DD.md`)를 처리합니다.

1. **현재 사용자 시간대 날짜를 계산**: `AGENTS.md` §9의 사용자 시간대를 따라 `YYYY-MM-DD` 슬러그 만들기.
2. **파일 존재 확인**: `01-Daily/<date>.md`.
3. **있으면**: 내용을 그대로 보여주고, 새로 추가할 섹션이 있는지 사용자에게 물어볼 필요 없음 — 그냥 표시만.
4. **없으면**: `10-Templates/tmpl-daily.md`를 복사하되 `{{date:...}}`, `{{time:...}}` 플레이스홀더를 실제 값으로 치환해서 `01-Daily/<date>.md`로 저장. `{{date-1d:...}}`는 어제 날짜로.
5. **log.md에 한 줄 append**: `## [<date> <time>] create | 01-Daily/<date>.md | new daily note`
6. **마지막**: 어제 일일 노트의 `## 내일로 이월` 섹션이 비어있지 않으면 그 내용을 오늘 일일 노트 상단에 인용으로 옮길지 사용자에게 제안.

추가 입력: $ARGUMENTS (선택 — 일일 노트에 즉시 추가할 메모)
