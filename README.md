# WI-Cart

**An offline-first shopping list application built with Flutter and Laravel.**

Manage shopping lists, products, quantities and purchase history with a local-first architecture. Work without an internet connection and synchronize your data when connectivity is restored.

<!-- Add a real application screenshot or project banner here -->

## Overview

WI-Cart is a shopping list application designed around an offline-first architecture. Its mobile client uses SQLite as the primary source of truth, while a Laravel API provides multi-device synchronization and centralized data persistence.

The project is organized as a monorepo containing the mobile application, backend API and development tooling.

## Key Features

- **Offline-first:** Manage shopping lists without an internet connection.
- **Local database:** Persistent local storage powered by SQLite and Drift.
- **Data synchronization:** Push and pull synchronization with the backend.
- **Conflict resolution:** Last-Write-Wins (LWW) based on client timestamps.
- **Product management:** Organize products, categories, units and prices.
- **Shopping lists:** Track planned quantities and items added to the cart.
- **Purchase history:** Keep track of completed purchases and totals.
- **Multi-device architecture:** Synchronize data through a centralized API.
- **Soft deletes:** Preserve deletion information during synchronization.

## Technology Stack

| Component | Technology |
|---|---|
| Mobile application | Flutter / Dart |
| Local database | SQLite / Drift |
| Backend API | Laravel 11 |
| Authentication | Laravel Sanctum |
| Production database | MySQL |
| Development API | Node.js |
| Architecture | Offline-first / Monorepo |

## Repository Structure

```text
wi-cart/
├── apps/
│   ├── api/             # Laravel production API
│   ├── dev-api/         # Local development API
│   └── mobile/          # Flutter application
│
├── docs/
│   ├── architecture.md
│   ├── sync-contract.md
│   └── sync-engine.md
│
├── dev                 # Development launcher
├── .gitignore
└── README.md
```

## Getting Started

### Development Environment

The project includes a development launcher to simplify local execution.

```bash
# Start the API and Flutter Linux application
./dev

# Start API and web application
./dev web

# Start only the development API
./dev api

# Stop development services
./dev stop
```

The development launcher uses the Node.js API located in `apps/dev-api`.

### Production Backend (Laravel)

Navigate to the Laravel API directory:

```bash
cd apps/api
```

Install dependencies:

```bash
composer install
```

Configure the environment:

```bash
cp .env.example .env
php artisan key:generate
```

Configure your MySQL connection in `.env`.

Run database migrations and seeders:

```bash
php artisan migrate --seed
```

Create the storage symbolic link:

```bash
php artisan storage:link
```

Start the development server:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

### Mobile Application

Navigate to the Flutter application:

```bash
cd apps/mobile
```

Install dependencies:

```bash
flutter pub get
```

Generate the required code:

```bash
dart run build_runner build
```

Run the application:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Adjust the API URL according to your execution environment.

## Offline Synchronization

WI-Cart follows a local-first synchronization strategy.

SQLite remains the source of truth for the user interface. Changes are stored locally and queued for synchronization when connectivity becomes available.

### Synchronization Workflow

1. User modifies local data.
2. Changes are stored in SQLite.
3. Mutations are added to the synchronization outbox.
4. The synchronization engine detects connectivity.
5. Pending mutations are pushed to the API.
6. Remote changes are pulled and merged locally.
7. Conflicts are resolved using Last-Write-Wins.

### Synchronization Rules

- UUIDs are generated on the client.
- Mutations are tracked through a local outbox.
- Conflicts are resolved using `client_updated_at`.
- Deletions are represented through soft deletes.
- Local data is cleared when switching accounts or logging out.
- Product image uploads can be deferred until synchronization.

For implementation details, see [Sync Contract](docs/sync-contract.md).

## Architecture

The application is divided into three main components:

- **Mobile Client:** Flutter application responsible for the user interface and local data.
- **Production API:** Laravel backend responsible for authentication and remote persistence.
- **Development API:** Lightweight Node.js API used by the local development workflow.

More information:

- [System Architecture](docs/architecture.md)
- [Synchronization Contract](docs/sync-contract.md)
- [Synchronization Engine](docs/sync-engine.md)

## Security

- Never commit production credentials or environment files.
- Keep API secrets outside version control.
- Use HTTPS in production.
- Use isolated credentials for development and production environments.

## Project Structure

WI-Cart is maintained as a monorepo to keep the mobile application, backend and technical documentation together.

## License

License information will be published once the project's licensing terms are defined.

---

**WI-Cart**  
Offline-first shopping, designed for reliability and simplicity.
