# wi-cart — Offline-First shopping list

Monorepo:

| Path | Stack |
|------|--------|
| `apps/api` | Laravel 11 + Sanctum + MySQL (UUID sync API) |
| `apps/mobile` | Flutter + Drift/SQLite + outbox LWW |
| `docs/sync-contract.md` | Push/pull contract |

## Quick start (todo en uno)

```bash
./dev          # API Node :8000 + Flutter Linux
./dev stop     # apagar
./dev web      # API + web :3000
./dev api      # solo API
```

Demo: `demo@wicart.local` / `password123`

> `./dev` usa `apps/dev-api` (Node). Laravel productivo: `apps/api` (ver abajo).

### API Laravel (producción / VPS)

```bash
cd apps/api
composer install
cp .env.example .env && php artisan key:generate
# configure MySQL in .env
php artisan migrate --seed
php artisan storage:link
php artisan serve --host=0.0.0.0 --port=8000
```

### Mobile (manual)

```bash
cd apps/mobile
flutter pub get
dart run build_runner build
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## Offline sync

1. Mutate SQLite → `sync_outbox`
2. Online: `POST /api/sync/push` then `GET /api/sync/pull`
3. Conflict: Last-Write-Wins on `client_updated_at`
4. Soft deletes via `deleted_at`
5. Product images upload deferred (`image_pending`)
6. Domain: categories (icon/color), units (`un/kg/g/lts/ml/paquete`), store_location, tickets

Docs: [docs/architecture.md](docs/architecture.md) · [docs/sync-contract.md](docs/sync-contract.md)

No HTTP cache of API JSON. Source of truth local = SQLite.

## VPS

See `apps/api/README.md`.
