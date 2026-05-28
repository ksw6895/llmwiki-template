---
description: 회의 트랜스크립트를 구조화된 회의록으로 정리한다
---

## 컨텍스트 (먼저 읽기)

- **Vault root**: `__VAULT_ROOT__/`
- 이 워크플로의 모든 vault-relative 경로(`07-Meetings/`, `08-People/`, `09-Decisions/`, `raw/meetings/`)는 vault root 기준입니다. 호출 시 cwd가 vault가 아니어도 vault root에 절대경로로 풀어 쓰세요.
- 작업 전에 `__VAULT_ROOT__/AGENTS.md`를 읽어 컨트랙트를 적용하세요.

회의 트랜스크립트(또는 메모)를 받아 `07-Meetings/`에 구조화된 노트로 저장합니다.

## 입력

`$ARGUMENTS`는 다음 중 하나:
- **트랜스크립트 텍스트**: 그대로 처리.
- **파일 경로**: 해당 파일을 읽어 처리. (예: `~/Downloads/meeting-2026-01-01.txt`)
- **빈 입력**: "회의 트랜스크립트를 붙여주거나 파일 경로를 알려주세요" 요청.

## 처리 절차

1. **메타 추출**:
   - 일시 (트랜스크립트 헤더 또는 사용자 입력에서).
   - 참석자 — 이름 추출, vault `08-People/`에 있으면 wikilink, 없으면 새 인물 카드 생성 제안.
   - 장소/플랫폼 — Zoom/Slack/오프라인 등 자동 감지.
2. **본문 합성**:
   - **의제**: 명시되어 있으면 그대로, 아니면 LLM이 추론해 3-5 항목.
   - **논의 내용**: 화자별 요약이 아니라 **토픽별** 정리. 토픽 안에서 누가 어떤 입장이었는지.
   - **결정 사항**: 동사 + 주체 + 무엇을. 강한 결정(예: 방향 전환, 큰 지출, 인사)은 별도로 `09-Decisions/`에 ADR로 옮길지 사용자에게 묻기.
   - **액션 아이템**: `[ ] (@owner, due YYYY-MM-DD)` 형식 엄수. due 명시 없으면 빈칸.
   - **미해결 / 다음 회의로**: 의도적으로 보류된 항목.
3. **저장**:
   - 파일명: `07-Meetings/YYYY-MM-DD-<short-slug>.md` (ASCII slug).
   - frontmatter `participants`, `decisions`, `action_items` 배열 채우기.
4. **원본 보존**:
   - 트랜스크립트 원문은 `raw/meetings/YYYY-MM-DD-<slug>.txt`에 저장(있다면). 회의록 본문에서 wikilink로 참조.
5. **링크 작업**:
   - 참석자 각각의 `08-People/<name>.md`의 `## 최근 상호작용`에 한 줄 추가.
   - 관련 프로젝트 `03-Projects/<slug>/README.md`의 본문에 회의 wikilink 추가.
6. **결정 → ADR 승격 옵션**:
   - "이 회의의 결정 N개 중 ADR로 분리할 것이 있나요?" 사용자에게 묻고, 있으면 `09-Decisions/YYYY-MM-DD-<slug>.md` 생성.
7. **log.md append**.

## 출력

```
✅ 회의록 저장: 07-Meetings/2026-01-01-product-review.md

참석자: [[08-People/jane-doe]] (new), [[08-People/john-smith]]
결정: 3건 ( 1건은 ADR 후보 → 사용자 확인 필요)
액션 아이템: 5건 (@나 2, @jane 2, @john 1)
연결된 프로젝트: [[03-Projects/<slug>/README]]

다음: /wiki-quiz 2026-01-01-product-review  (이해 점검)
```

추가 입력: $ARGUMENTS (트랜스크립트 또는 파일 경로)
