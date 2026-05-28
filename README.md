# llmwiki-template

당신의 **LLM Wiki**(두 번째 뇌) 시작 템플릿. Obsidian으로 사람이 읽고 쓰고, Claude Code / Codex가 큐레이션합니다. 모든 데이터는 평문 마크다운으로 로컬에 저장되며 git으로 버전 관리됩니다.

> 영감: [Karpathy의 LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). 본 템플릿은 PARA + Zettelkasten + Karpathy 패턴 하이브리드입니다.

## 어떻게 시작하나요?

### Option A — "Use this template" (추천)

GitHub의 이 리포 페이지에서 우상단 **`Use this template`** → **`Create a new repository`** 클릭. 본인 GitHub 계정에 깨끗한 사본을 만들고 clone:

```sh
git clone https://github.com/<your-username>/<your-vault>.git ~/Documents/MyVault
cd ~/Documents/MyVault
```

### Option B — 그냥 clone

```sh
git clone https://github.com/ksw6895/llmwiki-template.git ~/Documents/MyVault
cd ~/Documents/MyVault
rm -rf .git && git init  # 원본 history 끊기
```

### 그 다음: 초기 설정

> **Windows native(cmd/PowerShell) 사용자 주의**: git이 `.claude/commands/wiki-setup.md` 심링크를 평문 텍스트로 풀어 `/wiki-setup` 슬래시 명령이 깨집니다. **Git Bash 또는 WSL2**에서 `bash scripts/setup.sh`(셸 경로)를 사용하세요. macOS / Linux / WSL2 사용자는 아래 두 경로 모두 정상 작동.

**Claude Code 사용자** (macOS / Linux / WSL2 추천):
```sh
claude
> /wiki-setup
```
대화형으로 프로필을 묻고 모든 설정을 자동 처리합니다. 자세히는 [SETUP_WITH_CLAUDE.md](SETUP_WITH_CLAUDE.md).

**Codex 또는 셸 사용자** (Windows native 사용자도 이 경로):
```sh
bash scripts/setup.sh
```
비대화형 셸 스크립트. 자세히는 [SETUP.md](SETUP.md).

설정 후 어디서든 작동:
```sh
claude   # 또는 codex
> /wiki-daily
> /wiki-today-todo
> /wiki-clip https://example.com/article
```

## 이게 뭔가요?

**한 문장**: 일상 정보(웹 클립, 회의록, 학습, 결정, 메모)를 마크다운 vault에 모아 LLM이 능동적으로 분류·연결·요약해주는 자기 위키 시스템.

**핵심 가치**:
- **평문 + 로컬 + git** — 어떤 회사가 망해도 데이터는 살아남음
- **LLM-neutral** — Claude Code와 Codex 양쪽 동일 prefix(`wiki-`)로 작동
- **연결 우선** — 단순 저장이 아니라 wikilink + MOC로 그래프 만들기
- **불변 원본 보존** — Decision/Meeting 원본은 절대 변형 금지

**얻는 것**:
- 정리된 폴더 구조 (PARA + Zettelkasten + ADR)
- 8개 노트 템플릿 (`10-Templates/`)
- 9개 슬래시 명령 (`/wiki-setup`, `/wiki-daily`, `/wiki-clip`, ...)
- LLM 거버넌스 문서 (`AGENTS.md`) — Claude Code와 Codex가 동일하게 따름
- Obsidian 호환 설정

## 자주 쓰는 명령어 (`/wiki-*`)

| 명령 | 효과 |
|---|---|
| `/wiki-setup` | vault 초기 설정 (한 번만) |
| `/wiki-daily` | 오늘 일일 노트 보여주고, 비어 있으면 생성 |
| `/wiki-today-todo` | Daily, Inbox, Projects, Decisions에서 오늘 할 일 합성 |
| `/wiki-clip <URL or text>` | 클립을 적절한 폴더로 분류·요약 |
| `/wiki-ingest-meeting <transcript>` | 회의록을 07-Meetings에 정리 |
| `/wiki-promote <inbox-file>` | Inbox 노트를 Permanent Note로 승격 |
| `/wiki-moc <topic>` | 해당 토픽 MOC 생성/갱신 |
| `/wiki-quiz <topic>` | 기존 노트 기반 퀴즈 출제 |
| `/wiki-lint-vault` | 깨진 링크/고아 노트/누락 frontmatter 점검 |

