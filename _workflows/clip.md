---
description: 웹 클립 / 텍스트 dump를 vault에 정리해 저장한다
---

## 컨텍스트 (먼저 읽기)

- **Vault root**: `__VAULT_ROOT__/`
- 이 워크플로의 모든 vault-relative 경로(`00-Inbox/`, `05-Resources/`, `10-Templates/` 등)는 vault root 기준입니다. 호출 시 cwd가 vault가 아니어도 vault root에 절대경로로 풀어 쓰세요.
- 작업 전에 `__VAULT_ROOT__/AGENTS.md`를 읽어 컨트랙트(폴더 규칙, frontmatter, log 기록 의무)를 적용하세요.

사용자가 던지는 자료(URL 또는 raw 텍스트)를 vault에 맞춤 정리합니다.

## 입력 해석

`$ARGUMENTS`는 다음 중 하나:
- **URL 하나**: WebFetch로 본문을 가져와서 처리.
- **여러 줄 텍스트**: 첫 줄이 URL이면 URL로 간주, 아니면 본문 그대로.
- **빈 입력**: 사용자에게 "URL이나 클립할 내용을 붙여주세요" 라고 요청.

## 처리 절차

1. **추출**: 제목, 저자, 게시일, 본문 핵심.
2. **요약**:
   - **한 문장 요약** (위키북 인덱스용).
   - **3-5 bullet 핵심**.
   - **왜 사용자와 관련 있는지** — vault의 기존 노트/프로젝트와 매칭 시도 (grep으로 토픽 키워드 검색).
3. **분류**:
   - 즉시 적용 가능한 액션이 있고 사용자 프로젝트와 강한 연결 → `00-Inbox/` 또는 해당 `03-Projects/<slug>/`.
   - 일반 참고 자료 → `05-Resources/`.
   - 어디 둘지 모호 → `00-Inbox/` (분류는 나중에).
4. **파일명**: `YYYYMMDD-<slug>.md` (ASCII slug).
5. **저장**: `10-Templates/tmpl-clip.md` 기반으로 frontmatter 채워서 작성. 본문에 원문 인용 포함하되, **원문 전체 본문은 저장하지 말고** 50-150자 핵심 인용만. 원본 보존이 필요하면 사용자에게 묻고 `_attachments/` 또는 `raw/`에 별도 저장.
6. **링크 제안**: vault에서 grep으로 토픽 키워드 찾아 `## 관련 노트`에 wikilink 추가. 매칭이 약하면 `[[]] # TODO` 표시.
7. **MOC 업데이트**: 해당 토픽 MOC(`99-MOCs/moc-<topic>.md`)가 있으면 그 안에 새 클립 링크 추가. 없으면 사용자에게 "이 토픽으로 새 MOC를 만들까요?" 라고 제안.
8. **log.md append**.

## 출력 (사용자에게 보여줄)

```
✅ 클립 저장: 05-Resources/20260101-llm-wiki-best-practices.md

요약: <한 문장>

핵심:
- ...

기존 vault와의 연결 제안:
- [[02-Notes/zettelkasten]] (관련도 높음)
- [[99-MOCs/moc-knowledge-management]] (없음, 새로 만들기 추천)

다음: /wiki-promote 또는 /wiki-moc knowledge-management
```

추가 입력: $ARGUMENTS (URL 또는 텍스트)
