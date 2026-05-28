#!/usr/bin/env bash
# vault 루트 _workflows/*.md를 단일 진실 원천으로 삼고,
# Claude Code와 Codex 양쪽의 슬래시 명령 진입점을 글로벌 절대 심링크로 동기화한다.
#
# 결과:
#   ~/.claude/commands/wiki-<name>.md  →  <vault>/_workflows/<name>.md   (절대)
#   ~/.codex/prompts/wiki-<name>.md    →  <vault>/_workflows/<name>.md   (절대)
#
# 사용:
#   bash scripts/sync-workflows.sh           # 양쪽 글로벌 심링크 생성/갱신
#   bash scripts/sync-workflows.sh --unlink  # 양쪽 심링크 제거

set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$VAULT_ROOT/_workflows"
CC_DIR="$HOME/.claude/commands"
CODEX_DIR="$HOME/.codex/prompts"
PREFIX="wiki-"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "ERROR: $SRC_DIR not found"
  exit 1
fi

mkdir -p "$CC_DIR" "$CODEX_DIR"

if [[ "${1:-}" == "--unlink" ]]; then
  for f in "$SRC_DIR"/*.md; do
    name="$(basename "$f")"
    for link in "$CC_DIR/${PREFIX}${name}" "$CODEX_DIR/${PREFIX}${name}"; do
      if [[ -L "$link" ]]; then
        rm "$link"
        echo "unlinked: $link"
      fi
    done
  done
  exit 0
fi

count_cc=0
count_codex=0

for f in "$SRC_DIR"/*.md; do
  name="$(basename "$f")"

  # Claude Code: 글로벌 user scope, 절대 심링크
  cc_link="$CC_DIR/${PREFIX}${name}"
  ln -sfn "$f" "$cc_link"
  count_cc=$((count_cc + 1))

  # Codex: 글로벌 prompts, 절대 심링크
  codex_link="$CODEX_DIR/${PREFIX}${name}"
  ln -sfn "$f" "$codex_link"
  count_codex=$((count_codex + 1))
done

echo "동기화 완료"
echo "   Claude Code: $CC_DIR ($count_cc links, prefix=${PREFIX})"
echo "   Codex      : $CODEX_DIR ($count_codex links, prefix=${PREFIX})"
echo ""
echo "사용법 (어디서든):"
echo "  claude   # /wiki-setup, /wiki-clip, /wiki-daily, /wiki-today-todo, ..."
echo "  codex    # /wiki-setup, /wiki-clip, /wiki-daily, /wiki-today-todo, ..."
