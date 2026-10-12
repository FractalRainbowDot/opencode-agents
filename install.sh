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
    if cmp -s "$f" "$(cat "$3" 2>/dev/null || echo '')" 2>/dev/null; then return; fi
    cp "$f" "$f.bak.$(date +%Y%m%d%H%M%S)"
    echo "    backed up: $f"
  fi
}

mkdir -p "$DEST/agents"

echo "==> Installing global rules and team workflows to $DEST"
for f in AGENTS.md backend-team.md frontend-team.md; do
  backup "$DEST/$f" "" /dev/null
  if [ -f "$DEST/$f" ] && cmp -s "$DEST/$f" "$BUNDLE/$f"; then
    echo "    unchanged:  $f"
  else
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

echo "===> Provider configuration (models) — NOT installed automatically"
if [ ! -f "$DEST/opencode.json" ]; then
  cat > "$DEST/opencode.json" <<'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "$comment": "Fill baseURL with YOUR OpenAI-compatible endpoint and set the API key via env: TAILSCALE_LLM_API_KEY (or another env you name here). The rules bundle author's endpoint is on a private network and will not work for you.",
  "model": "SPARK03/Qwen3.8-Flash-Next-devs02",
  "providers": {
    "SPARK03": {
      "name": "SPARK03",
      "env": ["TAILSCALE_LLM_API_KEY"],
      "package": "@opencode/ai/providers/openai-compatible",
      "settings": {
        "baseURL": "http://YOUR-ENDPOINT:PORT/v1"
      },
      "models": {
        "Qwen3.8-Flash-Next-devs02": {
          "name": "Qwen3.8-Flash-Next-devs02",
          "capabilities": { "tools": true, "input": ["text"], "output": ["text"] },
          "limit": { "context": 131072, "input": 131072, "output": 131072 }
        }
      }
    }
  }
}
EOF
  echo "    created template: $DEST/opencode.json — set baseURL and export TAILSCALE_LLM_API_KEY"
  echo "    IMPORTANT:**************************** never commit this file with real values."
elif ! grep -q 'SPARK03' "$DEST/opencode.json"; then
  echo "    existing opencode.json kept. Add a 'SPARK03' provider (OpenAI-compatible; text-only Qwen capabilities) or the roles will report the model as unavailable."
else
  echo "    existing opencode.json kept (SPARK03 already defined)."
fi
if [ -z "${TAILSCALE_LLM_API_KEY:-}" ]; then
  echo "    reminder: export TAILSCALE_LLM_API_KEY (or your chosen env) before running sessions."
fi

installed_agents="$(ls "$DEST/agents"/*.md 2>/dev/null | wc -l)"
echo "===> Done. Agents installed: $installed_agents/30 in $DEST/agents"
if [ "$installed_agents" -ne 30 ]; then
  echo "WARNING: expected 30 agent profiles; check the bundle source." >&2
fi
echo "Start or restart OpenCode and verify the agent list shows the new roles."
