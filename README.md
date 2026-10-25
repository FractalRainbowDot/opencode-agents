# OpenCode: context-bounded delegation — v0.3.0

Model-independent project-tree rules using OpenCode V2's built-in `general`
and read-only `explore`. Temporary specialties belong in assignment briefs,
not a catalog of permanent backend/frontend agents.

## Bundle and scope

- `opencode/AGENTS.md`: planning, context handoffs, provider-load coordination,
  ownership, acceptance checks, partitioned independent review, and safety.
- `opencode/agents/general.md`: overrides the built-in executor to allow nested
  calls to `general` and `explore`; shell commands require approval.
- `explore` keeps its built-in read-only permissions. No custom profile needed.

For this machine the live rules are `~/PycharmProjects/AGENTS.md` and the executor
override is `~/PycharmProjects/.opencode/agents/general.md`. The bundle's
`opencode/` directory is a transport folder, not the destination layout. Keep
these files project-scoped; do not copy them into the global config directory.
On another machine place the rules in the chosen parent project directory and
the executor override in its `.opencode/agents/` directory. Remove legacy
specialist profiles and team workflows only after checking for local changes.

## Runtime setup

Use the session's selected model. No profile pins a provider, model, or reasoning
level. Children inherit their parent's model unless explicitly requested otherwise.
Provider credentials, endpoints, and `opencode.json(c)` are never bundled here.

In the target OpenCode configuration, set `experimental.subagent_depth` to `3`
to permit three child levels below the main agent. Removing a root `model`
selection removes the forced default, but does not erase selections already
stored on sessions or disable OpenCode's own fallback selection. Select the
desired model in the UI when starting work. Existing provider/model settings,
including model-specific reasoning effort, remain independent of these rules.

The provider-load ceiling is a soft 10 simultaneous requests per provider,
including the main agent and all descendants. Nested branches share allocations;
it is not a client/proxy semaphore and cannot govern unrelated sessions. A worker
count is only a conservative proxy when active-request telemetry is unavailable.

Read `opencode/AGENTS.md` for the workflow. Graphify is an optional navigation aid,
not a prerequisite, installation step, or replacement for source and tests.
No quick-install script is provided.

## Verify on the target

From a child project, run `opencode debug agents` and `opencode debug config`.
Confirm the legacy specialist IDs are gone, `general` has no pinned model and
may call `general`/`explore`, `explore` remains read-only, and depth is three.
Inspect config output locally: it can contain private provider information.
Start a fresh session to test model inheritance, bounded nested delegation, and
review isolation. Configuration inspection alone is not an end-to-end test.
