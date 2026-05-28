---
description: Inbox의 미분류 노트를 영구 노트로 승격한다
---

## 컨텍스트 (먼저 읽기)

- **Vault root**: `__VAULT_ROOT__/`
- 이 워크플로의 모든 vault-relative 경로(`00-Inbox/`, `02-Notes/`, `03-Projects/`, `04-Areas/`, `05-Resources/`, `06-Archive/inbox/`)는 vault root 기준입니다. 호출 시 cwd가 vault가 아니어도 vault root에 절대경로로 풀어 쓰세요.
- 작업 전에 `__VAULT_ROOT__/AGENTS.md`를 읽어 컨트랙트를 적용하세요.

`00-Inbox/`의 노트를 적절한 영구 위치(`02-Notes/`, `03-Projects/`, `04-Areas/`, `05-Resources/`)로 옮기고, 양방향 링크/MOC를 갱신합니다.

## 입력

`$ARGUMENTS`:
- 파일명 또는 경로 (예: `20260101-1530-jwt-question.md` 또는 `00-Inbox/...`).
- 비어 있으면: `00-Inbox/`를 ls해서 후보를 보여주고 사용자에게 어느 것을 승격할지 묻기.

## 절차

1. **노트 읽기**: 본문 + frontmatter.
2. **승격 위치 결정**:
   - 시간성·이벤트성 → 보통 승격 부적합. Daily 또는 Meetings로 통합 권유.
   - 재사용 가능한 개념·정의·인사이트 → `02-Notes/` (원자 노트).
   - 진행 중인 작업 흐름 → `03-Projects/<existing-slug>/` 또는 새 프로젝트 생성 제안.
   - 지속 책임(건강, 재무, 학습 영역) → `04-Areas/`.
   - 외부 자료의 요약 → `05-Resources/`.
3. **원자화 (필요 시)**:
   - 한 노트에 여러 개념이 섞여 있으면 **원자 단위로 분리**해 각각 별도 노트로. 분리 전 사용자에게 분할안을 보여주고 확인.
4. **파일명 재정비**: ASCII slug. 날짜 prefix 제거 (영구 노트는 시간성을 갖지 않음).
5. **frontmatter 갱신**:
   - `type` 적절히 변경.
   - `status: draft` → `active` 또는 `done`.
   - `created`는 유지, `updated`는 지금.
6. **링크 작업**:
   - 본문의 외부/내부 참조를 wikilink로 정리.
   - 기존 vault에서 grep으로 관련 노트 3개 이상 찾아 `## 관련 노트` 추가.
   - 토픽 MOC에 신규 노트 링크 추가.
7. **원본 처리**:
   - 승격한 Inbox 파일은 **삭제하지 말고** `06-Archive/inbox/` 로 이동(추적성). 또는 사용자가 명시적으로 "지워" 하면 삭제.
8. **log.md append**:
   - `## [date time] promote | 00-Inbox/old.md → 02-Notes/new.md`

## 출력

```
✅ 승격: 00-Inbox/20260101-1530-jwt-token-question.md
      → 02-Notes/jwt-token-refresh.md

frontmatter: type=note, status=active, tags=[auth, security, jwt]
연결: [[99-MOCs/moc-security]] 추가, [[02-Notes/oauth-flow]] 양방향 링크

원본은 06-Archive/inbox/로 이동했습니다.
```

추가 입력: $ARGUMENTS (Inbox 파일명 또는 비어 있음)
