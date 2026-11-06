# System Architecture

## Repository layout

- `apps/mobile`: Flutter client for mobile, desktop and web targets.
- `apps/api`: Laravel 12 API (PHP 8.3+) using Sanctum and MySQL in production.
- `apps/dev-api`: lightweight Express API used by the development launcher.
- `docs`: product, deployment and synchronization contracts.

## Client architecture

The Flutter application uses Drift over SQLite for local persistence. UI reads local state; repositories write locally and enqueue mutations in the outbox. The synchronization engine coordinates push/pull with the API and connectivity detection.

Relevant modules include:
- `lib/data/`: database, tables, repositories and outbox.
- `lib/sync/`: synchronization engine.
- `lib/services/`: API client, exchange rates, backups and import parsing.
- `lib/ui/`: authentication, lists, products, stores, history, budgets and settings.

Do not bypass repository/outbox conventions for synchronized entities.

## Backend architecture

Laravel exposes authenticated API routes using Sanctum. Domain entities are scoped by `user_id`; synchronization applies mutations and returns deltas. Services should own business rules and controllers should remain thin.

Current backend dependencies include Laravel 12, Sanctum 4 and PHP 8.3+. Production deployment documentation targets MySQL 8+ and Nginx/PHP-FPM.

## Development API

The Express service in `apps/dev-api` is a development helper. It is not a replacement for the production Laravel API and must not be treated as production-grade authentication or persistence without a separate security review.

## Data ownership and sharing

Personal records are account-scoped. Existing share endpoints copy lists/stores and related records to a recipient account using new identifiers. This is a one-time copy, not shared ownership.

The target household model requires explicit workspace membership and authorization. Before implementation, design:
- household/workspace identity and ownership;
- membership and invitation lifecycle;
- role/permission matrix;
- ownership of lists and related records;
- sync scoping for both personal and household data;
- conflict, offline and revocation behavior.

Never expose a record solely because its identifier is known.

## Synchronization model

- Local SQLite is the client source of truth.
- Mutations are queued in an outbox.
- API applies mutations and returns remote changes.
- Current conflict policy is Last-Write-Wins using `client_updated_at`.
- Soft deletes use tombstones.
- User switch/logout clears account-scoped local storage.

See [sync-contract.md](sync-contract.md) and [sync-engine.md](sync-engine.md).

## Security boundaries

- Sanctum bearer token required for protected routes.
- Validate ownership on the server for every operation.
- Validate and limit uploaded images/import files.
- Never log credentials, bearer tokens or sensitive payloads.
- Use HTTPS and production-safe Laravel configuration.
- Ensure local backups and caches are treated as sensitive user data.
