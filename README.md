# OpenCode agent configuration — transport bundle

Copy the contents of this `opencode/` folder to `~/.config/opencode/` on the
target device (merge/overwrite), then verify the model providers resolve
before first use.

## Contents

- `AGENTS.md` — global rules for the main agent (618 words: coordination,
  task briefs, safety, verification/acceptance, result reporting).
- `backend-team.md` — shared workflow for the seven backend leaf specialists.
- `agents/` — 17 role profiles; each frontmatter pins `mode: subagent`,
  a model, and permission rules.

## Role map

- Main agent (your session, any model) coordinates everything.
- `backend-developer` (coordinator) — only role allowed to delegate further;
  it may launch exactly these seven specialists, at most three at once:
  `backend-api-router`, `backend-database`, `backend-service`,
  `backend-cache`, `backend-background-jobs`, `backend-testing`,
  `backend-error-handling`.
- Main-level roles: `researcher`, `architect`, `frontend-developer`,
  `tester`, `reviewer` (read-only), `security-specialist` (read-only),
  `documentation-writer`, `docker-specialist`.
- `github-assistant` — only on explicit user request; commit/push/PR/deploy
  are separate authorizations.

## Models

- All 17 profiles: `opencode-go/glm-5.3-flash#max` (provider `opencode-go`,
  OpenCode Go).
- Provider availability depends on the target device's OpenCode installation
  and authentication, not on this repo; no provider entry for it is required
  in `<provider configuration>`. A Tailscale LLM fallback (`tailscale-llm`) was used in
  earlier revisions and may or may not exist on a target device.
- Not included here: `<provider configuration>` provider credentials/endpoints.
  Copy it separately if your target device needs it; do not commit secrets.

## Install on another device

```sh
mkdir -p ~/.config/opencode/agents
cp -r opencode/AGENTS.md opencode/backend-team.md ~/.config/opencode/
cp opencode/agents/*.md ~/.config/opencode/agents/
```

Then verify: `opencode` agent listing shows the 17 agents, and a short
subagent launch resolves `opencode-go/glm-5.3-flash#max`.

## Notes

- Safety boundaries (tests-only, docs-only, read-only roles, destructive
  operations) are enforced by a mix of frontmatter permissions and
  instruction text; project-level configs can override global permissions,
  so treat this as a default baseline, not a hard security boundary.
- Runtime behavior (permission enforcement, nested delegation, variant
  resolution) was not yet exercised; verify after install.
