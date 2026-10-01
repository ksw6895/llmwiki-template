# 에이전트용 실행·설정 참고

사용자에게 처음 설명할 때는 [README.md](README.md)를 참고하세요. 아래 명령·도구 설정·폴더 구성은 준비를 담당하는 에이전트나 기술사항을 직접 요청한 사용자를 위한 참고입니다. 초보자에게 이 문서를 따라 실행하는 것을 기본 다음 행동으로 넘기지 않습니다.

이 템플릿은 Markdown 파일을 읽고 쓸 수 있는 에이전트와 함께 사용할 수 있습니다. 명령 설치·이름·이메일·전체 프로필 입력 없이 시작할 수 있습니다.

## 요청과 도구에 맞게 시작하기

“이게 뭐야?”는 설명 요청입니다. 쉬운 효용과 예시를 전달하고 설치·파일 작업을 시작하지 않습니다. 사용을 요청했고 실제 파일 도구가 있다면 에이전트가 준비를 담당하고 저장 위치 등 필요한 선택만 확인합니다. 기존 기록장이 있다면 그 위치와 보존할 내용을 참고하세요. 파일 도구가 없는 채팅에서는 실제 준비가 불가능함과 파일 작업 가능한 코딩 어시스턴트가 필요함을 밝힙니다. Codex나 Claude Code를 이용 중이라면 그쪽 새 대화에 저장소 링크와 “내 위키로 쓸 수 있게 준비해줘”를 전달하도록 안내합니다. 새 유료 가입을 기본 단계로 요구하지 않습니다. 모델 이름만으로 실행 능력을 가정하지 않습니다.

아래는 파일 작업을 맡은 에이전트의 준비 방법 또는 기술 질문에 대한 참고입니다. 개인용 사본은 GitHub의 **Use this template**으로 만들거나 로컬 폴더에 복사할 수 있습니다. 개인 자료를 넣을 원격 저장소는 비공개를 권장합니다. 저장소 URL을 읽는 것만으로 로컬 작업 공간이 준비되지는 않으며, 확인된 도구와 권한의 범위에서 작업합니다.

```sh
git clone https://github.com/<your-username>/<your-vault>.git ~/Documents/MyVault
cd ~/Documents/MyVault
```

메모·회의록·자료 하나를 정리하는 것은 첫 사용의 한 예입니다. 처음부터 루틴 설정을 요청했다면 첫 기록을 요구하지 않고 그 목적을 바로 처리하세요. 이름과 이메일은 필요하지 않습니다. 사용자가 정한 선호만 `preferences.md`에 남기고, 원본·출처·사용자 내용 보호는 [AGENTS.md](AGENTS.md)를 따릅니다. 기존 위키의 `AGENTS.md`에 프로필이 있다면 재입력시키지 말고 그 값을 참고하세요.

예시:

> 사용자: 개발하면서 배운 걸 잊지 않으려고 이 위키를 쓰고 싶어.
>
> 에이전트: 저장 위치를 정해 위키를 준비합니다. “오늘 배운 메모 하나를 알려주시면 첫 기록을 남기겠습니다.”
>
> 사용자: 메모 제공.
>
> 에이전트: 출처와 함께 저장하고 관련 기록이 있으면 연결합니다. “이런 메모가 쌓이면 하루 끝에 배운 점과 남은 일을 모아 정리할 수 있습니다. 원할 때 ‘오늘 위키 정리해줘’라고 하세요.”

## 하루 정리와 자동화

[하루 정리](_workflows/daily-review.md)는 제공되거나 접근이 허용된 자료에서 기억할 내용과 후속 작업을 모읍니다. [일일 노트](_workflows/daily.md)는 하루치 파일의 생성·열람입니다. 빈 노트 생성이 하루 정리를 수행했다는 뜻은 아닙니다.

루틴은 사용 맥락에 도움이 되면 제안할 수 있습니다. “매일 해줘”라는 요청을 받으면 이미 정한 사항은 재사용하고, 아직 필요한 소스 범위·시간대·실행 시간을 확인합니다. 예약할 때는 사용하는 환경의 스케줄러 지원과 **예약 작업이 실행되는 환경**의 vault·소스 접근을 확인합니다. 실제 등록 결과가 확인된 뒤에만 예약 완료라고 보고합니다. 이 저장소는 예약 실행기를 설치하거나 포함하지 않습니다.

