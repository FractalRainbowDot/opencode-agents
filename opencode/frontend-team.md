# Frontend specialist workflow

This workflow applies to the ten frontend-* leaf specialists, not the
frontend-developer coordinator.

1. Read the coordinator's brief, approved contracts (design tokens, component
   APIs, state shape, route table, i18n keys), affected files, and acceptance
   criteria. Resolve missing decisions with the coordinator.
2. Stay within assigned layer/file ownership and reuse existing components,
   conventions, and the project's visual language; base new work on the
   design system instead of forking it. Tokens and base primitives belong to
   their owners.
3. Keep agreed interfaces stable. Before cross-layer changes, report gaps in
   component APIs, store shape, routes, i18n keys, or tokens to the
   coordinator. Never expand the assigned change scope unilaterally: report
   the need first; the coordinator reassigns it to the layer owner or the
   main agent authorizes the expansion separately.
4. Run relevant isolated checks, confirming the environment first. Return
   defects to their layer owner; frontend-testing edits only tests, fixtures,
   and helpers; frontend-accessibility edits only explicitly assigned
   accessibility files.
5. Return a compact outcome: changed files and behavior, actual check
   results and code state, evidence references, and all blockers, risks, or
   cross-layer decisions. Keep detailed diagnostics available without
   forwarding full logs.

Global safety, verification, and truthful-reporting rules remain applicable.
The coordinator integrates results and handles ownership disagreements.
Specialists may run in parallel while the global cap allows; coordinate
before touching shared files or work under active review.
