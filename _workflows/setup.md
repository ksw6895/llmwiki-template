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

### Step 2: 셸 부트스트랩 실행 (placeholder 치환 + 글로벌 sync + 첫 daily + log)

Bash 도구로 다음 명령을 실행하세요:

```bash
bash "$VAULT_ROOT/scripts/setup.sh"
```

이 스크립트가 다음을 idempotent하게 처리합니다 (재실행 안전):
- `__VAULT_ROOT__` placeholder를 `_workflows/*.md`에서 절대경로로 치환 (setup.md는 자동 제외)
- vault 이동 감지 시 `.setup-vault-root` 마커로 옛 절대경로 → 새 경로 마이그레이션
- 글로벌 슬래시 명령 등록 — `~/.claude/commands/wiki-*.md`와 `~/.codex/prompts/wiki-*.md`에 9개씩 절대 심링크
- 오늘 일일 노트 생성 (없으면)
- `log.md`에 init/create/refactor 라인 append

스크립트 출력에서 다음이 보이면 성공:
- `[2/5] 글로벌 슬래시 명령 등록...` 뒤에 `(9 links, prefix=wiki-)`
- `[3/5] 오늘 일일 노트 ...` (생성 또는 이미 존재)
- `[4/5] log.md 갱신 완료`
- `[5/5] Obsidian 감지 / 자동 설치 / vault 열기...` — OS별로 Obsidian 자동 설치(macOS+brew) 및 vault 자동 열기 시도. 마지막에 community plugin 추천 카드 출력.

> **왜 LLM이 Edit으로 직접 안 하고 셸 스크립트로 위임?**
> placeholder 치환은 8개 파일에서 일어나며, Edit 도구는 매 파일마다 사용자 승인을 요청합니다. setup.sh는 단일 Bash 호출로 처리해 친구의 마찰을 줄입니다. 스크립트 자체는 vault root 안에서만 동작하며 외부 경로를 건드리지 않습니다.

### Step 3: AGENTS.md 사용자 프로필 갱신 (Step 1에 응답이 있을 때만)

Step 1에서 사용자가 응답한 항목이 **한 개라도** 있으면 `VAULT_ROOT/AGENTS.md`의 `## 9. 사용자 프로필` 섹션을 Edit 도구로 갱신합니다. 전부 "건너뛰기"였다면 이 단계 완전 생략.

각 항목은 `- **<필드명>**: TODO` 또는 `- **<필드명>**: TODO (예: ...)` 형태입니다. 치환 규칙:

- **매칭 패턴**: `: TODO` 이후 줄 끝까지 (가이드 텍스트 `(예: ...)` 포함) 전체를 새 값으로 교체.
  - 예: `- **이름**: TODO` → `- **이름**: 홍길동`
  - 예: `- **시간대**: TODO (예: "Asia/Seoul (KST, UTC+9). 모든 타임스탬프는 KST로.")` → `- **시간대**: Asia/Seoul (KST, UTC+9)`
- **응답 없는 항목**: `TODO` 라인 그대로 유지.
- **이미 채워진 항목** (TODO가 아닌 값): **절대 덮어쓰지 마세요** — 사용자가 손으로 채웠을 수 있음.

### Step 4: 요약 출력

```
✅ vault 초기화 완료

VAULT_ROOT: <VAULT_ROOT>
사용자 프로필: <응답 있으면 갱신된 항목 요약, 없으면 "건너뜀 — AGENTS.md §9를 직접 편집해도 됩니다">
글로벌 슬래시 명령: 9개 심링크 (Claude Code + Codex)
오늘 일일 노트: 01-Daily/<YYYY-MM-DD>.md (생성 또는 이미 존재)
Obsidian: setup.sh가 OS별로 자동 처리 시도 — 결과는 스크립트의 [5/5] 출력 줄 확인.
  · macOS + Homebrew: brew로 자동 설치 + vault 자동 열기
  · Linux: 깔려있으면 자동 열기, 아니면 설치 명령 안내
  · WSL/Windows: winget 명령 안내만 (Windows host 자동 설치는 안 함)

다음 시도:
  /wiki-daily              # 오늘 일일 노트
  /wiki-today-todo         # 오늘 할 일 합성
  /wiki-clip <URL>         # 웹 클립 정리
  /wiki-moc <topic>        # 토픽 MOC 만들기

Obsidian이 열렸으면 setup.sh가 출력한 plugin 추천 카드의 항목들을
Settings → Community plugins → Browse 에서 검색·설치하세요 (Templater 필수).
```

> **재실행 안전**: `/wiki-setup`을 다시 호출해도 placeholder 재치환, 글로벌 심링크 갱신, 누락된 로그 추가만 일어납니다. 이미 채워진 프로필이나 기존 daily는 보존됩니다. vault 폴더를 옮긴 직후에 재실행하면 옛 절대경로가 자동으로 새 경로로 마이그레이션됩니다.

## 추가 입력

`$ARGUMENTS`: 무시. setup은 대화형으로 진행.
