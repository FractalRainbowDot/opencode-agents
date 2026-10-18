# OpenCode agent configuration — transport bundle

Copy the contents of this `opencode/` folder to `~/.config/opencode/` on the
target device (merge/overwrite), then verify the model providers resolve
before first use.

## Contents

- `AGENTS.md` — global rules for the main agent (≈660 words: coordination,
  task briefs, safety, verification/acceptance, result reporting).
- `agents/` — 30 role profiles; each frontmatter pins `mode: subagent`,
  a model, and permission rules.
- `backend-team.md` — shared workflow for the seven backend leaf specialists.
- `frontend-team.md` — shared workflow for the ten frontend leaf specialists.

## Role map

- Main agent (your session, SPARK03 Qwen default) coordinates everything.
- Two nested teams; max two levels below the main agent:
  - `backend-developer` (coordinator) — may launch exactly these ten
    leaf specialists; dispatch freely within the global cap: `backend-api-router`,
    `backend-database`, `backend-service`, `backend-cache`,
    `backend-background-jobs`, `backend-testing`,
    `backend-error-handling`, `backend-observability`,
    `backend-performance`, `backend-integration`.
  - `frontend-developer` (coordinator) — may launch exactly these ten
    leaf specialists; dispatch freely within the global cap: `frontend-ui-components`,
    `frontend-styling`, `frontend-state`, `frontend-routing`,
    `frontend-forms`, `frontend-accessibility`, `frontend-testing`,
    `frontend-performance`, `frontend-i18n`, `frontend-animation`.
  - Shared workflow files: `backend-team.md` (backend leaves),
    `frontend-team.md` (frontend leaves).
- Main-level roles: `researcher`, `architect`, `tester`,
  `reviewer` (read-only), `security-specialist` (read-only),
  `documentation-writer`, `docker-specialist`.
- `github-assistant` — only on explicit user request; commit/push/PR/deploy
  are separate authorizations.
- Resource cap: at most 5 concurrent SPARK03 subagent sessions overall
  (coordinators + specialists; the main session does not count).

## Model runtime notes

- The SPARK03 Qwen endpoint currently rejects image input (LiteLLM vision
  worker panic). Declare text-only capabilities in your provider block:

  ```json
  "capabilities": {
    "tools": true,
    "input": ["text"],
    "output": ["text"]
  }
  ```

  and never attach screenshots to sessions on this model; use a
  vision-capable session for images or transcribe the content.
- One model response is capped at ~30K output tokens on the author's
  endpoint. Declare your endpoint's REAL output limit in
  `limit.output` (the author's endpoint uses `30720`, not the model's
  nominal 131072); over-declaring makes agents attempt oversized
  single responses that fail to generate.

## Models

- 29 profiles: `SPARK03/Qwen3.8-Flash-Next-devs02#low` (coordinators and
  leaves alike; variants can be raised per-session or per-profile later).
- `reviewer` alone: `openai/gpt-6-luna` (OpenAI) — independent review
  deliberately uses a second model family.
- Main agent/orchestrator default: `SPARK03/Qwen3.8-Flash-Next-devs02`
  (root `model` key; the session can still switch variants/models).
- Provider `SPARK03` is NOT stored in this repository: on each target
  device define it in `~/.config/opencode/` yourself (OpenAI-compatible,
  your own endpoint); the API key comes from the
  `TAILSCALE_LLM_API_KEY` environment variable. Never commit provider
  configuration or the actual key.

## Install on any machine (one line)

```sh
curl -fsSL https://raw.githubusercontent.com/FractalRainbowDot/opencode-agents/main/install.sh | bash
```

What it does:

- Installs `AGENTS.md`, `backend-team.md`, `frontend-team.md` and all
  **30 agent profiles** into `~/.config/opencode/` (respects
  `OPENCODE_HOME` override).
- **Backs up** any existing file it replaces (`.bak.<timestamp>`) — your
  own rules are preserved, never silently overwritten.
- **Does not touch model/provider configuration at all**: an existing
  `opencode.json` is left untouched and none is created; point your own
  OpenCode model setup at whichever endpoint you have.
- Prints install/verification results; target restart or relaunch of
  OpenCode applies the new agents.

Works on Linux/macOS (bash + curl). No sudo; everything stays in `$HOME`.
The bundle author's model endpoint is on a private network — point the
template at your own LLM endpoint.

## Manual install on another device

```sh
mkdir -p ~/.config/opencode/agents
cp -r opencode/AGENTS.md opencode/backend-team.md ~/.config/opencode/
cp opencode/agents/*.md ~/.config/opencode/agents/
```

Then verify: `opencode` agent listing shows the 27 agents, and a short
subagent launch resolves `SPARK03/Qwen3.8-Flash-Next-devs02#high`.

## Notes

- Safety boundaries (tests-only, docs-only, read-only roles, destructive
  operations) are enforced by a mix of frontmatter permissions and
  instruction text; project-level configs can override global permissions,
  so treat this as a default baseline, not a hard security boundary.
- Runtime behavior (permission enforcement, nested delegation, variant
  resolution) was not yet exercised; verify after install.
