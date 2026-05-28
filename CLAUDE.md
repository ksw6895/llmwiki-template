# CLAUDE.md

이 파일은 Claude Code가 cwd=vault일 때 자동 로드됩니다. 모든 vault 규칙은 `AGENTS.md`에 있고, 이 파일은 그것을 import 합니다.

@AGENTS.md

## Claude Code 전용 추가 사항

- 이 vault에서 작업할 때는 항상 **세션 시작 시 다음을 먼저 읽으세요**:
  1. `index.md` — 진입점 / 사이트맵
  2. `log.md`의 마지막 30줄 — 직전 세션 컨텍스트
  3. 오늘 날짜의 `01-Daily/YYYY-MM-DD.md` (없으면 어제)

- **첫 설정(처음 clone한 직후)**: `/wiki-setup`을 실행하세요. `.claude/commands/wiki-setup.md`에 project-scope 명령이 등록되어 있어, 이 디렉토리에서 Claude Code를 열면 바로 사용할 수 있습니다.

- Slash command는 setup 이후 **글로벌** `~/.claude/commands/wiki-*.md` 에 정의됩니다 (Codex와 동일한 prefix·동일한 `_workflows/` 본문). 어디서 호출하든 작동합니다. 사용 가능한 명령:
  - `/wiki-setup` — vault 초기 설정 (한 번만)
  - `/wiki-daily` — 오늘 일일 노트 생성 또는 열람
  - `/wiki-clip` — 웹 클립/텍스트를 적절한 폴더로 정리
  - `/wiki-ingest-meeting` — 회의록 정리
  - `/wiki-promote` — Inbox 노트를 Permanent로 승격
  - `/wiki-today-todo` — 오늘 할 일 합성
  - `/wiki-lint-vault` — vault 무결성 점검
  - `/wiki-moc` — 토픽 MOC 생성/갱신
  - `/wiki-quiz` — 기존 노트 기반 학습 퀴즈

- cwd가 vault가 아닌 곳에서 `/wiki-*`를 호출했을 때 이 CLAUDE.md는 자동 로드되지 않습니다. 워크플로 본문 상단의 vault root 컨텍스트 블록이 그 역할을 대신해 LLM이 `<vault>/AGENTS.md`를 명시적으로 읽도록 합니다.
- 큰 수정 후에는 `log.md`에 한 줄 append 잊지 마세요.
- 한국어/CJK 파일명은 NFD/NFC 이슈로 피하고, ASCII slug + frontmatter title 사용.