스케줄러가 없으면 “오늘 위키 정리해줘”로 수동 실행할 수 있습니다. 소스 연결이 부족하면 접근 가능한 범위로 정리하거나 필요한 연결을 안내합니다. 연결되지 않은 웹 ChatGPT·Claude 대화, 다른 프로젝트·메시지를 자동으로 읽는다고 약속하지 마세요. 결과에는 실제 읽은 소스·기간과 제외/실패를 표시합니다. 자료가 없다는 것과 해당 소스에 접근하지 못했다는 것을 구분하세요.

## 선택 스크립트

기본 `bash scripts/setup.sh`는 구조를 확인하고 안내만 출력합니다. 기존 노트·워크플로·개인 도구 설정을 변경하지 않습니다. 다음 옵션은 사용자가 선택한 경우에만 실행하세요:

| 옵션 | 효과 |
|---|---|
| `--daily` | 오늘 노트가 없으면 생성하고 `log.md`에 생성 이력 추가 |
| `--timezone Asia/Seoul` | 일일 노트에 사용할 IANA 시간대. 미지정이면 시스템 시간대를 밝히고 사용 |
| `--global-commands` | 아래 두 전역 폴더에 명령 진입 파일 생성·갱신 |
| `--install-obsidian` | macOS에서 미설치인 경우 Homebrew 설치 시도. 다른 환경은 수동 설치 안내 |
| `--open-obsidian` | 설치된 Obsidian에서 이 vault 열기 시도 |
| `--dry-run` | 선택한 작업의 예정 효과만 출력. 파일 생성·설치·앱 실행 없음 |
| `--unlink` | 이 vault가 소유한 전역 명령만 제거. 다른 실행 옵션과 함께 사용하지 않음 |

```sh
bash scripts/setup.sh --daily --timezone Asia/Seoul --dry-run
bash scripts/setup.sh --daily --timezone Asia/Seoul
```

`--daily`는 기존 노트를 바꾸지 않습니다. 템플릿의 `{{datetime}}` 등은 스크립트나 에이전트가 실제 값으로 채우는 표기이며 Obsidian 플러그인의 실행 문법을 가정하지 않습니다. 이전 날짜 플레이스홀더도 스크립트에서 지원합니다. 예전처럼 기본 setup 한 번으로 전역 설치·앱 설치·일일 노트 생성을 모두 실행하지 않으며 각 옵션으로 선택할 수 있습니다.

## 도구별 지원과 선택 명령

