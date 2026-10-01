# llmwiki-template

메모, 자료, 결정과 배운 내용을 로컬 Markdown 위키에 남기는 시작 템플릿입니다. Claude Code나 Codex 등 파일을 다룰 수 있는 에이전트에게 자연어로 부탁하세요. Obsidian은 선택적인 읽기·쓰기 도구입니다.

## 링크 하나로 시작하기

이 저장소 링크를 에이전트에게 붙여 넣고 이렇게 말해도 됩니다:

> https://github.com/ksw6895/llmwiki-template
> 이걸 써보고 싶어. 내가 어떤 식으로 활용하면 좋을지 제안하고 시작을 도와줘.

에이전트는 이 README와 [SETUP.md](SETUP.md)를 읽고 사용자에게 맞는 첫 작업을 제안할 수 있습니다. 예를 들어 개발 중 배운 점을 남기거나, 회의에서 정한 일을 다시 찾거나, 하루 끝에 자료를 모아 정리할 수 있습니다. 링크만 받은 경우에는 용도를 소개하고 시작 의사를 확인합니다. 이미 시작을 요청했다면 그 요청에 맞게 진행합니다.

**에이전트를 위한 시작점:** 설정·첫 사용은 [SETUP.md](SETUP.md), 위키 안의 작업은 [AGENTS.md](AGENTS.md)를 참고하세요. 실제 자료 하나를 정리하는 것은 첫 사용의 한 예입니다. 처음부터 루틴 설정을 요청했다면 그 목적을 바로 처리하세요. 명령어 설치나 프로필 완성을 시작 조건으로 삼을 필요는 없습니다. 링크를 읽는 것만으로 로컬 파일 접근·설치·예약 권한이 생기지는 않습니다. 이 저장소는 위키의 틀과 참고 지침을 제공합니다. 연결과 예약 실행은 사용하는 환경에 따라 다릅니다.

## 평소에는 이렇게 말하세요

- “이 메모를 저장하고, 관련 있는 기존 내용이 있으면 연결해줘.”
- “이 회의에서 정한 일과 아직 안 정한 것을 남겨줘.”
- “내 위키에서 오늘 할 일을 찾아줘.”
- “오늘 자료에서 배운 점, 결정, 남은 일을 위키에 정리해줘.”

[일일 노트](_workflows/daily.md)는 하루치 파일을 만들거나 보여줍니다. [하루 정리](_workflows/daily-review.md)는 실제 읽은 자료에서 기억할 내용을 모아 저장합니다. 사용 맥락에 맞춰 하루 정리를 제안할 수 있습니다. 자료가 없는 날에는 내용을 만들어 채우지 않습니다.

매일 자동으로 하고 싶다면 “매일 저녁 9시에 이 위키를 정리해줘”라고 요청하세요. 에이전트가 소스 범위·시간대·실행 환경의 접근 가능 여부와 스케줄러 지원을 확인한 뒤 설정합니다. 예약 기능이 없으면 같은 요청으로 수동 실행할 수 있습니다. **웹 ChatGPT·Claude 대화 등은 실제로 연결하거나 제공한 범위만 포함됩니다.** 결과에는 읽은 소스와 기간, 제외되거나 읽지 못한 소스를 표시합니다.

## 직접 준비하려면

GitHub의 **Use this template → Create a new repository**로 개인용 사본을 만든 뒤 clone하거나, 이 템플릿을 로컬 폴더에 복사하세요. 개인 자료를 넣을 저장소는 비공개로 두는 것을 권장합니다.

```sh
git clone https://github.com/<your-username>/<your-vault>.git ~/Documents/MyVault
cd ~/Documents/MyVault
# 이 폴더를 에이전트에게 열어 주고 “이 위키 사용을 도와줘”라고 요청
```

Markdown 파일을 읽고 쓸 수 있으면 기본 사용이 가능합니다. bash는 아래 선택 스크립트에만 필요합니다. 자세한 준비·도구별 지원은 [SETUP.md](SETUP.md)에 있습니다.

## 선택 도구와 기존 명령어

공통 작업 예제는 [_workflows/](_workflows/)에 있습니다. 고정 순서나 필수 출력 형식이 아니라 필요한 작업에 참고하는 문서입니다. 저장소에는 이를 찾아주는 짧은 `wiki` 스킬도 제공합니다.

| 환경 | 선택 진입점 |
|---|---|
| Codex | repo의 `.agents/skills/wiki/SKILL.md`. 자연어로 요청하거나 CLI/IDE에서 `$wiki`로 명시 |
| Claude Code | `CLAUDE.md`에서 공통 지침 import. `.claude/skills/wiki`는 공통 스킬 폴더의 심링크이며 `/wiki`로 명시 가능 |
| 다른 파일 접근 에이전트 | README·AGENTS·관련 워크플로를 직접 참고 |

스킬 사용은 기본 작업의 조건이 아닙니다. 심링크를 지원하지 않는 환경에서도 자연어와 문서로 시작할 수 있습니다. URL만 읽은 환경에 repo 스킬이 자동 설치되는 것은 아닙니다.

기존 `/wiki-*` 사용자를 위한 **전역 명령 등록은 선택**입니다:

```sh
bash scripts/setup.sh --global-commands --dry-run
bash scripts/setup.sh --global-commands
```

Claude Code는 `/wiki-daily`, Codex의 기존 custom prompts 경로는 `/prompts:wiki-daily`입니다. Codex custom prompts는 deprecated이므로 새 사용자는 자연어 또는 스킬을 권장합니다. 전역 등록은 `~/.claude/commands`와 `~/.codex/prompts`에 이 vault를 가리키는 진입 파일을 만듭니다. 다른 vault나 사용자의 같은 이름 파일은 덮어쓰지 않습니다. [지원 근거와 제거 방법](SETUP.md#도구별-지원과-선택-명령).

## 들어 있는 것

- 로컬 평문 노트, 원본과 출처를 보존하는 공통 지침
- PARA·Zettelkasten·ADR을 참고한 폴더와 선택 노트 템플릿
- 클립, 회의 정리, Inbox 정리, MOC, 할 일, 퀴즈, 점검, 하루 정리의 참고 워크플로
- 선택적인 스킬·전역 명령·일일 노트 생성 스크립트

| 위치 | 용도 |
|---|---|
| `00-Inbox/`, `01-Daily/` | 임시 메모, 하루 기록 |
| `02-Notes/`, `03-Projects/`, `04-Areas/` | 배운 내용, 프로젝트, 지속 관심 영역 |
| `05-Resources/`, `07-Meetings/`, `08-People/`, `09-Decisions/` | 자료, 회의, 인물, 결정 |
| `06-Archive/`, `99-MOCs/` | 보관, 주제별 진입점 |
| `10-Templates/`, `_attachments/`, 필요 시 `raw/` | 선택 템플릿, 첨부, 원본 |
| `index.md`, `log.md`, `preferences.md` | 사이트맵, 쓰기 이력, 사용자가 정한 선호·범위 |

## Obsidian과 백업

Obsidian·community plugin·GitHub 백업은 선택입니다. [SETUP.md](SETUP.md)에 설치 효과와 방법을 구분해 두었습니다. 템플릿의 날짜 표시는 에이전트가 실제 값으로 채울 수 있으므로 플러그인을 설치할 필요는 없습니다. 어떤 원격에도 기본으로 개인 자료를 push하지 않습니다.

[Karpathy의 LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)에서 영감을 받았습니다. [MIT](LICENSE). 기여는 공통 본문과 도구별 진입점의 일관성을 확인한 뒤 이 저장소에 PR로 제안할 수 있습니다.
