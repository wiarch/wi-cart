# wi-cart API (Laravel + Sanctum)

## Setup

```bash
cd apps/api
cp .env.example .env
composer install
php artisan key:generate
# edit .env MySQL credentials
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan serve --host=0.0.0.0 --port=8000
```

Demo user: `demo@wicart.local` / `password123`

## VPS deploy (nginx + PHP 8.3)

1. Point document root to `apps/api/public`
2. `composer install --no-dev -o`
3. `.env` production: `APP_DEBUG=false`, MySQL, `APP_URL=https://api.tudominio`
4. `php artisan migrate --force && php artisan storage:link && php artisan config:cache`
5. Permissions: `storage/` and `bootstrap/cache` writable by php-fpm
6. HTTPS required for mobile clients outside LAN

## Sync

See [docs/sync-contract.md](../../docs/sync-contract.md)
