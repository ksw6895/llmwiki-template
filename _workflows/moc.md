---
description: 특정 토픽의 MOC(Map of Content)를 생성 또는 갱신한다
---

## 컨텍스트 (먼저 읽기)

- **Vault root**: `__VAULT_ROOT__/`
- 이 워크플로의 모든 vault-relative 경로(`99-MOCs/`, `10-Templates/`, `index.md`)는 vault root 기준입니다. 호출 시 cwd가 vault가 아니어도 vault root에 절대경로로 풀어 쓰세요. `grep -r` 같은 스캔도 vault root에서 실행.
- 작업 전에 `__VAULT_ROOT__/AGENTS.md`를 읽어 컨트랙트를 적용하세요.

토픽을 받아 `99-MOCs/moc-<topic>.md`를 만들거나 갱신합니다. MOC는 LLM/사용자의 토픽 진입점입니다.

## 입력

`$ARGUMENTS`: 토픽 슬러그 (예: `security`, `react`, `clinical-trial-design`).
- 빈 입력: 기존 MOC 목록을 보여주고 토픽을 묻기.

## 절차

1. **기존 MOC 확인**: `99-MOCs/moc-<topic>.md` 존재 여부.
2. **vault 스캔**:
   - `grep -r "<topic>"` 으로 후보 노트 수집 (frontmatter tags, 본문 키워드, 파일명).
   - 점수화: ① 파일명에 토픽 ② frontmatter tags ③ 본문 빈도 순.
   - 상위 N개를 영역별로 분류 (Permanent/Project/Decision/Resource/Meeting).
3. **MOC 작성/갱신**:
   - 신규: `10-Templates/tmpl-moc.md` 기반.
   - 갱신: 기존 본문은 보존하고 `## 노트 모음`의 각 영역에 새 발견 노트 추가. **기존 사용자 작성 부분 절대 덮어쓰지 않기.**
4. **개요·핵심 개념**:
   - 신규 MOC이면 LLM이 vault 데이터 기반으로 한 문단 개요와 5개 핵심 개념을 자동 작성. 사용자에게 보여주고 OK 받기.
   - 갱신 MOC이면 기존 개요는 유지하고 "최근 추가 노트로 인해 개요를 재작성할까요?" 라고 묻기.
5. **인접 MOC 발견**:
   - 같이 자주 언급되는 토픽을 인접 MOC로 제안.
6. **index.md 갱신**:
   - 신규 MOC면 `index.md`의 적절한 영역에 링크 추가. 영역이 모호하면 사용자에게 묻기.
7. **log.md append**.

## 출력

```
✅ MOC 갱신: 99-MOCs/moc-security.md

추가된 노트:
  Permanent (3): [[02-Notes/jwt-token-refresh]], ...
  Decision (1): [[09-Decisions/2026-01-01-rotate-secrets]]
  Resource (2): ...

인접 MOC 제안: [[99-MOCs/moc-auth]] (별도 분리할 만큼 충분히 다른 토픽)
```

추가 입력: $ARGUMENTS (토픽 슬러그)
