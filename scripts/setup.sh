#!/usr/bin/env bash
# vault 초기화 (Claude Code 없이 셸로 수행하는 경로).
# /wiki-setup 워크플로의 비대화형 버전 — `__VAULT_ROOT__` placeholder를
# 실제 절대경로로 치환하고 글로벌 슬래시 명령을 등록한다.
#
# 사용:
#   bash scripts/setup.sh           # vault 초기화
#   bash scripts/setup.sh --unlink  # 글로벌 심링크 제거 (vault 정리)

set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$VAULT_ROOT"

if [[ "${1:-}" == "--unlink" ]]; then
  bash "$VAULT_ROOT/scripts/sync-workflows.sh" --unlink
  exit 0
fi

# Step 0: vault 검증
if [[ ! -f "$VAULT_ROOT/AGENTS.md" || ! -d "$VAULT_ROOT/_workflows" ]]; then
  echo "ERROR: vault 루트가 아닙니다. AGENTS.md / _workflows/ 가 보이지 않음."
  echo "       현재 위치: $VAULT_ROOT"
  exit 1
fi

# Step 1: __VAULT_ROOT__ 치환
echo "[1/5] __VAULT_ROOT__ placeholder를 $VAULT_ROOT 로 치환..."
# macOS sed는 -i ''  필요, GNU sed는 -i.
if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(-i)
else
  SED_INPLACE=(-i '')
fi

# vault 이동 감지용 마커 — 옛 절대경로 추적
MARKER="$VAULT_ROOT/.setup-vault-root"
OLD_VAULT_ROOT=""
if [[ -f "$MARKER" ]]; then
  OLD_VAULT_ROOT="$(cat "$MARKER")"
fi

