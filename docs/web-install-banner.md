# Banner instalación Android (Flutter Web / PWA)

## Archivos

| Path | Rol |
|------|-----|
| [`apps/mobile/web/install.js`](../apps/mobile/web/install.js) | UA Android, `beforeinstallprompt`, dismiss 7d |
| [`apps/mobile/web/install.css`](../apps/mobile/web/install.css) | Banner / chip / modal Material 3 |
| [`apps/mobile/web/sw-register.js`](../apps/mobile/web/sw-register.js) | Registro SW (instalabilidad) |
| [`apps/mobile/web/manifest.json`](../apps/mobile/web/manifest.json) | Web App Manifest |
| [`apps/mobile/web/index.html`](../apps/mobile/web/index.html) | Carga CSS/JS |

## UX

- **Android:** bottom sheet — Instalar App (PWA) + Descargar APK; ✕ guarda dismiss 7 días (`localStorage`).
- **Desktop:** chip “Descargar App para Android” → modal con QR + mismos CTAs.
- **Standalone (ya instalada):** solo APK opcional.

## Requisitos PWA instalable (Chrome Android)

1. HTTPS
2. `manifest.json` con `name`, `icons` 192+512, `start_url`, `display: standalone`
3. Service Worker activo (`flutter build web` genera `flutter_service_worker.js`)
4. Captura temprana de `beforeinstallprompt` (en `install.js`)

## API JS

```js
window.WiCartInstall.install()
window.WiCartInstall.dismiss()
window.WiCartInstall.isAndroid()
window.WICART_APK_URL = 'https://…/wi-cart.apk' // opcional
```
