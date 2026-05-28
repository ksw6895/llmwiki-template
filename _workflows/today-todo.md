---
description: 여러 출처(Daily, Inbox, Projects, Decisions, Meetings)에서 오늘 할 일을 합성한다
---

## 컨텍스트 (먼저 읽기)

- **Vault root**: `__VAULT_ROOT__/`
- 이 워크플로의 모든 vault-relative 경로(`01-Daily/`, `00-Inbox/`, `03-Projects/`, `07-Meetings/`, `09-Decisions/`)는 vault root 기준입니다. 호출 시 cwd가 vault가 아니어도 vault root에 절대경로로 풀어 쓰세요.
- 작업 전에 `__VAULT_ROOT__/AGENTS.md`를 읽어 컨트랙트를 적용하세요.

여러 출처를 종합해 **오늘 우선순위로 정렬된 할 일 목록**을 만듭니다.

## 수집 절차

1. **어제 일일 노트** (`01-Daily/<yesterday>.md`) → `## 내일로 이월` 섹션의 항목.
2. **오늘 일일 노트** (`01-Daily/<today>.md`) → `## 오늘의 의도` 섹션과 미체크 `[ ]` 항목.
3. **00-Inbox/** → 분류 안 된 항목 중 `status: draft`이고 7일 이상 묵은 것.
4. **03-Projects/*/README.md** → frontmatter `status: active`인 프로젝트의 본문에서 미체크 `[ ]` 추출.
5. **07-Meetings/** → 최근 7일 회의록의 `## 액션 아이템` 미체크 항목.
6. **09-Decisions/** → 최근 결정 중 `재검토 조건`이 오늘과 매칭되는 것.

## 출력 형식

다음 4구역으로 나눠서 출력:

```
## 🔥 오늘 반드시 (deadline/약속/긴급)
- [ ] (project) ...
- [ ] (meeting:YYYY-MM-DD owner:나) ...

## 🎯 오늘 우선 (이월·진행 중)
- [ ] (yesterday) ...
- [ ] (active project) ...

## 🌱 가능하면 (Inbox 정리·학습)
- [ ] (inbox:7d+) ...

## 💡 LLM의 제안
- (관찰: 최근 X 프로젝트 미체크 5개 누적. 분할 권유)
- (관찰: 결정 ADR-YYYYMMDD 재검토 시점 도래)
```

각 항목 옆에 출처를 괄호로. 우선순위 판단은 ① 명시된 마감 ② 외부 약속 ③ 진행 중 작업 ④ Inbox 처리 ⑤ 학습 순.

마지막에 한 줄 — "오늘 일일 노트에 이 목록을 자동 반영할까요?" 라고 사용자에게 묻고 yes면 `01-Daily/<today>.md`의 `## 오늘의 의도` 아래에 추가. log.md에는 update로 기록.

추가 입력: $ARGUMENTS (선택 — 특정 영역만 보고 싶을 때, 예: "projects only")
