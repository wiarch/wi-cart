# wi-cart mobile (Flutter Offline-First)

Local SQLite via Drift + outbox sync to Laravel API.

## Setup

```bash
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

API URL defaults to `http://10.0.2.2:8000` (Android emulator → host). Override:

```bash
flutter run --dart-define=API_BASE_URL=https://api.tudominio
# or SharedPreferences key api_base_url
```

## Run

```bash
flutter run                 # device / emulator
flutter run -d linux        # desktop if toolchain ok
flutter build apk
flutter build web           # web target (SQLite via wasm limitations — prefer mobile)
```

## Offline rules

1. UI writes Drift only → `sync_outbox`
2. Online: push → pull → deferred image upload
3. LWW on `client_updated_at`
4. Sync badge = pending count; tap forces sync