- **Codex:** `.agents/skills/wiki/SKILL.md`에서 관련 워크플로를 찾을 수 있습니다. CLI/IDE에서는 `$wiki`로 명시하거나 자연어로 요청할 수 있습니다. [공식 skills 문서](https://learn.chatgpt.com/docs/build-skills).
- **Claude Code:** `CLAUDE.md`가 `AGENTS.md`를 import합니다. `.claude/skills/wiki`는 공통 스킬 폴더의 상대 심링크입니다. `/wiki`는 선택 진입점이고 기존 `/wiki-setup`도 유지합니다. [공식 skills 문서](https://code.claude.com/docs/en/skills).
- **다른 에이전트·심링크 미지원 환경:** `AGENTS.md`와 관련 워크플로를 직접 읽으면 됩니다. 스킬이 안 보인다고 기본 사용이 막히지는 않습니다. Windows에서 심링크가 일반 파일로 checkout되면 자연어 경로를 사용하거나 공통 스킬 폴더를 `.claude/skills/wiki` 위치에 복사할 수 있습니다.

기존 전역 명령을 계속 쓰려면:

```sh
bash scripts/setup.sh --global-commands --dry-run
bash scripts/setup.sh --global-commands
```

이 선택은 `~/.claude/commands/wiki-*.md`와 `~/.codex/prompts/wiki-*.md`에 절대 vault 경로와 공통 본문 위치를 담은 작은 진입 파일을 만듭니다. 기존 이 vault의 심링크는 진입 파일로 바꿀 수 있습니다. 다른 vault·사용자의 파일과 충돌하면 등록을 중단합니다. 여러 vault에는 자연어로 대상 경로를 지정하거나 repo 범위 스킬을 사용하세요.

| 작업 | Claude Code 전역 명령 | Codex 기존 custom prompt |
|---|---|---|
| 하루 파일 생성·열람 | `/wiki-daily` | `/prompts:wiki-daily` |
| 하루 자료 정리 | `/wiki-daily-review` | `/prompts:wiki-daily-review` |
| 할 일 찾기 | `/wiki-today-todo` | `/prompts:wiki-today-todo` |
| 자료 저장 | `/wiki-clip` | `/prompts:wiki-clip` |

다른 `_workflows/<name>.md`도 같은 이름 규칙을 사용합니다. **Codex custom prompts는 deprecated**이며 명시 호출이 필요합니다. 신규 사용에는 자연어·repo 스킬을 권장합니다. 명령이 안 보이면 클라이언트 새 세션/재시작과 공식 문서를 확인하세요. [공식 custom prompts 문서](https://learn.chatgpt.com/docs/custom-prompts). 제품별 발견 위치와 호출 방식은 바뀔 수 있으므로 버전별 동작이 다르면 자연어 경로를 사용하세요.

```sh
bash scripts/setup.sh --unlink --dry-run
bash scripts/setup.sh --unlink
```

vault를 옮겼다면 옛 경로가 적힌 전역 파일을 확인하세요. 가능하면 이전 위치에서 `--unlink`한 뒤 새 위치에서 등록합니다. 경로가 다른 파일을 자동으로 덮어쓰거나 제거하지 않습니다. `WIKI_COMMAND_HOME`으로 전역 파일의 기준 디렉토리를 별도로 지정할 수 있어 격리 시험에도 사용할 수 있습니다. 기본은 사용자 홈입니다.

## Obsidian과 백업은 선택

[Obsidian](https://obsidian.md/download)에서 이 폴더를 vault로 열 수 있습니다. 기본 Markdown 사용에는 community plugin이 필요하지 않습니다. 노트 쿼리·편집기 내 템플릿·백업 등 원하는 기능이 생겼을 때 해당 플러그인 설정과 문법을 따로 확인하세요.

```sh
bash scripts/setup.sh --install-obsidian --open-obsidian --dry-run
# 설치와 실행을 원할 때만 --dry-run을 빼고 실행
```

git은 로컬 이력 관리에 사용할 수 있습니다. 원격 백업을 원한다면 개인용 비공개 저장소와 업로드할 자료 범위를 선택한 뒤 연결하세요. 이 템플릿이나 setup은 자동 commit·push를 수행하지 않습니다. 자동 백업 플러그인 설정도 사용자의 별도 선택입니다.

## 구성과 기여 참고

자료는 로컬 Markdown 파일이며, 이 저장소는 이를 관리할 틀과 작업별 참고 문서를 제공합니다. 별도의 벡터 검색·임베딩 기반 RAG 서버를 포함하지 않습니다. 폴더나 도구 구성이 궁금하다는 요청을 받은 경우 실제 자료에 맞춰 설명하세요.

| 위치 | 용도 |
|---|---|
| `00-Inbox/`, `01-Daily/` | 임시 메모, 하루 기록 |
| `02-Notes/`, `03-Projects/`, `04-Areas/` | 재사용할 지식, 프로젝트, 지속 관심 영역 |
| `05-Resources/`, `07-Meetings/`, `08-People/`, `09-Decisions/` | 자료, 회의, 인물, 결정 |
| `06-Archive/`, `99-MOCs/` | 보관, 주제별 진입점 |
| `10-Templates/`, `_attachments/`, 필요 시 `raw/` | 선택 템플릿, 첨부, 원본 |
| `index.md`, `log.md`, `preferences.md` | 사이트맵, 쓰기 이력, 정한 선호·범위 |
| `_workflows/` | 클립·회의 정리·승격·MOC·할 일·퀴즈·점검·하루 정리의 공통 예제 |

`_workflows/daily.md`는 하루치 파일의 생성·열람이고 `daily-review.md`는 실제 자료의 정리입니다. 워크플로는 작업에 필요한 것만 참고하며 고정 검색 순서나 출력 형식이 아닙니다. 노트 템플릿도 필요에 맞게 사용합니다.

이 저장소의 공통 본문과 도구별 진입점의 일관성을 확인해 기여할 수 있습니다. 첫 설명을 바꿀 때는 [회귀 사례](docs/first-response-checks.md)를 참고하세요. [Karpathy의 LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)에서 영감을 받았으며 [MIT](LICENSE) 라이선스입니다.
