#!/usr/bin/env bash
# Base use needs no install. Mutating actions are explicit options.
set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DAILY_REQUESTED=0
GLOBAL_COMMANDS=0
INSTALL_OBSIDIAN=0
OPEN_OBSIDIAN=0
UNLINK=0
DRY_RUN=0
WIKI_TZ=""

usage() {
  cat <<'USAGE'
Usage: bash scripts/setup.sh [options]
No options: validate the vault and show guidance; no files or apps are changed.
  --daily                  Create today's note if absent; append its creation log
  --timezone IANA          Date/time for --daily (otherwise system timezone)
  --global-commands        Register optional Claude commands / Codex legacy prompts
  --install-obsidian       On macOS, install missing Obsidian via Homebrew
  --open-obsidian          Try to open this vault in installed Obsidian
  --dry-run                Show selected effects without writing/installing/opening
  --unlink                 Remove only global entries owned by this vault
  --help                   Show this help
USAGE
}
while (( $# )); do
  case "$1" in
    --daily) DAILY_REQUESTED=1 ;;
    --global-commands) GLOBAL_COMMANDS=1 ;;
    --install-obsidian) INSTALL_OBSIDIAN=1 ;;
    --open-obsidian) OPEN_OBSIDIAN=1 ;;
    --unlink) UNLINK=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --timezone)
      (( $# >= 2 )) || { echo "--timezone requires an IANA timezone" >&2; exit 2; }
      WIKI_TZ="$2"; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ ! -f "$VAULT_ROOT/AGENTS.md" || ! -d "$VAULT_ROOT/_workflows" ]]; then
  echo "Not a vault: $VAULT_ROOT" >&2; exit 1
fi
if (( UNLINK && (DAILY_REQUESTED || GLOBAL_COMMANDS || INSTALL_OBSIDIAN || OPEN_OBSIDIAN) )); then
  echo "Use --unlink separately from creation, registration or app actions." >&2; exit 2
fi
if [[ -n "$WIKI_TZ" ]]; then
  if [[ ! "$WIKI_TZ" =~ ^[A-Za-z0-9_+-]+(/[A-Za-z0-9_+-]+)*$ ]] || [[ ! -f "/usr/share/zoneinfo/$WIKI_TZ" ]]; then
    echo "Unknown IANA timezone: $WIKI_TZ" >&2; exit 2
  fi
fi

sync_entries() {
  if (( DRY_RUN )); then
    bash "$VAULT_ROOT/scripts/sync-workflows.sh" "$@" --dry-run
  else
    bash "$VAULT_ROOT/scripts/sync-workflows.sh" "$@"
  fi
}
if (( UNLINK )); then
  sync_entries --unlink
  exit 0
fi

echo "Vault ready: $VAULT_ROOT"
echo "Start in natural language; see SETUP.md and AGENTS.md."
# Run the preflighted installer before other selected mutations.
if (( GLOBAL_COMMANDS )); then
  sync_entries
fi

