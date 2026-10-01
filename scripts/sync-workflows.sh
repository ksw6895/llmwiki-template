#!/usr/bin/env bash
# Optional legacy global entry points; common workflow bodies stay in the vault.
set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$VAULT_ROOT/_workflows"
COMMAND_HOME="${WIKI_COMMAND_HOME:-$HOME}"
CC_DIR="$COMMAND_HOME/.claude/commands"
CODEX_DIR="$COMMAND_HOME/.codex/prompts"
OWNER="<!-- llmwiki-template vault: $VAULT_ROOT -->"
UNLINK=0
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --unlink) UNLINK=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --help|-h)
      echo "Usage: bash scripts/sync-workflows.sh [--unlink] [--dry-run]"
      echo "Writes optional global entries under WIKI_COMMAND_HOME (default: user home)."
      exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done
[[ -d "$SRC_DIR" ]] || { echo "Missing workflows: $SRC_DIR" >&2; exit 1; }

# Only replace/remove entries demonstrably owned by this vault. Includes old symlinks.
owned_entry() {
  local entry="$1" source="$2" first=""
  if [[ -L "$entry" ]]; then
    [[ "$(readlink "$entry")" == "$source" ]]
  elif [[ -f "$entry" ]]; then
    first="$(sed -n '4p' "$entry")"
    [[ "$first" == "$OWNER" ]]
  else
    return 1
  fi
}

# Preflight the complete set so conflicts do not cause a partial installation.
if (( ! UNLINK )); then
  conflicts=0
  for source in "$SRC_DIR"/*.md; do
    name="$(basename "$source")"
    for dir in "$CC_DIR" "$CODEX_DIR"; do
      entry="$dir/wiki-$name"
      if [[ -e "$entry" || -L "$entry" ]] && ! owned_entry "$entry" "$source"; then
        echo "Conflict, leaving existing entry unchanged: $entry" >&2
        conflicts=$((conflicts + 1))
      fi
    done
  done
  (( conflicts == 0 )) || exit 1
fi

for source in "$SRC_DIR"/*.md; do
  name="$(basename "$source")"
  for dir in "$CC_DIR" "$CODEX_DIR"; do
    entry="$dir/wiki-$name"
    if (( UNLINK )); then
      if owned_entry "$entry" "$source"; then
        if (( ! DRY_RUN )); then rm "$entry"; fi
        echo "Remove owned entry: $entry"
      elif [[ -e "$entry" || -L "$entry" ]]; then
        echo "Keep foreign entry: $entry"
      fi
    else
      echo "Register entry: $entry -> $source"
      if (( ! DRY_RUN )); then
        mkdir -p "$dir"
        tmp="$(mktemp "$dir/.wiki-entry.XXXXXX")"
        # $ARGUMENTS remains literal until the host expands the command/prompt.
        {
          printf '%s\n' '---'
          sed -n '/^description: /p' "$source"
          printf '%s\n' '---' "$OWNER" '' "Vault root: $VAULT_ROOT" \
            "Read $VAULT_ROOT/AGENTS.md and the relevant guidance at $source." \
            'Resolve vault-relative paths against the root above.' '' \
            'User input: $ARGUMENTS'
        } > "$tmp"
        mv -f "$tmp" "$entry"
      fi
    fi
  done
done

echo "Claude Code: /wiki-<name>; Codex legacy prompt: /prompts:wiki-<name>"
echo "Natural language and the repo wiki skill do not require these global entries."
