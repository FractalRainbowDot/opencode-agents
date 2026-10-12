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
    leaf specialists, at most three at once: `backend-api-router`,
    `backend-database`, `backend-service`, `backend-cache`,
    `backend-background-jobs`, `backend-testing`,
    `backend-error-handling`, `backend-observability`,
    `backend-performance`, `backend-integration`.
  - `frontend-developer` (coordinator) — may launch exactly these ten
    leaf specialists, at most three at once: `frontend-ui-components`,
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
- Resource cap: at most 5 concurrent SPARK03 model sessions overall,
  including the main session and coordinators' sessions.

## Models

- All 27 profiles: `SPARK03/Qwen3.8-Flash-Next-devs02#high`.
- Main agent/orchestrator default: `SPARK03/Qwen3.8-Flash-Next-devs02`
  (root `model` key; the session can still switch variants/models).
- Provider `SPARK03` (OpenAI-compatible, Tailscale endpoint
  `<provider-endpoint>`) is defined in the bundled
  `opencode/<provider configuration>`; the API key itself comes from the
  `TAILSCALE_LLM_API_KEY` environment variable and must be set on the
  target device. Never commit the actual key.

## Install on another device

```sh
mkdir -p ~/.config/opencode/agents
cp -r opencode/AGENTS.md opencode/backend-team.md opencode/<provider configuration> ~/.config/opencode/
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
