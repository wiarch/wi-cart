# Deploy VPS

## Requisitos
- Ubuntu/Debian o similar
- PHP 8.3+ (php-fpm, mbstring, xml, curl, zip, mysql, gd)
- MySQL 8+
- Nginx
- Composer
- SSL (Let's Encrypt)

## Pasos

```bash
# código
git clone <repo> /var/www/wi-cart
cd /var/www/wi-cart/apps/api
composer install --no-dev -o
cp .env.example .env
php artisan key:generate
# editar .env: APP_URL, DB_*, APP_DEBUG=false
php artisan migrate --force
php artisan db:seed --force
php artisan storage:link
php artisan config:cache
php artisan route:cache
chown -R www-data:www-data storage bootstrap/cache
```

## Nginx

```nginx
server {
    listen 443 ssl http2;
    server_name api.tudominio.com;
    root /var/www/wi-cart/apps/api/public;

    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
    }

    location /storage {
        alias /var/www/wi-cart/apps/api/storage/app/public;
    }
}
```

## App móvil + Web PWA

```bash
# APK nativo
flutter build apk --dart-define=API_BASE_URL=https://api.tudominio.com
# copiar a VPS, ej:
# /var/www/wi-cart/public/downloads/wi-cart.apk

# Web instalable (PWA)
cd apps/mobile
flutter build web --dart-define=API_BASE_URL=https://api.tudominio.com
```

Servir `build/web` por HTTPS. Banner Android usa:
- PWA: evento `beforeinstallprompt` (`web/install.js`)
- APK: `window.WICART_APK_URL` (default `/downloads/wi-cart.apk`)

En `index.html` del deploy puedes fijar:

```html
<script>window.WICART_APK_URL = 'https://tudominio.com/downloads/wi-cart.apk';</script>
```

Token Sanctum en secure storage. Sync solo con Bearer + HTTPS.