Claude Code와 Codex가 동일한 `_workflows/` 본문을 공유하므로 한쪽에서 본문을 고치면 양쪽 모두 자동 반영됩니다.

## 폴더 구조

```
.
├── AGENTS.md          # LLM 시스템 프롬프트 (Codex가 자동 로드, Claude는 CLAUDE.md를 통해)
├── CLAUDE.md          # Claude Code가 자동 로드 (AGENTS.md 임포트)
├── README.md          # 이 파일
├── SETUP.md           # 수동 / 셸 설정 가이드
├── SETUP_WITH_CLAUDE.md  # Claude Code 자동 설정
├── index.md           # MOC 진입점 / 사이트맵
├── log.md             # LLM의 모든 쓰기 작업 append-only 로그
├── 00-Inbox/          # 미분류 캡처 큐
├── 01-Daily/          # 일일 노트 (YYYY-MM-DD.md)
├── 02-Notes/          # 영구 원자 노트 (Zettelkasten)
├── 03-Projects/       # 마감 있는 프로젝트 (PARA)
├── 04-Areas/          # 지속적 책임 영역
├── 05-Resources/      # 외부 자료 요약/클립
├── 06-Archive/        # 비활성/완료
├── 07-Meetings/       # 회의록
├── 08-People/         # 인물 CRM
├── 09-Decisions/      # 의사결정 기록 (ADR)
├── 10-Templates/      # Templater용 템플릿
├── 99-MOCs/           # Map of Content
├── _attachments/      # 이미지/PDF
├── _workflows/        # ⭐ LLM-neutral 슬래시 명령 본문 (단일 진실 원천)
├── scripts/           # setup.sh / sync-workflows.sh
└── .claude/commands/  # project-scope 명령 (wiki-setup 부트스트랩)
```

각 폴더의 README.md에 용도가 적혀 있습니다.

## 디자인 원칙

1. **평문 + 로컬 + git**: 어떤 회사도 망해도 데이터는 살아남는다.
2. **AGENTS.md = 거버넌스**: LLM 두 종(Claude Code, Codex) 모두 한 컨트랙트를 따른다.
3. **append-only log**: LLM의 자기 작업 추적. 다음 세션이 컨텍스트 회복 가능.
4. **연결 우선**: 단순 저장이 아니라 wikilink + MOC로 그래프 만들기.
5. **불변 원본**: 결정 기록·회의록 원본·`raw/` 절대 변형 금지.

## 요구사항

- **Claude Code** ([설치](https://docs.claude.com/en/docs/claude-code)) — 또는 **Codex CLI** ([설치](https://github.com/openai/codex))
- **bash** (macOS / Linux / WSL)
- **Obsidian** (선택, 강력 추천) — [obsidian.md](https://obsidian.md)
- **git**, **gh** (선택, GitHub 백업용)

Windows에서는 WSL2 환경 권장 (심링크 호환성).

## 한글 / CJK 파일명 주의

macOS APFS는 한글을 NFD(자모 분리), git/Linux는 NFC(완성형)로 처리합니다. 양쪽 동기화 시 wikilink가 깨질 수 있어, **파일명은 ASCII slug**(`auth-token-refresh.md`)를 쓰고 한글 제목은 frontmatter `title:` 또는 본문 H1에 적습니다.

## 백업 (GitHub)

자기 vault를 GitHub private repo로:
```sh
gh repo create my-llm-wiki --private --source=. --push
```

자동 백업은 [Obsidian-Git](https://github.com/Vinzent03/obsidian-git) 플러그인으로 10분마다 commit & push 설정 가능.

## 라이센스

[MIT](LICENSE). 자유롭게 fork하고 자기 vault로 쓰세요.

## 기여 / 문의

- 이슈/PR 환영: [github.com/ksw6895/llmwiki-template](https://github.com/ksw6895/llmwiki-template)
- 새 워크플로 추가: `_workflows/<new-name>.md` 작성 → `bash scripts/sync-workflows.sh` → PR

## 참고

- Karpathy의 LLM Wiki gist: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- [PARA Method](https://fortelabs.com/blog/para/) — 폴더 분류
- [Zettelkasten](https://zettelkasten.de/) — 원자 노트
- [ADR (Architecture Decision Records)](https://adr.github.io/) — 결정 기록
