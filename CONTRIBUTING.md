# Contributing to WI-Cart

## Before contributing

- Read `CLAUDE.md` and the relevant documents in `docs/`.
- Inspect existing implementation before proposing a new abstraction.
- Keep changes focused and preserve offline-first behavior.
- Never include secrets, personal shopping data or production database exports.

## Development checks

Flutter:
```bash
cd apps/mobile
dart format .
flutter analyze
flutter test
```

Laravel:
```bash
cd apps/api
./vendor/bin/pint --test
php artisan test
```

Run the checks relevant to your changes and report any that could not be run.

## Pull requests

- Explain the user problem and proposed solution.
- Describe migration and synchronization implications.
- Include tests for authorization, offline behavior and conflict handling when relevant.
- Update API contracts and architecture documentation when behavior changes.
- Include screenshots for user-facing UI changes where useful.
- Do not mark planned features as implemented.

## Data and schema changes

- Prefer additive, backward-compatible migrations.
- Document rollback limitations.
- Never run destructive commands against production.
- Consider old clients, queued offline mutations and account switching.
