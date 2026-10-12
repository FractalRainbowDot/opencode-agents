#!/usr/bin/env bash
# One-line installer for the OpenCode multi-agent rules bundle.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/FractalRainbowDot/opencode-agents/main/install.sh | bash
# Everything installs under $HOME. No sudo, no system changes.
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/FractalRainbowDot/opencode-agents/archive/refs/heads/main.tar.gz}"
DEST="${OPENCODE_HOME:-$HOME/.config/opencode}"
SRC="$(mktemp -d)"
trap 'rm -rf "$SRC"' EXIT

echo "==> Downloading the rules bundle"
curl -fsSL "$REPO_URL" | tar -xz -C "$SRC"
BUNDLE="$SRC/opencode-agents-main/opencode"
[ -d "$BUNDLE" ] || BUNDLE="$(find "$SRC" -maxdepth 2 -type d -name opencode | head -n 1)"
[ -n "$BUNDLE" ] || { echo "ERROR: bundle layout not found" >&2; exit 1; }

backup() {
  local f="$1"
  if [ -f "$f" ]; then
    cp "$f" "$f.bak.$(date +%Y%m%d%H%M%S)"
    echo "    backed up: $f"
  fi
}

mkdir -p "$DEST/agents"

echo "==> Installing global rules and team workflows to $DEST"
for f in AGENTS.md backend-team.md frontend-team.md; do
  if [ -f "$DEST/$f" ] && cmp -s "$DEST/$f" "$BUNDLE/$f"; then
    echo "    unchanged:  $f"
  else
    backup "$DEST/$f"
    install -m 0644 "$BUNDLE/$f" "$DEST/$f"
    echo "    installed:  $f"
  fi
done

echo "==> Installing 30 agent profiles to $DEST/agents"
count=0
for src in "$BUNDLE"/agents/*.md; do
  name="$(basename "$src")"
  tgt="$DEST/agents/$name"
  if [ -f "$tgt" ] && cmp -s "$tgt" "$src"; then
    echo "    unchanged:  agents/$name"
  else
    [ -f "$tgt" ] && cp "$tgt" "$tgt.bak.$(date +%Y%m%d%H%M%S)" && echo "    backed up:  agents/$name"
    install -m 0644 "$src" "$tgt"
    count=$((count + 1))
  fi
done

echo "===> Provider configuration (models) — intentionally NOT touched"
if [ -f "$DEST/opencode.json" ] || [ -f "$DEST/opencode.jsonc" ]; then
  echo "    your existing provider configuration is kept as is."
else
  echo "    no provider configuration found — the rules work with any OpenCode model setup;"
  echo "    configure your provider yourself in $DEST/opencode.json (OpenAI-compatible endpoint + API-key env)."
  echo "    The bundle author's endpoint is on a private network and will not work for third parties."
fi

installed_agents="$(ls "$DEST/agents"/*.md 2>/dev/null | wc -l)"
echo "===> Done. Agents installed: $installed_agents/30 in $DEST/agents"
if [ "$installed_agents" -ne 30 ]; then
  echo "WARNING: expected 30 agent profiles; check the bundle source." >&2
fi
echo "Start or restart OpenCode and verify the agent list shows the new roles."
