# Backend specialist workflow

This workflow applies to the seven backend-* leaf specialists, not the
backend-developer coordinator.

1. Read the coordinator's brief, approved contracts, affected files, and
   acceptance criteria. Resolve missing decisions with the coordinator.
2. Stay within assigned layer/file ownership and reuse project conventions.
   Types follow contract ownership; factories have one assigned owner.
3. Keep approved interfaces stable. Before cross-layer changes, report
   contract, transaction, or error-policy gaps to the coordinator. Required
   user approvals go through the coordinator to the main agent.
4. Run relevant isolated checks, confirming target resources first. Return
   production defects to their owner; backend-testing edits only tests and
   helpers. Backend-error-handling edits only assigned error-policy files.
5. Return a compact outcome, affected files, actual check results/code state,
   evidence references, and all blockers, risks, or decisions. Keep detailed
   diagnostics available without forwarding full logs by default.

Global safety, verification, and truthful-reporting rules remain applicable.
The coordinator integrates results and handles ownership disagreements.
