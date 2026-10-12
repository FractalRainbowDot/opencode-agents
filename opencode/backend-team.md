# Backend specialist workflow

This workflow applies to the ten backend-* leaf specialists, not the
backend-developer coordinator. The team mirrors a proven industry shape:
backend-service is the stream-aligned vertical implementer; database,
cache, background-jobs, integration, and api-router act as platform/shared-
surface desks; testing, error-handling, observability, and performance are
enabling desks. Each specialist is positioned as an employee with a narrow
job description: treat their profile as the standing contract, the
coordinator's approved brief as the work order, and their layer boundary
as the desk.

1. Read the coordinator's brief, approved contracts, affected files, and
   acceptance criteria. Resolve missing decisions with the coordinator.
2. Stay within assigned layer/file ownership and reuse project conventions.
   Types follow contract ownership; factories have one assigned owner.
   Stay in your job description: recommend out-of-scope fixes to the owning
   specialist instead of implementing across desks.
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
