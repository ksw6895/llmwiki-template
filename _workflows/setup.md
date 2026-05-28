---
description: vault 초기 설정 — placeholders 치환, 글로벌 슬래시 명령 등록, 첫 daily 생성
---

## 컨텍스트 (먼저 읽기)

- **이 워크플로는 vault 초기화용 부트스트랩**입니다. 이미 setup이 끝난 vault에서 재실행해도 안전합니다(idempotent — 이미 채워진 항목은 덮어쓰지 않음).
- 호출 시 cwd가 vault 루트(이 리포를 clone한 위치)여야 합니다. 다른 cwd면 사용자에게 안내하고 종료.
- 이 워크플로는 vault root에 `__VAULT_ROOT__` placeholder가 있다고 가정하고 그것을 실제 경로로 치환하는 것이 주된 일입니다. 그러므로 다른 워크플로와 달리 자기 자신은 placeholder를 가지지 않습니다.

## 절차

### Step 0: vault root 확인

1. `pwd`로 현재 디렉토리 절대경로 확보 → `VAULT_ROOT` 변수.
2. `VAULT_ROOT`에 `AGENTS.md`와 `_workflows/` 디렉토리가 모두 존재하는지 확인.
3. 없으면 사용자에게 "vault 루트(이 리포를 clone한 위치)에서 실행해주세요. 현재: `<cwd>`" 안내하고 종료.

### Step 1: 사용자 프로필 수집 (선택)

사용자에게 다음을 묻습니다. **각 항목은 비워두면 placeholder(`TODO`)가 유지**됩니다. 강요하지 마세요 — 한 번에 모두 묻고, "건너뛰기"라고 답하면 그대로 진행.

- 이름 (예: `홍길동`)
- 이메일 (예: `you@example.com`)
- 언어 선호 (기본 제안: `한국어 기본, 코드/명령어는 영어. 답변은 간결하게.`)
- 시간대 (기본 제안: `Asia/Seoul (KST, UTC+9). 모든 타임스탬프는 KST로.`)
- 활동 영역 한 줄 (예: `소프트웨어 개발, 학습/리서치`)

### Step 2: placeholder 치환

다음 파일에서 placeholder 문자열을 Step 0에서 얻은 절대경로(trailing slash 없음)로 일괄 치환:

- `VAULT_ROOT/_workflows/<other>.md` — 본인 자신(`setup.md`)은 **제외** (이 문서가 placeholder 자체를 설명용으로 포함하므로)
- `VAULT_ROOT/AGENTS.md` (placeholder 없으면 변화 없음)
- `VAULT_ROOT/CLAUDE.md` (placeholder 없으면 변화 없음)

LLM이 직접 Edit 도구로 파일별로 치환하세요 (각 워크플로 파일에서 placeholder 두 군데를 절대경로로 변경). 또는 비대화형이면 `bash scripts/setup.sh`가 같은 일을 처리합니다.

### Step 3: AGENTS.md 사용자 프로필 갱신

`VAULT_ROOT/AGENTS.md`의 `## 9. 사용자 프로필` 섹션을 찾아 Step 1에서 받은 값으로 TODO를 치환합니다.

- 사용자가 응답하지 않은 항목은 `TODO` 유지.
- 이 섹션은 사용자가 직접 수정하기도 하므로, 이미 TODO가 아닌 값으로 채워진 항목은 **덮어쓰지 말고** 그대로 둠.

### Step 4: 글로벌 슬래시 명령 등록

```bash
bash "$VAULT_ROOT/scripts/sync-workflows.sh"
```

출력에서 다음을 확인:
- `~/.claude/commands/wiki-*.md` — 9개 심링크 생성 (8개 기존 + setup)
- `~/.codex/prompts/wiki-*.md` — 9개 심링크 생성

### Step 5: 첫 일일 노트 생성

오늘 날짜로 `01-Daily/<YYYY-MM-DD>.md` 파일이 없으면 `10-Templates/tmpl-daily.md`를 복사해서 생성. `{{date:...}}`, `{{time:...}}`, `{{date-1d:...}}` placeholder를 실제 값으로 치환.

이미 존재하면 건너뜀.

### Step 6: log.md 첫 줄 append

```
## [<YYYY-MM-DD HH:MM>] init | vault | initialized via /wiki-setup
## [<YYYY-MM-DD HH:MM>] create | 01-Daily/<YYYY-MM-DD>.md | first daily note
```

이미 init 라인이 있으면 두 번째 줄(daily 생성)만 append.

### Step 7: 요약 출력

```
✅ vault 초기화 완료

VAULT_ROOT: <VAULT_ROOT>
사용자: <이름 or "프로필 미입력 — AGENTS.md §9를 직접 편집해도 됩니다">
글로벌 슬래시 명령: 9개 심링크 (Claude Code + Codex)
오늘 일일 노트: 01-Daily/<YYYY-MM-DD>.md

다음 시도:
  /wiki-daily              # 오늘 일일 노트
  /wiki-today-todo         # 오늘 할 일 합성
  /wiki-clip <URL>         # 웹 클립 정리
  /wiki-moc <topic>        # 토픽 MOC 만들기

Obsidian에서 이 폴더(<VAULT_ROOT>)를 vault로 열어두면 노트 그래프·백링크가 시각화됩니다.
```

## 추가 입력

`$ARGUMENTS`: 무시. setup은 대화형으로 진행.
