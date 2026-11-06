# Claude Code — WI-Cart Implementation Prompt

You are working in the existing WI-Cart repository. Your task is to audit, stabilize and incrementally evolve it into a polished offline-first personal and household shopping manager.

## Mandatory first step: Phase 0 audit

Do not start coding immediately.

1. Read `CLAUDE.md`, `README.md` and all relevant files in `docs/`.
2. Inspect git status, branches and recent changes.
3. Inspect Flutter features, Drift schema, repositories, outbox, sync engine, tests and platform configuration.
4. Inspect Laravel routes, controllers, services, models, policies, migrations, validation and tests.
5. Inspect the Express development API and launcher.
6. Identify implemented, partial, broken and missing capabilities. Verify with code/tests, not README claims.
7. Report architecture risks, especially user isolation, offline sync, account switching, backups and current sharing semantics.
8. Do not overwrite user work or change behavior during the audit.

Deliver an audit summary with:
- current architecture and feature inventory;
- exact findings with file paths;
- test/build status and commands actually run;
- security and data-integrity risks;
- prioritized implementation plan with small milestones.

## Product outcome

Build toward:
- private personal shopping lists and reusable product catalog;
- store management, quantities, prices and purchase history;
- budgets and estimated-vs-actual expense tracking;
- reliable offline operation and multi-device sync;
- household workspaces with invitations, owner/admin/member roles and collaborative lists;
- secure account and household data isolation;
- useful reporting, exports and product suggestions.

## Critical distinction: sharing

The existing API share endpoints currently copy a list or store and related records into another account. Do not describe this as live shared collaboration and do not silently change its semantics.

For true household collaboration, first design and document:
- workspace and membership schema;
- invitation lifecycle and role permissions;
- ownership of lists, products, stores and history;
- authorization policies for every endpoint;
- sync scope for personal and household resources;
- offline concurrent edits and conflict policy;
- membership revocation and cache/outbox cleanup.

Implement the design in backward-compatible, reviewed increments. Preserve existing personal lists and copy-sharing behavior unless a migration path is explicitly designed and tested.

## Implementation constraints

- Keep Flutter/Dart, Drift/SQLite, Laravel 12/PHP 8.3+, Sanctum and the existing Express dev API unless an audited reason supports a change.
- Local SQLite remains the UI source of truth.
- All synchronized local mutations must use repositories and the outbox.
- Preserve UUIDs, tombstones, pull cursor correctness and documented conflict behavior.
- Enforce authorization on the backend; never trust a client user ID.
- Avoid data loss when logging out, switching accounts, restoring backups or losing household access.
- Add migrations, validation, tests and docs for every backend contract change.
- Keep monetary calculations decimal-safe and exchange rates timestamped.
- Do not add credentials, private data or production environment files.
- Do not add dependencies without explaining necessity and compatibility.
- Do not perform destructive production operations.

## Delivery sequence

### Milestone 1 — Audit and stabilization
Fix only verified defects and documentation drift. Add CI and missing tests for critical existing workflows.

### Milestone 2 — Personal expense management
Complete budgets, spending summaries, purchase history filters, recurring lists and exports based on actual requirements and existing schema.

### Milestone 3 — Household collaboration design
Produce ADR, ERD, permission matrix, sync contract and migration plan before implementing shared workspaces.

### Milestone 4 — Household collaboration implementation
Implement invitations, membership, roles, shared list operations, sync scoping, revocation and multi-account tests.

### Milestone 5 — Polish and release readiness
Accessibility, responsive layouts, performance, security review, backup/restore and deployment verification.

## Required completion report

At the end of each milestone, report:
1. What changed and why.
2. Files added/modified.
3. Database migrations and rollback notes.
4. Tests, analyzers and builds actually executed with results.
5. Known limitations and unverified behavior.
6. Recommended next milestone.

Do not claim a milestone is complete if its acceptance criteria or tests have not been met.