if (( DAILY_REQUESTED )); then
  # Do not override the process timezone; scope it to each date command.
  wiki_date() {
    if [[ -n "$WIKI_TZ" ]]; then TZ="$WIKI_TZ" date "$@"; else date "$@"; fi
  }
  CLOCK="$(wiki_date +%Y-%m-%dT%H:%M:%S%z)"
  TODAY="${CLOCK:0:10}"
  NOW_TIME="${CLOCK:11:8}"
  OFFSET="${CLOCK:19}"
  NOW_ISO="${CLOCK:0:19}${OFFSET:0:3}:${OFFSET:3:2}"
  DAILY="$VAULT_ROOT/01-Daily/$TODAY.md"
  TMPL="$VAULT_ROOT/10-Templates/tmpl-daily.md"
  echo "Daily timezone: ${WIKI_TZ:-system} ($(wiki_date '+%Z %z'))"
  if [[ -e "$DAILY" || -L "$DAILY" ]]; then
    echo "Existing note preserved: $DAILY"
  else
    [[ -f "$TMPL" ]] || { echo "Missing daily template: $TMPL" >&2; exit 1; }
    echo "Create note and append creation log: $DAILY"
    if (( ! DRY_RUN )); then
      YESTERDAY="$(wiki_date -v-1d +%Y-%m-%d 2>/dev/null || wiki_date -d 'yesterday' +%Y-%m-%d)"
      mkdir -p "$VAULT_ROOT/01-Daily"
      command -v link >/dev/null 2>&1 || { echo "The link utility is required for safe daily publication." >&2; exit 1; }
      tmp="$(mktemp "$VAULT_ROOT/01-Daily/.daily.XXXXXX")"
      trap 'rm -f "$tmp"' EXIT
      trap 'exit 130' INT
      trap 'exit 143' TERM
      # Support both current ISO placeholder and previous daily templates.
      if ! sed -e "s|{{date:YYYY-MM-DD}}T{{time:HH:mm:ss}}+09:00|$NOW_ISO|g" \
          -e "s|{{datetime}}|$NOW_ISO|g" \
          -e "s|{{date:YYYY-MM-DD}}|$TODAY|g" \
          -e "s|{{date:YYYY-MM-DD ddd}}|$TODAY|g" \
          -e "s|{{date:YYYY-MM-DD (ddd)}}|$TODAY|g" \
          -e "s|{{time:HH:mm:ss}}|$NOW_TIME|g" \
          -e "s|{{date-1d:YYYY-MM-DD}}|$YESTERDAY|g" "$TMPL" > "$tmp"; then
        echo "Failed to render daily note: $DAILY" >&2
        exit 1
      fi
      # link publishes a complete file atomically and never replaces a target path.
      # Unlike ln, a directory target is not treated as a destination folder.
      if publish_error="$(link "$tmp" "$DAILY" 2>&1)"; then
        printf '\n## [%s] create | 01-Daily/%s.md | via scripts/setup.sh --daily\n' "$NOW_ISO" "$TODAY" >> "$VAULT_ROOT/log.md"
      elif [[ -e "$DAILY" || -L "$DAILY" ]]; then
        echo "Path appeared during setup; kept unchanged: $DAILY"
      else
        printf 'Failed to publish daily note: %s\n%s\n' "$DAILY" "$publish_error" >&2
        exit 1
      fi
      rm -f "$tmp"
      trap - EXIT INT TERM
    fi
  fi
fi

if (( INSTALL_OBSIDIAN || OPEN_OBSIDIAN )); then
  if (( DRY_RUN )); then
    (( INSTALL_OBSIDIAN )) && echo "Would check Obsidian; macOS + brew may install it (outside vault)."
    (( OPEN_OBSIDIAN )) && echo "Would try opening this vault in installed Obsidian."
  else
    case "$(uname -s)" in
      Darwin)
        if (( INSTALL_OBSIDIAN )) && [[ ! -d /Applications/Obsidian.app ]]; then
          if command -v brew >/dev/null 2>&1; then
            brew install --cask obsidian
          else
            echo "Homebrew unavailable. Install manually: https://obsidian.md/download"
          fi
        fi
        if (( OPEN_OBSIDIAN )); then
          if [[ -d /Applications/Obsidian.app ]]; then
            if [[ "${OBSIDIAN_OPEN_SKIP:-0}" == "1" ]]; then
              echo "Opening skipped by OBSIDIAN_OPEN_SKIP."
            else
              open -a Obsidian "$VAULT_ROOT"
            fi
          else
            echo "Obsidian not detected. Install or open manually: https://obsidian.md/download"
          fi
        fi ;;
      Linux)
        (( INSTALL_OBSIDIAN )) && echo "Install manually: https://obsidian.md/download"
        if (( OPEN_OBSIDIAN )); then
          if command -v obsidian >/dev/null 2>&1; then
            if [[ "${OBSIDIAN_OPEN_SKIP:-0}" != "1" ]]; then obsidian "$VAULT_ROOT" >/dev/null 2>&1 & fi
          else
            echo "No obsidian command. On WSL, open the vault from the Windows host."
          fi
        fi ;;
      *) echo "Install/open manually: https://obsidian.md/download" ;;
    esac
  fi
fi

echo "Selected actions complete. No automatic commit, push or recurring job was configured."
