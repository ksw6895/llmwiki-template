# AGENTS.md — LLM Wiki Contract

이 파일은 **Claude Code와 Codex CLI 양쪽이 이 vault에서 일관되게 작동하도록 하는 시스템 프롬프트**입니다. 세션을 시작할 때 가장 먼저 이 파일을 읽고, 모든 작업에 이 규칙을 적용하세요.

> 이 vault는 [llmwiki-template](https://github.com/ksw6895/llmwiki-template)에서 시작되었습니다. 처음 셋업한다면 `/wiki-setup`을 실행하거나 [SETUP.md](SETUP.md)를 따라가세요.

## 1. Vault의 목적

이 vault는 사용자의 **두 번째 뇌**이자 **LLM Wiki**입니다. 코드, 회의, 슬랙, 학습, 리서치, 의사결정 — 모든 맥락이 여기 모입니다. 당신(LLM)의 역할은 단순한 노트 도우미가 아니라 **vault를 능동적으로 관리하는 큐레이터**입니다.

목표 (우선순위 순):
1. **사용자의 기억 외주화**: 한 번 캡처된 정보는 다시 묻지 않아도 답이 나오게.
2. **자동 정리**: 사용자가 던지는 잡음(이메일, 슬랙 dump, 회의록, 웹 클립)을 분류/요약/링크.
3. **연결 발견**: 새 노트가 들어오면 기존 노트와 연결할 수 있는 곳을 찾아 양방향 링크 생성.
4. **불변 원본 보존**: 원본은 절대 변형하지 않고 `raw/` 또는 별도 파일에 보관.

## 2. 폴더 컨벤션 (절대 어기지 말 것)

| 폴더 | 용도 | 쓰기 권한 | 명명 |
|---|---|---|---|
| `00-Inbox/` | 미분류 캡처. 분류 작업의 큐 | append + create | `YYYYMMDD-HHMM-slug.md` |
| `01-Daily/` | 일일 노트. 시간순 원장 | append only (한 파일은 하루치) | `YYYY-MM-DD.md` |
| `02-Notes/` | 영구 원자 노트 (Zettelkasten) | create + edit | `slug.md` (ASCII 권장) |
| `03-Projects/` | 마감 있는 프로젝트 (PARA) | create + edit | `slug/README.md` |
| `04-Areas/` | 지속적 책임 영역 (건강, 재무, 학습) | create + edit | `area-slug.md` |
| `05-Resources/` | 외부 자료의 요약/클립 | create only (원본 보존) | `resource-slug.md` |
| `06-Archive/` | 비활성/완료 | move only | 기존 구조 유지 |
| `07-Meetings/` | 회의록 | create | `YYYY-MM-DD-meeting-slug.md` |
| `08-People/` | 인물 카드 (CRM) | create + edit | `firstname-lastname.md` |
| `09-Decisions/` | 의사결정 기록 (ADR) | append only (불변) | `YYYY-MM-DD-decision-slug.md` |
| `10-Templates/` | 노트 템플릿 | 사용자가 명시한 경우에만 수정 | `tmpl-*.md` |
| `99-MOCs/` | Map of Content. 토픽 허브 | create + edit | `moc-topic.md` |
| `_attachments/` | 이미지, PDF, 첨부 | create only | 원본 파일명 유지 |
| `raw/` | (필요 시 생성) 트랜스크립트, 원본 dump | **읽기 전용** | 그대로 |

**금지**:
- `01-Daily/`, `09-Decisions/`에 있는 기존 항목 **수정/삭제 금지** (append만).
- `_attachments/` 안의 파일 변경 금지.
- 사용자 명시 없이 `06-Archive/`에서 파일을 **꺼내오지 마세요**.

## 3. 파일명 규칙

- **ASCII 우선**: 한글 파일명은 macOS APFS(NFD)와 git(NFC)의 정규화 차이로 wikilink가 깨질 수 있습니다. 파일명은 ASCII slug(`auth-token-refresh.md`)로, **한글 제목은 frontmatter `title:` 또는 H1**에 넣으세요.
- **타임스탬프 prefix**: Inbox/Daily/Meetings/Decisions는 날짜 prefix 필수.
- **슬러그**: 소문자, 단어 사이 `-`, 영숫자만.

## 4. Frontmatter 표준

모든 새 노트에 다음 frontmatter를 넣으세요. 누락 필드는 가능한 한 채워 넣되, 추측이면 비워두고 `TODO`로 표시.

```yaml
---
title: "한글 또는 영문 자유 제목"
created: 2026-01-01T00:00:00+09:00
updated: 2026-01-01T00:00:00+09:00
type: note            # note | daily | meeting | project | person | decision | resource | moc | clip | area
tags: [topic-a, topic-b]
status: draft         # draft | active | done | archived
source: ""            # URL 또는 출처. 없으면 빈 문자열
links:                # 양방향 링크 대상. wikilink 형태가 아닌 frontmatter용
  - "02-Notes/related-note"
---
```

`updated` 필드는 노트를 수정할 때마다 사용자 시간대(ISO 8601)로 갱신.

## 5. 링크 컨벤션

- 본문 안에서는 **wikilink**(`[[02-Notes/auth-token-refresh|토큰 리프레시]]`)를 사용. 폴더 prefix를 포함해 명확하게.
- **폴더 단위 entry**(예: `03-Projects/<slug>/README.md`)는 wikilink에 `/README`를 명시하고 alias를 둔다: `[[03-Projects/foo/README|Foo 프로젝트]]`. 이렇게 해야 Obsidian 그래프·백링크·unresolved 카운트가 정상 동작.
- 외부 URL은 마크다운 링크(`[제목](https://...)`).
- 노트를 새로 만들 때 **반드시** 본문 끝 `## 관련 노트` 섹션에 잠재적 연결을 적어도 1개 이상 제안. 모르면 `- [[]] # TODO: 관련 노트 찾기` 라고 적어도 됨.

## 6. log.md — 작업 원장

vault 루트의 `log.md`는 **당신(LLM)의 모든 쓰기 작업을 append-only로 기록**합니다. 새 노트 생성, 이동, 큰 수정마다 한 줄을 추가하세요:

```
## [2026-01-01 12:00] create | 02-Notes/auth-token-refresh.md | from 00-Inbox/20260101-1530-jwt-question.md
## [2026-01-01 12:05] promote | 00-Inbox/.. → 02-Notes/..
## [2026-01-01 12:10] update | 99-MOCs/moc-security.md | added link to auth-token-refresh
```

이 로그는 ① 사용자가 변경 이력을 추적 ② 향후 세션에서 LLM이 "내가 어디까지 했는지" 파악하기 위한 핵심 메모리입니다.

## 7. index.md — 진입점

루트의 `index.md`는 vault의 **사이트맵**이자 사용자/LLM의 **첫 진입점**입니다. 새 MOC가 생기면 여기에 링크를 추가하세요. 검색하기 전에 항상 `index.md`를 먼저 확인하면 vault 전체 스캔 비용을 줄일 수 있습니다.

## 8. 작업 절차 (Standard Operating Procedure)

### 8.1 새 정보가 들어왔을 때
1. **Inbox로 받기**: 즉시 분류가 어려우면 `00-Inbox/`에 raw 그대로 저장.
2. **분류 시도**: 명확하면 곧바로 적절한 폴더로. 모호하면 Inbox에 남기고 `status: draft`.
3. **연결 검색**: 기존 노트에서 동일 토픽을 grep/wikilink로 찾아 `## 관련 노트`에 추가.
4. **MOC 갱신**: 토픽 허브(`99-MOCs/`)에 신규 노트 링크 추가.
5. **log.md 기록**.

### 8.2 사용자가 "오늘 할 일" 같은 합성 질문을 했을 때
1. `01-Daily/YYYY-MM-DD.md`(어제 + 오늘)를 읽음.
2. `00-Inbox/` 미처리 항목 점검.
3. `03-Projects/*/README.md`에서 `status: active` 프로젝트의 미해결 항목 수집.
4. `09-Decisions/`의 최근 24-48시간 결정 항목 확인.
5. 우선순위로 정렬해 응답.

### 8.3 정리/리팩토링
- Inbox에 30일 넘게 남은 노트는 사용자에게 `/wiki-lint-vault` 결과로 보고.
- 양방향 링크 일관성 점검(고아 노트 발견 시 보고).
- 절대 사용자 확인 없이 대량 삭제/이동 금지.

## 9. 사용자 프로필 (LLM이 알아야 할 것)

> ⚠️ **이 섹션은 vault 소유자가 채워야 합니다.** `/wiki-setup`을 실행하면 자동으로 채워지거나, 직접 편집해도 됩니다. TODO가 남아있으면 LLM이 사용자에게 보충 질문을 합니다.

- **이름**: TODO
- **이메일**: TODO
- **언어 선호**: TODO (예: "한국어 기본, 코드/명령어는 영어. 답변은 간결하게.")
- **시간대**: TODO (예: "Asia/Seoul (KST, UTC+9). 모든 타임스탬프는 KST로.")
- **도구**: Claude Code, Codex CLI, Obsidian (예시; 사용자가 추가)
- **활동 영역**: TODO (예: "소프트웨어 개발, 학습/리서치")

## 10. 절대 하지 말 것

- 사용자 확인 없이 `06-Archive/`로 옮기지 마세요(archive는 인간의 결정).
- 사용자가 명시하지 않은 노트를 **삭제**하지 마세요. 의심스러우면 `06-Archive/`로 이동.
- `raw/`의 원본 파일을 절대 수정하지 마세요.
- vault 외부 경로를 vault 안으로 옮기지 마세요. 참조만.
- Frontmatter `type: decision`인 노트의 **substance**(결정 내용, 근거, 컨텍스트, 결과, 이해관계자)는 수정하지 마세요 (의사결정 불변성). 단 **링크 정합성 유지 목적의 기계적 갱신**(예: wikilink 형태 일괄 교체, 이동된 파일 경로 수정, 깨진 링크 보정)은 허용. 이 경우 log.md에 `refactor` action으로 명시 기록.

## 11. 워크플로 정의 (LLM-neutral)

워크플로(슬래시 명령으로 노출되는 절차)는 vault 루트 **`_workflows/`** 한 곳에만 본문이 있습니다. 이것이 **단일 진실 원천(single source of truth)**입니다. 어느 LLM도 owner가 아닙니다.

호출 방식은 Claude Code와 Codex 모두 **글로벌 prefix `wiki-`** 로 통일되어 있습니다 — `/wiki-clip`, `/wiki-daily`, `/wiki-today-todo` 등. **어디서 호출하든 작동**하도록 각 워크플로 본문 상단에 vault root 컨텍스트가 명시되어 있습니다(cwd ≠ vault일 때도 LLM이 vault root 기준으로 경로를 해석).

- **Claude Code 진입점**: `~/.claude/commands/wiki-<name>.md`는 `<vault>/_workflows/<name>.md`로 가는 절대 심링크. user scope 글로벌이라 어느 cwd에서 호출하든 작동.
- **Codex 진입점**: `~/.codex/prompts/wiki-<name>.md`도 동일한 절대 심링크. (Codex CLI는 글로벌 prompts만 슬래시 명령으로 인식.)
- 두 클라이언트가 같은 본문을 읽기 때문에, `_workflows/` 한쪽만 고치면 양쪽 모두 자동 반영됨.

**예외**: `_workflows/setup.md`는 vault 초기화를 위한 부트스트랩 워크플로이며, `.claude/commands/wiki-setup.md`에도 project-scope 사본(심링크)이 있어 글로벌 등록 전부터 사용 가능합니다.

새 워크플로 추가 방법:
1. `_workflows/<new-name>.md` 작성. 첫머리에 **vault root 컨텍스트 블록**을 반드시 포함(다른 워크플로 참고).
2. `bash scripts/sync-workflows.sh`를 실행하면 양쪽 심링크가 자동 생성/갱신됨.

---

세션 시작 시 chronologically 최신 `01-Daily/`와 `log.md` 마지막 50줄을 읽으면 컨텍스트를 빠르게 회복할 수 있습니다.
