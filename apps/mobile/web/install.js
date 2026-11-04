/**
 * Wi Cart — Android / PWA install prompt
 * - Detects Android UA
 * - Captures beforeinstallprompt (Chrome/Edge)
 * - Bottom banner on Android; discreet chip + modal on desktop
 * - Dismiss stored 7 days in localStorage
 */
(function () {
  'use strict';

  var STORAGE_KEY = 'wicart_install_dismiss_until';
  var DISMISS_DAYS = 7;
  var APK_URL =
    (window.WICART_APK_URL && String(window.WICART_APK_URL)) ||
    '/downloads/wi-cart.apk';
  var APP_URL = window.location.origin + window.location.pathname;

  var deferredPrompt = null;
  var root = null;

  function isAndroid() {
    return /Android/i.test(navigator.userAgent || '');
  }

  function isStandalone() {
    return (
      window.matchMedia('(display-mode: standalone)').matches ||
      window.navigator.standalone === true
    );
  }

  function isDismissed() {
    try {
      var until = Number(localStorage.getItem(STORAGE_KEY) || 0);
      return until > Date.now();
    } catch (_) {
      return false;
    }
  }

  function dismissForWeek() {
    try {
      var until = Date.now() + DISMISS_DAYS * 24 * 60 * 60 * 1000;
      localStorage.setItem(STORAGE_KEY, String(until));
    } catch (_) {}
    hide();
  }

  function hide() {
    if (root) root.hidden = true;
  }

  function show() {
    if (root) root.hidden = false;
  }

  function qrUrl(data) {
    return (
      'https://api.qrserver.com/v1/create-qr-code/?size=168x168&data=' +
      encodeURIComponent(data)
    );
  }

  function canInstallPwa() {
    return !!deferredPrompt;
  }

  async function installPwa() {
    if (!deferredPrompt) {
      // Fallback: open APK if prompt unavailable
      window.open(APK_URL, '_blank', 'noopener');
      return;
    }
    deferredPrompt.prompt();
    try {
      var choice = await deferredPrompt.userChoice;
      deferredPrompt = null;
      updateInstallButtons();
      if (choice && choice.outcome === 'accepted') {
        dismissForWeek();
      }
    } catch (_) {
      deferredPrompt = null;
      updateInstallButtons();
    }
  }

  function updateInstallButtons() {
    var buttons = document.querySelectorAll('[data-wc-install]');
    buttons.forEach(function (btn) {
      if (canInstallPwa()) {
        btn.disabled = false;
        btn.textContent = 'Instalar App';
        btn.title = 'Instalar como PWA';
      } else if (isStandalone()) {
        btn.disabled = true;
        btn.textContent = 'Ya instalada';
      } else {
        btn.disabled = false;
        btn.textContent = 'Instalar App';
        btn.title = 'PWA no disponible aún — usa Descargar APK';
      }
    });
  }

  function buildAndroidBanner() {
    var el = document.createElement('div');
    el.className = 'wc-banner';
    el.setAttribute('role', 'dialog');
    el.setAttribute('aria-label', 'Instalar Wi Cart');
    el.innerHTML =
      '<div class="wc-banner__top">' +
      '<img class="wc-banner__icon" src="icons/Icon-192.png" alt="Wi Cart">' +
      '<div class="wc-banner__copy">' +
      '<p class="wc-banner__title">Instala la App de Wi Cart</p>' +
      '<p class="wc-banner__sub">Accede 100% Offline desde tu teléfono Android</p>' +
      '</div>' +
      '<button type="button" class="wc-banner__close" aria-label="Cerrar" data-wc-dismiss>×</button>' +
      '</div>' +
      '<div class="wc-banner__actions">' +
      '<button type="button" class="wc-btn wc-btn--primary" data-wc-install>Instalar App</button>' +
      '<a class="wc-btn wc-btn--secondary" href="' +
      APK_URL +
      '" download data-wc-apk>Descargar APK</a>' +
      '</div>';
    return el;
  }

  function buildDesktopChip() {
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'wc-desktop-chip';
    btn.setAttribute('data-wc-desktop-open', '1');
    btn.innerHTML =
      '<img src="icons/Icon-192.png" alt="">' +
      '<span>Descargar App para Android</span>';
    return btn;
  }

  function openDesktopModal() {
    var backdrop = document.createElement('div');
    backdrop.className = 'wc-modal-backdrop';
    backdrop.innerHTML =
      '<div class="wc-modal" role="dialog" aria-modal="true" aria-label="Descargar Wi Cart">' +
      '<h2>Wi Cart para Android</h2>' +
      '<p>Escanea el QR en tu teléfono o descarga el APK / instala la PWA.</p>' +
      '<div class="wc-qr"><img alt="QR" src="' +
      qrUrl(APP_URL) +
      '"></div>' +
      '<div class="wc-banner__actions">' +
      '<button type="button" class="wc-btn wc-btn--primary" data-wc-install>Instalar App</button>' +
      '<a class="wc-btn wc-btn--secondary" href="' +
      APK_URL +
      '" download>Descargar APK</a>' +
      '</div>' +
      '<button type="button" class="wc-modal__close" data-wc-modal-close>Cerrar</button>' +
      '</div>';

    function close() {
      backdrop.remove();
    }

    backdrop.addEventListener('click', function (e) {
      if (e.target === backdrop || e.target.hasAttribute('data-wc-modal-close')) {
        close();
      }
    });
    backdrop.querySelector('[data-wc-install]').addEventListener('click', installPwa);
    root.appendChild(backdrop);
    updateInstallButtons();
  }

  function mount() {
    if (document.getElementById('wc-install-root')) return;

    root = document.createElement('div');
    root.id = 'wc-install-root';

    if (isStandalone()) {
      // Already installed PWA — optional discreet APK only on Android
      if (isAndroid() && !isDismissed()) {
        var mini = document.createElement('div');
        mini.className = 'wc-banner';
        mini.innerHTML =
          '<div class="wc-banner__top">' +
          '<img class="wc-banner__icon" src="icons/Icon-192.png" alt="">' +
          '<div class="wc-banner__copy">' +
          '<p class="wc-banner__title">Versión nativa (APK)</p>' +
          '<p class="wc-banner__sub">Opcional si prefieres el paquete Android</p>' +
          '</div>' +
          '<button type="button" class="wc-banner__close" data-wc-dismiss aria-label="Cerrar">×</button>' +
          '</div>' +
          '<div class="wc-banner__actions">' +
          '<a class="wc-btn wc-btn--primary" href="' +
          APK_URL +
          '" download>Descargar APK</a>' +
          '</div>';
        root.appendChild(mini);
        root.querySelector('[data-wc-dismiss]').addEventListener('click', dismissForWeek);
      } else {
        root.hidden = true;
      }
    } else if (isAndroid()) {
      if (isDismissed()) {
        root.hidden = true;
      } else {
        root.appendChild(buildAndroidBanner());
        root.querySelector('[data-wc-dismiss]').addEventListener('click', dismissForWeek);
        root.querySelector('[data-wc-install]').addEventListener('click', installPwa);
      }
    } else {
      // Desktop / other — discreet chip (always available, not dismissed by Android rule)
      if (!isDismissed()) {
        root.appendChild(buildDesktopChip());
        root
          .querySelector('[data-wc-desktop-open]')
          .addEventListener('click', openDesktopModal);
      } else {
        root.hidden = true;
      }
    }

    document.body.appendChild(root);
    updateInstallButtons();
  }

  // Capture install prompt as early as possible
  window.addEventListener('beforeinstallprompt', function (e) {
    e.preventDefault();
    deferredPrompt = e;
    updateInstallButtons();
    // Re-show Android banner if it was hidden only because prompt was missing? keep as-is
    if (isAndroid() && !isStandalone() && !isDismissed()) {
      show();
    }
  });

  window.addEventListener('appinstalled', function () {
    deferredPrompt = null;
    dismissForWeek();
  });

  // Public API for Flutter interop if needed
  window.WiCartInstall = {
    install: installPwa,
    dismiss: dismissForWeek,
    isAndroid: isAndroid,
    isStandalone: isStandalone,
    apkUrl: APK_URL,
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', mount);
  } else {
    mount();
  }
})();
