---
title: "Vault Index — 진입점"
created: 2026-01-01T00:00:00+09:00
updated: 2026-01-01T00:00:00+09:00
type: moc
tags: [index, moc, vault-root]
status: active
---

# Vault Index

이 vault의 **첫 진입점**입니다. LLM은 검색 전에 여기를 먼저 봅니다.

> 이 vault는 [llmwiki-template](https://github.com/ksw6895/llmwiki-template)에서 시작되었습니다. 처음이라면 [README.md](README.md) → [SETUP_WITH_CLAUDE.md](SETUP_WITH_CLAUDE.md)를 보세요.

## 오늘

- 오늘의 일일 노트: `/wiki-daily` 호출 (또는 `01-Daily/YYYY-MM-DD.md` 직접 열기)
- 오늘 할 일: `/wiki-today-todo` 호출
- Inbox 처리할 항목: [00-Inbox/](00-Inbox/) 디렉토리 점검

## Active Projects

> 새 프로젝트를 만들면 여기에 wikilink 추가:
> - `[[03-Projects/<slug>/README|<프로젝트 이름>]]`

_(아직 없음 — `03-Projects/<slug>/README.md` 형태로 만들고 여기에 추가하세요)_

## 영역별 MOC (Map of Content)

> 새 토픽 허브가 생기면 여기에 링크를 추가하세요. `/wiki-moc <topic>`으로 생성/갱신.

_(아직 없음)_

## 핵심 문서

- [[AGENTS.md|LLM 컨트랙트 (Claude Code + Codex 공통)]]
- [[README.md|사람용 빠른 시작]]
- [[SETUP.md|수동 설정 가이드]]
- [[SETUP_WITH_CLAUDE.md|Claude 자동 설정]]
- [[log.md|LLM 작업 로그]]

## 빠른 링크

- [Daily Notes](01-Daily/)
- [Permanent Notes](02-Notes/)
- [Projects](03-Projects/)
- [Areas](04-Areas/)
- [Resources](05-Resources/)
- [People](08-People/)
- [Decisions](09-Decisions/)
- [Meetings](07-Meetings/)
- [MOCs](99-MOCs/)

## 자주 쓰는 명령어

```
/wiki-setup              # 첫 설정 (한 번만)
/wiki-daily              # 오늘 일일 노트
/wiki-today-todo         # 오늘 할 일 합성
/wiki-clip <URL/text>    # 웹 클립 정리
/wiki-promote <inbox>    # Inbox → Permanent
/wiki-moc <topic>        # 토픽 MOC 생성
/wiki-lint-vault         # 무결성 점검
/wiki-quiz <target>      # 학습 퀴즈
/wiki-ingest-meeting <transcript>  # 회의록 정리
```
