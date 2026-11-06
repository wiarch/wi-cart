# Roadmap

This roadmap describes product direction, not a claim that every item is implemented. Verify existing code and tests before changing status.

## Phase 1 — Stabilize foundations
- [ ] Reconcile documentation with actual Laravel 12 / PHP 8.3 requirements.
- [ ] Audit current Flutter, Laravel and Express workflows.
- [ ] Add/strengthen automated tests for list CRUD, purchase completion and sync.
- [ ] Verify backup/restore and account-switch isolation.
- [ ] Document environment variables and local development prerequisites.
- [ ] Add CI for Flutter analysis/tests and Laravel tests.

## Phase 2 — Personal shopping and expense control
- [ ] Complete budget creation, editing, periods and category/store limits.
- [ ] Provide estimated-vs-actual spending summaries.
- [ ] Improve purchase history filters and reporting.
- [ ] Add recurring lists and reusable shopping templates.
- [ ] Improve product suggestions from purchase history.
- [ ] Add export formats and transparent currency-rate metadata.

## Phase 3 — Household collaboration
- [ ] Design household/workspace data model and migration strategy.
- [ ] Define invitation, acceptance, revocation and member removal flows.
- [ ] Define owner/admin/member permission matrix.
- [ ] Implement shared list ownership and server-side authorization.
- [ ] Extend sync contract for household scope and membership changes.
- [ ] Resolve concurrent edits and offline mutation conflicts safely.
- [ ] Prevent data access after membership revocation, including cached data.
- [ ] Add collaboration tests across multiple accounts/devices.

## Phase 4 — Experience and intelligence
- [ ] Improve onboarding and household setup.
- [ ] Add contextual product and quantity suggestions.
- [ ] Add price comparison and store insights where reliable data exists.
- [ ] Improve accessibility, localization and responsive layouts.
- [ ] Evaluate push notifications and realtime updates after sync guarantees are stable.

## Release readiness
- [ ] Security and privacy review.
- [ ] Backup/restore verification.
- [ ] Migration rollback and upgrade testing.
- [ ] Performance testing on large catalogs and histories.
- [ ] Documented release and deployment procedure.
