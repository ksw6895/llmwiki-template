# SETUP — 수동 / 셸 설정 가이드

Claude Code를 안 쓰거나, 셸에서 모든 걸 통제하고 싶을 때.
Claude 자동 설정은 [SETUP_WITH_CLAUDE.md](SETUP_WITH_CLAUDE.md) 참고.

> **Windows native(cmd / PowerShell) 환경**: git이 `.claude/commands/wiki-setup.md` 심링크를 평문 텍스트로 풀어 `/wiki-setup` 슬래시 명령이 깨집니다. **이 셸 경로가 정답** — Git Bash 또는 WSL2에서 아래 절차를 실행하세요. (Git for Windows를 설치하면 Git Bash가 따라옵니다.)

## TL;DR

```sh
git clone https://github.com/ksw6895/llmwiki-template.git ~/Documents/MyVault
cd ~/Documents/MyVault
rm -rf .git && git init   # 원본 history 끊기 (선택)
bash scripts/setup.sh     # 자동: placeholder 치환 + 글로벌 슬래시 명령 + 첫 daily
```

설정 후 어디서든:
```sh
claude   # 또는 codex
> /wiki-daily
```

## 무엇을 자동으로 처리하나요?

`scripts/setup.sh`는 다음을 순서대로 실행합니다.

### Step 1: `__VAULT_ROOT__` placeholder 치환
`_workflows/*.md`, `AGENTS.md`, `CLAUDE.md`에서 placeholder `__VAULT_ROOT__`를 현재 디렉토리 절대경로로 일괄 치환.

이 작업이 끝나야 LLM이 어느 cwd에서든 vault root를 정확히 찾을 수 있습니다.

### Step 2: 글로벌 슬래시 명령 등록
`bash scripts/sync-workflows.sh`를 호출. 다음이 생성됨:
- `~/.claude/commands/wiki-*.md` — 9개 심링크 (Claude Code, user scope)
- `~/.codex/prompts/wiki-*.md` — 9개 심링크 (Codex, global prompts)

각 심링크는 vault의 `_workflows/<name>.md`로 가는 절대 심링크. 어느 디렉토리에서 호출하든 `/wiki-*` 명령이 작동.

### Step 3: 첫 일일 노트
`10-Templates/tmpl-daily.md`를 기반으로 오늘 날짜의 `01-Daily/YYYY-MM-DD.md` 생성.

### Step 4: log.md 첫 줄
```
## [YYYY-MM-DD HH:MM] init | vault | initialized via scripts/setup.sh
## [YYYY-MM-DD HH:MM] create | 01-Daily/YYYY-MM-DD.md | first daily note
```

## 직접 한 단계씩 (셸 전문가용)

### 1. placeholder 치환 직접
```sh
VAULT_ROOT="$(pwd)"
find _workflows AGENTS.md CLAUDE.md -name "*.md" -type f \
  -exec sed -i.bak "s|__VAULT_ROOT__|$VAULT_ROOT|g" {} \;
find . -name "*.md.bak" -delete
```

### 2. 글로벌 슬래시 명령 등록
```sh
bash scripts/sync-workflows.sh
```

### 3. 사용자 프로필 (선택)
`AGENTS.md`를 열어 §9 `사용자 프로필` 섹션의 `TODO`를 본인 값으로 치환.

### 4. 첫 일일 노트 (선택)
원하면 Claude로 `/wiki-daily` 한 줄. 또는 `10-Templates/tmpl-daily.md`를 손으로 복사.

## Obsidian 설정

### 1. Vault로 열기
Obsidian 첫 실행 → `Open folder as vault` → 이 디렉토리 선택. "Trust author and enable plugins" 클릭 (community plugin용).

### 2. 추천 community plugin

Settings → Community plugins → Browse:

| 플러그인 | 용도 | 필수도 |
|---|---|---|
| **Templater** | `{{date:...}}` 동적 처리 | 강력 추천 |
| **Dataview** | 노트 쿼리 (MOC·Daily 합성에 유용) | 추천 |
| **Periodic Notes** | 일일/주간 노트 자동 생성 | 추천 |
| **Obsidian Git** | 자동 백업 | 추천 |
| **Tag Wrangler** | 태그 관리 | 선택 |
| **Local REST API** | MCP 연결 (Phase 2) | 선택 |

### 3. Templater 폴더 지정
설치 후: Settings → Templater → Template folder location = `10-Templates`

## GitHub 백업

```sh
gh repo create my-llm-wiki --private --source=. --push
```

또는 수동:
```sh
git remote add origin git@github.com:<your-user>/my-llm-wiki.git
git branch -M main
git push -u origin main
```

**자동화**: Obsidian Git plugin을 설치하고 N분 간격 auto-commit & push 설정.

## 첫 한 주 추천 루틴

- **월요일 아침**: `/wiki-daily` → 한 주 계획. `/wiki-today-todo`로 자동 합성.
- **하루 중**: 떠오르는 거 → `00-Inbox/`로 던지기 (수동 또는 `/wiki-clip`).
- **하루 끝**: `01-Daily/<오늘>.md`의 `## 내일로 이월` 채우기.
- **금요일 오후**: `/wiki-lint-vault` → 한 주 정리. `/wiki-moc <topic>`으로 새 MOC 만들기.

## 자주 쓰는 명령어 Cheat Sheet

| 상황 | 명령 (어디서든) |
|---|---|
| 오늘 시작 | `/wiki-daily` 또는 `/wiki-today-todo` |
| 웹 클립 | `/wiki-clip <URL>` |
| 회의 정리 | `/wiki-ingest-meeting <트랜스크립트>` |
| Inbox 정리 | `/wiki-promote 00-Inbox/<file>.md` |
| 토픽 정리 | `/wiki-moc <topic>` |
| 학습 검증 | `/wiki-quiz <topic-or-note>` |
| 무결성 점검 | `/wiki-lint-vault` |

## 정리 / 제거

이 vault를 더 이상 안 쓸 때 글로벌 심링크 제거:
```sh
bash scripts/setup.sh --unlink
```

이후 vault 디렉토리 자체를 지우거나 archive로 옮기면 됨.

## 트러블슈팅

**`__VAULT_ROOT__`가 그대로 보여요**
- Setup이 안 실행됐거나 실패했을 가능성. `bash scripts/setup.sh` 재실행.

**`/wiki-*` 명령이 안 보여요**
- `ls -la ~/.claude/commands/wiki-*.md` 또는 `ls -la ~/.codex/prompts/wiki-*.md`로 심링크 확인.
- 없으면 `bash scripts/sync-workflows.sh` 재실행.

**LLM이 엉뚱한 경로에 파일을 만들어요**
- 워크플로의 placeholder가 안 치환된 경우. `bash scripts/setup.sh` 재실행.
- 또는 워크플로 본문 상단의 vault root 컨텍스트 블록이 손상됐을 수도. 원본은 [github.com/ksw6895/llmwiki-template](https://github.com/ksw6895/llmwiki-template)에서 비교.

**CJK 파일명에서 wikilink가 깨져요**
- macOS APFS(NFD) vs git/Linux(NFC) 정규화 차이. ASCII slug로 rename 권장.

**Obsidian Templater가 작동 안 함**
- Settings → Templater → Template folder location = `10-Templates` 인지 확인.

## 참고

- [AGENTS.md](AGENTS.md) — LLM 거버넌스 컨트랙트
- [README.md](README.md) — 전체 개요
- [SETUP_WITH_CLAUDE.md](SETUP_WITH_CLAUDE.md) — Claude 자동 설정 흐름
