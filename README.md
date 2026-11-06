# WI-Cart

**An offline-first shopping and household expense management application built with Flutter and Laravel.**

WI-Cart helps individuals and households plan purchases, organize products, manage shopping lists, track spending and review purchase history. Its local-first architecture keeps essential workflows available offline and synchronizes data with the backend when connectivity returns.

<p align="center">
  <strong>Plan smarter. Shop with control. Stay in sync.</strong>
</p>

## Overview

WI-Cart is a cross-platform shopping manager organized as a monorepo. The Flutter client targets Android, iOS, Linux, macOS, Windows and web, while a Laravel API provides authentication and centralized synchronization.

The local SQLite database is the source of truth for the client experience. Mutations are queued locally and synchronized with the API when a connection is available.

The product direction is to support both private personal shopping data and shared household shopping spaces. The current sharing endpoints copy lists or stores to another account; collaborative shared lists with member roles and coordinated updates are a planned evolution, not a feature to assume is already complete.

## Product capabilities

### Available in the current codebase

- **Offline-first shopping lists:** Create and manage lists without an active connection.
- **Product catalog:** Maintain products, categories, units, prices and product images.
- **Shopping workflow:** Track planned quantities, items added to the cart and purchased quantities.
- **Purchase history:** Preserve completed purchases, line items and totals.
- **Local persistence:** SQLite storage managed through Drift.
- **Bidirectional synchronization:** Push local mutations and pull remote changes through the Laravel API.
- **Conflict handling:** Last-Write-Wins based on client timestamps.
- **Multi-account foundations:** Sanctum authentication, Google sign-in integration and account-scoped local data.
- **Store management:** Associate shopping lists with stores and locations.
- **Currency display:** USD prices with cached BCV conversions for Bs and optional EUR display.
- **Data portability:** Local backup and list import capabilities.
- **Cross-platform Flutter project:** Android, iOS, Linux, macOS, Windows and web project targets.

### Product direction

- Private personal workspaces with strict per-account data isolation.
- Shared household spaces and collaborative shopping lists.
- Invitations, member roles and permissions for shared lists.
- Safe synchronization of concurrent changes between household members.
- Budgets, spending summaries and comparisons across purchase history.
- Smarter product suggestions based on previous purchases and list context.
- Better recurring-list and purchase-planning workflows.
- More comprehensive analytics and export options.

Planned capabilities must be implemented and tested before being described as released functionality.

## Technology stack

| Area | Technology |
|---|---|
| Mobile, desktop and web client | Flutter / Dart |
| Local persistence | SQLite / Drift |
| Backend API | Laravel 12 / PHP 8.3+ |
| API authentication | Laravel Sanctum |
| Production database | MySQL |
| Development API | Node.js / Express |
| HTTP client | Dio |
| Connectivity detection | connectivity_plus |
| Secure token storage | flutter_secure_storage |
| Local preferences | shared_preferences |
| Architecture | Offline-first / Monorepo |

## Repository structure

```text
wi-cart/
├── apps/
│   ├── api/                 # Laravel production API
│   ├── dev-api/             # Lightweight Node.js development API
│   └── mobile/              # Flutter application
├── docs/
│   ├── architecture.md
│   ├── deploy-vps.md
│   ├── sync-contract.md
│   ├── sync-engine.md
│   └── ...
├── .github/
├── CLAUDE.md
├── PROMPT.md
├── CONTRIBUTING.md
├── SECURITY.md
├── dev                       # Development launcher
└── README.md
```

## Getting started

### Requirements

- Flutter SDK compatible with Dart `^3.8.0`
- PHP 8.3 or newer
- Composer
- Node.js and npm
- MySQL 8+ for the production API
- Android Studio / platform toolchains as needed for the target platform

### Development launcher

The repository includes a launcher for the local development workflow:

```bash
# Start the development API and Flutter Linux application
./dev

# Start the API and Flutter web application
./dev web

# Start only the development API
./dev api

# Stop development services
./dev stop
```

The development launcher uses the Express API in `apps/dev-api`. Review the launcher and its environment assumptions before using it in a new environment.

### Laravel API

```bash
cd apps/api
composer install
cp .env.example .env
php artisan key:generate
```

Configure the database and application values in `.env`, then run:

```bash
php artisan migrate --seed
php artisan storage:link
php artisan serve
```

### Flutter client

```bash
cd apps/mobile
flutter pub get
dart run build_runner build
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Adjust `API_BASE_URL` for the selected platform and environment. The Android emulator commonly reaches the host machine through `10.0.2.2`; other targets may require a different address.

## Offline synchronization

SQLite remains the UI source of truth. The client records mutations in a local outbox and synchronizes them when connectivity is restored.

1. The user changes local data.
2. The client persists the change in SQLite.
3. The mutation is queued in the synchronization outbox.
4. The synchronization engine sends pending mutations to the API.
5. The API applies accepted changes and returns remote changes.
6. The client merges changes using the documented conflict policy.
7. Pending product image uploads are processed.

The current conflict policy is Last-Write-Wins using `client_updated_at`. This policy and its edge cases must be considered before introducing collaborative editing.

See [Sync Contract](docs/sync-contract.md) and [Sync Engine](docs/sync-engine.md).

## Documentation

- [Product scope and requirements](docs/PRODUCT.md)
- [System architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Architecture decisions](docs/DECISIONS.md)
- [Synchronization contract](docs/sync-contract.md)
- [Synchronization engine](docs/sync-engine.md)
- [VPS deployment](docs/deploy-vps.md)
- [Contributing](CONTRIBUTING.md)
- [Security policy](SECURITY.md)
- [Claude Code instructions](CLAUDE.md)
- [Implementation prompt](PROMPT.md)

## Security

- Never commit `.env` files, API keys, tokens or production credentials.
- Keep account data isolated on both the API and local client.
- Use HTTPS for production API traffic.
- Validate ownership and authorization on every account-scoped operation.
- Treat synchronization payloads and imported files as untrusted input.
- Report vulnerabilities privately; see [SECURITY.md](SECURITY.md).

## Project status

WI-Cart is under active development. The repository contains an existing Flutter client, Laravel API, development API, local database and synchronization implementation. Documentation describes both verified foundations and future product goals; it does not imply that planned capabilities are already implemented.

## License

License information will be published once the project's licensing terms are defined.

---

**WI-Cart** — Offline-first shopping management for individuals and households.
