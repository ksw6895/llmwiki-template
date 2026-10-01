# 에이전트용 실행·설정 참고

사용자에게 처음 설명할 때는 [README.md](README.md)를 참고하세요. 아래 명령·도구 설정·폴더 구성은 준비를 담당하는 에이전트나 기술사항을 직접 요청한 사용자를 위한 참고입니다. 초보자에게 이 문서를 따라 실행하는 것을 기본 다음 행동으로 넘기지 않습니다.

이 템플릿은 Markdown 파일을 읽고 쓸 수 있는 에이전트와 함께 사용할 수 있습니다. 명령 설치·이름·이메일·전체 프로필 입력 없이 시작할 수 있습니다.

## 요청과 도구에 맞게 시작하기

“이게 뭐야?”는 설명 요청입니다. 쉬운 효용과 예시를 전달하고 설치·파일 작업을 시작하지 않습니다. 사용을 요청했고 실제 파일 도구가 있다면 에이전트가 준비를 담당하고 저장 위치 등 필요한 선택만 확인합니다. 기존 기록장이 있다면 그 위치와 보존할 내용을 참고하세요. 파일 도구가 없는 채팅에서는 실제 준비가 불가능함과 파일 작업 가능한 코딩 어시스턴트가 필요함을 밝힙니다. Codex나 Claude Code를 이용 중이라면 그쪽 새 대화에 저장소 링크와 “내 위키로 쓸 수 있게 준비해줘”를 전달하도록 안내합니다. 새 유료 가입을 기본 단계로 요구하지 않습니다. 모델 이름만으로 실행 능력을 가정하지 않습니다.

아래는 파일 작업을 맡은 에이전트의 준비 방법 또는 기술 질문에 대한 참고입니다. 개인용 사본은 GitHub의 **Use this template**으로 만들거나 로컬 폴더에 복사할 수 있습니다. GitHub 백업을 선택하면 사용자 본인 계정의 개인 비공개 저장소를 기본으로 안내합니다. 저장소 URL을 읽는 것만으로 로컬 작업 공간이 준비되지는 않으며, 확인된 도구와 권한의 범위에서 작업합니다.

## Windows와 macOS에서 에이전트가 준비하기

