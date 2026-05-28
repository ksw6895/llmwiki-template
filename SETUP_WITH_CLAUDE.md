# SETUP_WITH_CLAUDE — Claude Code로 1분만에 설정

Claude Code가 vault 초기 설정을 자동으로 해줍니다. 사용자는 질문에 답하기만 하면 됩니다.

## 전제

- [Claude Code](https://docs.claude.com/en/docs/claude-code)가 설치되어 있고 로그인되어 있어야 합니다.
- 이 리포를 clone한 디렉토리에 있어야 합니다 (`pwd`로 확인).

## 한 줄 설정

```sh
cd <your-vault-dir>
claude
```

Claude Code가 켜지면 입력:
```
/wiki-setup
```

> `.claude/commands/wiki-setup.md`가 project-scope 슬래시 명령으로 자동 등록되어 있어 clone 직후 바로 사용할 수 있습니다.

## 무슨 일이 일어나나요?

`/wiki-setup`이 다음을 순서대로 처리합니다:

### Step 0: vault 루트 검증
현재 디렉토리에 `AGENTS.md`와 `_workflows/`가 있는지 확인합니다.

### Step 1: 사용자 프로필 수집 (선택)
Claude가 다음을 묻습니다 — 비워두면 placeholder가 유지됩니다:

- 이름
- 이메일
- 언어 선호 (기본: `한국어 기본, 코드/명령어는 영어`)
- 시간대 (기본: `Asia/Seoul (KST, UTC+9)`)
- 활동 영역 한 줄

> **"건너뛰기"라고 답해도 됩니다.** 나중에 `AGENTS.md` §9를 직접 편집해도 됩니다.

### Step 2: placeholder 치환
`_workflows/*.md`의 `__VAULT_ROOT__` placeholder를 현재 디렉토리 절대경로로 치환합니다.

### Step 3: AGENTS.md 사용자 프로필 갱신
사용자가 응답한 항목만 `AGENTS.md` §9에 채워 넣습니다 (이미 채워진 값은 보존).

### Step 4: 글로벌 슬래시 명령 등록
`bash scripts/sync-workflows.sh`를 실행해 다음을 생성:
- `~/.claude/commands/wiki-*.md` — 9개 심링크 (Claude Code 전역)
- `~/.codex/prompts/wiki-*.md` — 9개 심링크 (Codex 전역)

이후로는 **어느 디렉토리에서 Claude Code를 켜도** `/wiki-daily`, `/wiki-clip` 등이 작동합니다.

### Step 5: 첫 일일 노트 생성
`10-Templates/tmpl-daily.md`를 기반으로 오늘 날짜의 `01-Daily/YYYY-MM-DD.md`를 생성합니다.

### Step 6: log.md 첫 줄 append
```
## [YYYY-MM-DD HH:MM] init | vault | initialized via /wiki-setup
## [YYYY-MM-DD HH:MM] create | 01-Daily/YYYY-MM-DD.md | first daily note
```

### Step 7: 요약 출력
완료 메시지 + 다음에 시도해볼 명령어 안내.

## 설정 후 첫 시도

```
> /wiki-daily              # 방금 만든 오늘 일일 노트 보기
> /wiki-today-todo         # 오늘 할 일 합성 (처음엔 비어있어도 OK)
> /wiki-clip https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
                           # Karpathy LLM Wiki gist를 클립으로 저장
> /wiki-moc productivity   # productivity 토픽 MOC 생성
```

## Obsidian과 함께 쓰기 (강력 추천)

1. [Obsidian](https://obsidian.md/) 설치 (무료, 로컬-only).
2. Obsidian 첫 실행 → `Open folder as vault` → 이 디렉토리 선택.
3. 우측 사이드바의 그래프 뷰로 노트 연결을 시각화. 백링크 패널로 역방향 링크 확인.
4. 선택: Community plugin 설치
   - **Templater** — `10-Templates/`의 `{{date:...}}` 동적 처리
   - **Dataview** — 노트 쿼리
   - **Obsidian Git** — 자동 백업

## GitHub 백업 (강력 추천)

```sh
gh repo create my-llm-wiki --private --source=. --push
```

또는 수동:
```sh
git remote add origin git@github.com:<your-user>/my-llm-wiki.git
git push -u origin main
```

자동 백업: Obsidian Git plugin이 N분마다 commit & push.

## 트러블슈팅

**`/wiki-setup`이 보이지 않아요**
- `.claude/commands/wiki-setup.md` 심링크가 살아있는지 확인: `ls -la .claude/commands/wiki-setup.md`
- 심링크가 깨졌다면 (Windows 환경 등): 직접 `bash scripts/setup.sh` 실행 ([SETUP.md](SETUP.md) 참고).

**`__VAULT_ROOT__`가 그대로 남아있어요**
- Setup이 완료되지 않은 경우. 재실행: `/wiki-setup` 또는 `bash scripts/setup.sh`.

**다른 디렉토리에서 `/wiki-daily`가 안 보여요**
- `bash scripts/sync-workflows.sh`로 글로벌 심링크 재생성.
- Claude Code 재시작.

**Claude가 잘못된 폴더에 파일을 만들어요**
- 워크플로의 `__VAULT_ROOT__`가 치환되지 않은 경우. `/wiki-setup` 재실행.

## 다음 단계

- [AGENTS.md](AGENTS.md) §9 사용자 프로필 점검·수정.
- 첫 주 추천 루틴은 [SETUP.md](SETUP.md) 끝부분 참고.
- 새 워크플로 만들고 싶으면 `_workflows/<name>.md` 작성 후 `bash scripts/sync-workflows.sh`.