CHANGED=0
MIGRATED=0
# _workflows/*.md 치환 (setup.md는 placeholder를 문서 설명용으로 포함하므로 제외)
for f in "$VAULT_ROOT"/_workflows/*.md "$VAULT_ROOT/AGENTS.md" "$VAULT_ROOT/CLAUDE.md"; do
  [[ -f "$f" ]] || continue
  [[ "$(basename "$f")" == "setup.md" ]] && continue

  # 첫 셋업: placeholder 치환
  if grep -q "__VAULT_ROOT__" "$f"; then
    sed "${SED_INPLACE[@]}" "s|__VAULT_ROOT__|$VAULT_ROOT|g" "$f"
    CHANGED=$((CHANGED + 1))
    continue
  fi

  # 재셋업 (vault 이동 후): 옛 절대경로 → 새 경로 마이그레이션
  if [[ -n "$OLD_VAULT_ROOT" && "$OLD_VAULT_ROOT" != "$VAULT_ROOT" ]] && grep -qF "$OLD_VAULT_ROOT" "$f"; then
    sed "${SED_INPLACE[@]}" "s|$OLD_VAULT_ROOT|$VAULT_ROOT|g" "$f"
    MIGRATED=$((MIGRATED + 1))
  fi
done

# 마커 갱신 — 다음 setup이 옛 경로로 인식
echo "$VAULT_ROOT" > "$MARKER"

if (( MIGRATED > 0 )); then
  echo "       치환: $CHANGED 개, 마이그레이션: $MIGRATED 개 ($OLD_VAULT_ROOT → $VAULT_ROOT)"
else
  echo "       치환 완료: $CHANGED 개 파일"
fi

# Step 2: 글로벌 슬래시 명령 등록
echo "[2/5] 글로벌 슬래시 명령 등록..."
bash "$VAULT_ROOT/scripts/sync-workflows.sh"

# Step 3: 첫 일일 노트
TODAY="$(date +%Y-%m-%d)"
NOW_DATE="$(date +%Y-%m-%d)"
NOW_TIME="$(date +%H:%M:%S)"
YESTERDAY="$(date -v-1d +%Y-%m-%d 2>/dev/null || date -d 'yesterday' +%Y-%m-%d)"
DAILY="$VAULT_ROOT/01-Daily/$TODAY.md"

echo "[3/5] 오늘 일일 노트 확인: 01-Daily/$TODAY.md"
if [[ ! -f "$DAILY" ]]; then
  TMPL="$VAULT_ROOT/10-Templates/tmpl-daily.md"
  if [[ -f "$TMPL" ]]; then
    sed -e "s|{{date:YYYY-MM-DD}}|$NOW_DATE|g" \
        -e "s|{{date:YYYY-MM-DD ddd}}|$NOW_DATE|g" \
        -e "s|{{date:YYYY-MM-DD (ddd)}}|$NOW_DATE|g" \
        -e "s|{{time:HH:mm:ss}}|$NOW_TIME|g" \
        -e "s|{{date-1d:YYYY-MM-DD}}|$YESTERDAY|g" \
        "$TMPL" > "$DAILY"
    echo "       생성: $DAILY"
  else
    echo "       (tmpl-daily.md 없음, 건너뜀)"
  fi
else
  echo "       이미 존재함, 건너뜀"
fi

# Step 4: log.md append (idempotent)
LOG="$VAULT_ROOT/log.md"
TS="$NOW_DATE $(date +%H:%M)"

# init 라인: vault 최초 셋업 시 1회만
if ! grep -q "init | vault" "$LOG" 2>/dev/null; then
  printf '\n## [%s] init | vault | initialized via scripts/setup.sh\n' "$TS" >> "$LOG"
elif (( MIGRATED > 0 )); then
  # 마이그레이션 발생: refactor 라인 기록
  printf '## [%s] refactor | vault | migrated %s → %s\n' "$TS" "$OLD_VAULT_ROOT" "$VAULT_ROOT" >> "$LOG"
fi

# create 라인: 오늘 daily가 log에 아직 안 찍혔을 때
if [[ -f "$DAILY" ]] && ! grep -q "01-Daily/$TODAY.md" "$LOG" 2>/dev/null; then
  printf '## [%s] create | 01-Daily/%s.md | first daily note\n' "$TS" "$TODAY" >> "$LOG"
fi

echo "[4/5] log.md 갱신 완료"

# Step 5: Obsidian 자동 설치 / vault 열기 + plugin 안내
echo "[5/5] Obsidian 감지 / 자동 설치 / vault 열기..."

# OS 감지
case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null; then OS=wsl; else OS=linux; fi
    ;;
  CYGWIN*|MINGW*|MSYS*) OS=windows ;;
  *) OS=unknown ;;
esac

OBSIDIAN_OK=0
OBSIDIAN_OPEN_SKIP="${OBSIDIAN_OPEN_SKIP:-0}"  # 테스트용 환경변수

case "$OS" in
  macos)
    if [[ -d "/Applications/Obsidian.app" ]]; then
      OBSIDIAN_OK=1
      echo "       Obsidian 이미 설치되어 있습니다."
    elif command -v brew >/dev/null 2>&1; then
      echo "       Obsidian 미설치 → Homebrew로 설치 시도 (시간 좀 걸림)..."
      if brew install --cask obsidian 2>&1 | tail -3; then
        [[ -d "/Applications/Obsidian.app" ]] && OBSIDIAN_OK=1
        (( OBSIDIAN_OK )) && echo "       설치 완료."
      fi
    else
      echo "       Obsidian 미설치, Homebrew 없음."
      echo "         옵션 A: https://brew.sh 에서 brew 설치 → 이 스크립트 재실행"
      echo "         옵션 B: https://obsidian.md/download 에서 .dmg 직접 다운로드"
    fi
    if (( OBSIDIAN_OK == 1 )) && [[ "$OBSIDIAN_OPEN_SKIP" != "1" ]]; then
      echo "       vault 자동 열기: open -a Obsidian \"$VAULT_ROOT\""
      open -a Obsidian "$VAULT_ROOT" 2>/dev/null || \
        echo "       (자동 열기 실패. 수동: Obsidian → Open folder as vault → $VAULT_ROOT)"
    fi
    ;;
  linux)
    if command -v obsidian >/dev/null 2>&1; then
      OBSIDIAN_OK=1
      echo "       Obsidian 설치 확인됨."
      if [[ "$OBSIDIAN_OPEN_SKIP" != "1" ]]; then
        echo "       vault 백그라운드 열기..."
        (obsidian "$VAULT_ROOT" >/dev/null 2>&1 &) || true
      fi
    else
      echo "       Obsidian 미설치. 설치 옵션 (택1):"
      echo "         flatpak install flathub md.obsidian.Obsidian"
      echo "         sudo snap install obsidian --classic"
      echo "         AppImage 다운로드: https://obsidian.md/download"
    fi
    ;;
  wsl|windows)
    echo "       Windows host에서 Obsidian 설치 (PowerShell 또는 cmd):"
    echo "         winget install Obsidian.Obsidian"
    echo "         또는 https://obsidian.md/download"
    if [[ "$OS" == "wsl" ]]; then
      echo "       (WSL 경로 변환): Windows host에서 vault 열 때 경로는:"
      command -v wslpath >/dev/null 2>&1 && echo "         $(wslpath -w "$VAULT_ROOT")" || echo "         $VAULT_ROOT"
    else
      echo "       설치 후: Obsidian → Open folder as vault → $VAULT_ROOT"
    fi
    ;;
  *)
    echo "       OS 감지 실패. https://obsidian.md/download 에서 수동 설치."
    ;;
esac

echo ""
echo "✅ vault 초기화 완료"
echo ""
echo "VAULT_ROOT: $VAULT_ROOT"
echo ""
echo "다음 시도 (어디서든):"
echo "  claude   # /wiki-daily, /wiki-today-todo, /wiki-clip <URL>"
echo "  codex    # 같은 명령들"
echo ""
echo "✨ Obsidian community plugin 추천"
echo "   Obsidian이 열렸으면 Settings → Community plugins → Browse 에서 검색·설치:"
echo ""
echo "   필수:"
echo "     Templater          - 10-Templates/의 {{date:...}} 동적 처리"
echo "   강력 추천:"
echo "     Dataview           - 노트 쿼리, MOC/Daily 합성에 유용"
echo "     Periodic Notes     - 일일/주간 노트 자동"
echo "     Obsidian Git       - 자동 백업 (10분마다 commit & push)"
echo "   선택:"
echo "     Local REST API     - LLM이 Obsidian 실행 상태에 접근 (MCP 통로)"
echo "     Tag Wrangler       - 태그 관리"
echo ""
echo "(선택) AGENTS.md §9의 사용자 프로필 TODO를 채워주세요 (Claude로 /wiki-setup 호출하면 자동)."
