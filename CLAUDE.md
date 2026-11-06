# WI-Cart — Claude Code Guide

## Mission

Maintain and evolve WI-Cart, an offline-first shopping and household expense manager. Read this file and `docs/PRODUCT.md`, `docs/ARCHITECTURE.md`, `docs/ROADMAP.md` and the synchronization documents before implementation.

## Non-negotiable rules

1. **Audit first.** Inspect the relevant Flutter, Laravel and Express code, tests, migrations and git status before proposing edits.
2. **Preserve working behavior.** Do not replace the application, rewrite modules wholesale or remove existing functionality without explicit approval.
3. **Verify before claiming.** A README, roadmap or prompt is not proof that a feature exists. Mark planned work as planned.
4. **Protect user data.** Enforce ownership and authorization on the server. Never trust client-supplied user IDs.
5. **Respect offline-first.** Synchronized UI writes go through local repositories and the outbox. Do not introduce API-first UI state.
6. **Protect sync correctness.** Understand idempotency, tombstones, cursors and Last-Write-Wins behavior before changing sync code.
7. **Avoid cross-account leakage.** Test logout, account switching, cache clearing, pending mutations and backups.
8. **No secrets.** Never commit real `.env` files, tokens, credentials or private data.
9. **Small increments.** Prefer focused changes with migrations, tests and documentation.
10. **No speculative dependencies.** Explain why a new package is needed and check platform compatibility first.

## Technology baseline

- Flutter / Dart (pubspec environment: Dart `^3.8.0`).
- Drift / SQLite local persistence.
- Laravel 12 / PHP 8.3+.
- Laravel Sanctum authentication.
- MySQL production database.
- Node.js / Express development API.

Use the versions in the actual manifests as source of truth.

## Household collaboration

The product target includes personal private data and shared household workspaces. Current `ListShareService` copies lists/stores to another account; this is not live collaboration.

Before implementing collaborative lists:
- design workspace, membership, invitation and role entities;
- document authorization rules and resource ownership;
- define offline edits, conflict resolution and revocation behavior;
- scope sync payloads and pull queries to authorized personal/household data;
- ensure local cache/outbox cannot expose data after account or membership changes;
- add multi-user integration tests.

Do not simply remove `user_id` checks or make lists globally visible.

## Workflow

1. Inspect repository state and relevant files.
2. Summarize existing behavior and identify risks.
3. Propose the smallest coherent implementation.
4. Implement with backward-compatible migrations where possible.
5. Add/update tests.
6. Run relevant formatters, analyzers and tests.
7. Update docs and report exact commands/results.
8. List anything not tested or requiring manual verification.

## Useful commands

Flutter:
```bash
cd apps/mobile
flutter pub get
dart run build_runner build
dart format .
flutter analyze
flutter test
```

Laravel:
```bash
cd apps/api
composer install
php artisan test
./vendor/bin/pint --test
php artisan migrate:status
```

Development API:
```bash
cd apps/dev-api
npm install
npm start
```

Do not run destructive database commands against production. Confirm environment and backup status before any data-changing operation.