Windows 기본 경로는 **native Windows**입니다. 이 위키 때문에 WSL, Git Bash, 개발자 모드, 심링크 권한을 준비시킬 필요는 없습니다. Codex Windows 앱은 기본적으로 PowerShell을 사용하며 WSL은 선택 설정입니다. Claude Code도 native Windows에서 PowerShell을 사용할 수 있습니다. [Codex Windows 문서](https://learn.chatgpt.com/docs/windows/windows-app), [Claude Code 설치 문서](https://code.claude.com/docs/en/setup).

| 실행 환경 | 에이전트의 준비 방법 |
|---|---|
| Windows 기본 환경 | 기존 파일 도구나 PowerShell로 폴더·파일을 준비. 설치된 Git이 있으면 사용할 수 있지만 bash 스크립트 실행은 시작 조건이 아님 |
| macOS | 기존 파일 도구로 준비. 필요하면 아래 bash 도우미를 선택해서 사용 |
| 이미 Git Bash를 쓰는 환경 | 자연어·파일 도구 경로는 동일. 아래 도우미의 Unix 시간대 파일·유틸리티가 실제 존재하는지 확인 |
| 이미 WSL을 쓰는 환경 | 선택 경로. Windows Obsidian과 함께 쓰려면 Windows 파일시스템의 vault를 함께 접근하는 방식을 우선 검토 |

에이전트는 정한 위치에 새 사본을 준비합니다. Git이 없다면 지원되는 다운로드·압축 해제 또는 파일 복사 도구를 써도 됩니다. 기존 위키에 적용할 때는 필요한 안내 파일만 비교해 추가하고, 노트·`preferences.md`·사용자 지침·`.obsidian` 설정 전체를 덮어쓰지 않습니다. 새 사본에 포함된 `.obsidian`은 초기 예시 설정입니다.

공백·한글이 있는 절대 경로도 그대로 사용하세요. PowerShell에서는 `Join-Path`, `-LiteralPath`를 쓰고 실행 인수는 따로 전달합니다. 새 Markdown은 UTF-8로 저장하되 기존 파일의 인코딩·줄바꿈은 보존합니다. Windows PowerShell 5.1과 PowerShell 7은 기본 인코딩이 다르므로 기본값에 기대지 마세요. 심링크 대신 아래 실제 파일 진입점을 사용할 수 있습니다. [PowerShell 인코딩 문서](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_character_encoding).

일일 노트를 직접 만들 때는 이미 정한 시간대를 쓰고, 미정이면 시스템 시간대를 밝혀 사용합니다. Windows에서는 `Get-TimeZone`과 `Get-Date` 등 현재 환경의 날짜 도구를 확인하세요. Windows 시간대 ID와 IANA 이름은 같은 문자열이 아니므로 요청한 시간대의 지원 여부와 UTC offset을 확인한 뒤 하나의 기준 시각으로 날짜·생성 시각을 채웁니다. 시스템 시간대를 바꾸거나 `/usr/share/zoneinfo` 존재를 native Windows의 조건으로 삼지 않습니다. 기존 일일 노트는 보존하고 공통 기록 관례를 따릅니다.

WSL 경로 `/mnt/c/...`를 Windows 앱에 그대로 전달하지 않습니다. WSL을 이미 쓰는 경우 `wslpath -w`로 host 경로를 확인하고 Windows 측 도구로 엽니다. Linux 홈의 `\\wsl$` 경로는 앱·도구별 접근이 다를 수 있어 실제 읽기·쓰기를 확인해야 합니다. WSL과 Windows의 에이전트 설정·예약 실행 환경도 따로 확인하세요. native Windows 사용자를 WSL로 전환시킬 필요는 없습니다.

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

이 도우미는 macOS/Linux의 bash 환경용이며 기본 사용에는 필요하지 않습니다. `--timezone`은 `/usr/share/zoneinfo`가 있는 환경을 전제로 합니다. native Windows에서는 위의 파일 도구/PowerShell 경로로 준비하고, 전역 명령 등록도 기본 단계로 요구하지 않습니다.

기본 `bash scripts/setup.sh`는 구조를 확인하고 안내만 출력합니다. 기존 노트·워크플로·개인 도구 설정을 변경하지 않습니다. 다음 옵션은 사용자가 선택한 경우에만 실행하세요:

| 옵션 | 효과 |
|---|---|
| `--daily` | 오늘 노트가 없으면 생성하고 `log.md`에 생성 이력 추가 |
| `--timezone Asia/Seoul` | 일일 노트에 사용할 IANA 시간대. 미지정이면 시스템 시간대를 밝히고 사용 |
| `--global-commands` | 아래 두 전역 폴더에 명령 진입 파일 생성·갱신 |
| `--install-obsidian` | macOS에서 미설치인 경우 Homebrew 설치 시도. 다른 환경은 수동 설치 안내 |
| `--open-obsidian` | 설치된 Obsidian의 vault manager 열기. 새 폴더 등록 완료를 의미하지 않음 |
| `--dry-run` | 선택한 작업의 예정 효과만 출력. 파일 생성·설치·앱 실행 없음 |
| `--unlink` | 이 vault가 소유한 전역 명령만 제거. 다른 실행 옵션과 함께 사용하지 않음 |

```sh
bash scripts/setup.sh --daily --timezone Asia/Seoul --dry-run
bash scripts/setup.sh --daily --timezone Asia/Seoul
```

`--daily`는 기존 노트를 바꾸지 않습니다. 템플릿의 `{{datetime}}` 등은 스크립트나 에이전트가 실제 값으로 채우는 표기이며 Obsidian 플러그인의 실행 문법을 가정하지 않습니다. 이전 날짜 플레이스홀더도 스크립트에서 지원합니다. 예전처럼 기본 setup 한 번으로 전역 설치·앱 설치·일일 노트 생성을 모두 실행하지 않으며 각 옵션으로 선택할 수 있습니다.

## 도구별 지원과 선택 명령

- **Codex:** `.agents/skills/wiki/SKILL.md`에서 관련 워크플로를 찾을 수 있습니다. CLI/IDE에서는 `$wiki`로 명시하거나 자연어로 요청할 수 있습니다. [공식 skills 문서](https://learn.chatgpt.com/docs/build-skills).
- **Claude Code:** `CLAUDE.md`가 `AGENTS.md`를 import합니다. `.claude/skills/wiki/SKILL.md`는 공통 스킬을 참조하는 작은 실제 파일입니다. `/wiki`는 선택 진입점이고 기존 `/wiki-setup`도 유지합니다. [공식 skills 문서](https://code.claude.com/docs/en/skills).
- **다른 에이전트:** `AGENTS.md`와 관련 워크플로를 직접 읽으면 됩니다. 스킬이 안 보인다고 기본 사용이 막히지는 않습니다. repo 범위 Claude 스킬과 `/wiki-setup`은 심링크 없이 checkout됩니다.

macOS/Linux bash 환경에서 기존 전역 명령을 계속 쓰려면:

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

## Obsidian을 기본 뷰어·편집기로 권장

사람이 위키 문서를 읽고 편집할 때는 Obsidian을 기본으로 권하세요. 문서를 읽고 내부 링크를 따라 탐색하기 편하며, [그래프](https://help.obsidian.md/plugins/graph)로 문서 사이의 연결을 볼 수 있습니다. 이미 설치된 앱은 재사용하고, 다른 도구를 선호하면 그 선택을 존중합니다. 권장 안내가 자동 설치 동의는 아니며 필수 의존성으로 만들지 않습니다.

사용자가 Obsidian 사용을 요청했다면 **에이전트가 탐지·설치·열기·vault 설정을 맡습니다**. 이미 요청한 작업 범위는 다시 확인시키지 않고, 도구 권한이 부족하거나 사용자가 직접 선택해야 하는 단계만 알립니다. 기본 Markdown 사용에는 community plugin이 필요하지 않습니다.

1. **기존 앱 확인:** macOS는 `/Applications/Obsidian.app`와 `~/Applications/Obsidian.app`, Windows는 `Get-Command Obsidian`과 통상 설치 위치(`$env:LOCALAPPDATA\Obsidian`, `$env:LOCALAPPDATA\Programs\Obsidian`, `$env:ProgramFiles\Obsidian`)의 실행 파일을 확인합니다. 다른 위치를 이미 알려줬다면 그 값을 씁니다. PATH에 없다는 이유만으로 미설치라고 판단하지 않습니다.
2. **필요할 때 설치:** Windows에 WinGet이 있으면 `winget search`와 `winget show`로 정확한 앱·출처·설치 범위를 확인해 설치할 수 있습니다. macOS에 Homebrew가 있으면 `brew install --cask obsidian`을 사용할 수 있습니다. 이 도구가 없다면 [공식 설치 파일](https://obsidian.md/download)과 지원되는 설치 도구를 사용합니다. Obsidian 설치를 위해 WSL·Git Bash·Homebrew를 먼저 설치할 필요는 없습니다. OS 승인 창이나 라이선스 선택이 필요하면 그 단계만 사용자에게 안내합니다. [Obsidian 설치 문서](https://help.obsidian.md/install), [WinGet 설치 명령](https://learn.microsoft.com/en-us/windows/package-manager/winget/install).
3. **폴더를 vault로 등록:** 앱을 한 번 실행하면 Windows/macOS의 URI 처리가 등록됩니다. `obsidian://choose-vault`는 vault manager를 엽니다. UI 도구가 있으면 **Open folder as vault**로 정한 절대 경로를 선택하고, UI 도구가 없다면 사용자에게 이 폴더 선택만 부탁합니다. 파일을 복사하거나 앱을 띄운 것만으로 등록 완료라고 보고하지 않습니다. Obsidian 전역 vault 목록 파일을 추측해 편집하지 않습니다. [vault 관리](https://help.obsidian.md/manage-vaults), [URI 문서](https://help.obsidian.md/uri).
4. **필요한 vault 설정만 확인:** 기존 `.obsidian`이나 별도 config folder를 보존하고, 실행 중인 앱과 설정 파일을 동시에 수정하지 않습니다. 원하는 항목만 UI 또는 확인한 해당 설정 파일에서 변경합니다. Daily Notes를 쓸 경우 **New file location**은 `01-Daily`, 날짜 형식은 `YYYY-MM-DD`로 맞춥니다. `10-Templates`의 `{{datetime}}` 같은 표기는 에이전트용이므로 core Templates/Daily Notes에 그대로 연결하지 않습니다. 편집기 내 템플릿을 원하면 지원되는 `{{date}}`·`{{time}}` 문법으로 별도 템플릿을 준비하고 실제 생성 결과를 확인합니다. 플러그인 목록·기존 단축키·노트를 일괄 초기화하지 않습니다. [config folder](https://help.obsidian.md/configuration-folder), [Daily Notes](https://help.obsidian.md/plugins/daily-notes), [Templates](https://help.obsidian.md/plugins/templates).

이미 등록된 vault의 노트를 열려면 URI의 `path=`에 **기존 노트의 절대 경로**를 percent-encode해 전달할 수 있습니다. `vault=`에는 등록된 vault의 이름/ID를 씁니다. `/`, `\`, 공백, 한글, `&`, `#` 등을 raw 문자열로 붙이지 않습니다. 예를 들어 Windows 에이전트는 등록을 확인한 뒤 다음처럼 열 수 있습니다:

```powershell
# $VaultPath는 이미 확인한 Windows 절대 경로
$NotePath = Join-Path $VaultPath 'index.md'
if (-not (Test-Path -LiteralPath $NotePath -PathType Leaf)) { throw 'Note not found' }
$Uri = 'obsidian://open?path=' + [Uri]::EscapeDataString($NotePath)
Start-Process -FilePath $Uri
```

macOS bash 도우미는 선택 기능입니다. 앱이 시스템 또는 사용자 Applications 폴더에 있으면 vault manager를 열고 선택할 경로를 출력합니다. 새 폴더 등록은 위의 UI 단계로 확인하세요:

```sh
bash scripts/setup.sh --install-obsidian --open-obsidian --dry-run
# 설치와 실행을 요청한 범위에서만 --dry-run을 빼고 실행
```

### 백업과 Sync는 별도 선택

동기화와 원격 백업은 Obsidian 준비와 별도 선택입니다. 기존 동기화·플러그인 설정을 보존하고, 새 서비스 로그인·유료 Sync·자동 백업을 묵시적으로 켜지 않습니다. Git은 로컬 이력 관리에 사용할 수 있습니다. GitHub 백업을 선택하면 다음을 확인해 **사용자 본인 계정의 개인 비공개 저장소**로 준비합니다.

- 로그인 계정과 저장소 소유자(owner)가 사용자가 지정한 본인 계정인지 확인하고, 새 저장소는 `private`로 만듭니다. 생성·연결 후에도 owner·비공개 설정·저장소 URL을 확인합니다. 이미 확인한 계정과 선택은 재사용합니다. [GitHub 저장소 생성](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository), [GitHub CLI 참고](https://cli.github.com/manual/gh_repo_create).
- 업로드할 위키 자료 범위를 정하고 비밀번호·토큰·개인 비밀자료가 포함되지 않는지 확인합니다. 비공개 저장소도 비밀자료 보관을 자동으로 허용하는 뜻은 아닙니다.
- 기존 원격과 최종 push 대상 주소를 확인합니다. 템플릿을 clone했다면 `origin`이 원본 `ksw6895/llmwiki-template`일 수 있습니다. 개인 자료를 그 원본에 push하지 말고, 확인한 본인의 비공개 저장소를 백업 원격으로 연결합니다. 원격 이름만 믿지 말고 실제 push URL을 확인한 뒤 해당 원격과 브랜치를 명시해 push합니다.
- 기존 원격이나 공개 저장소가 있으면 그 사용 의도를 확인합니다. 공개 범위 변경·원격 교체·삭제를 묵시적으로 하지 않습니다. 사용자가 선택한 백업 원격과 기존 원격의 역할을 구분합니다.

이 템플릿이나 setup은 자동 commit·push를 수행하지 않습니다. 자동 백업은 별도로 요청받았을 때만 실행 환경·자료 범위·비공개 push 대상을 확인해 설정합니다.

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
