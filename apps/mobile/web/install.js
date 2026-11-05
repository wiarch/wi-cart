/**
 * Wi Cart — Android / PWA install prompt
 * Modal on first visit (browser only). Dismiss stored 7 days.
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
    closeModal();
  }

  function closeModal() {
    if (!root) return;
    var backdrop = root.querySelector('.wc-modal-backdrop');
    if (backdrop) backdrop.remove();
    root.hidden = true;
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
        btn.textContent = isAndroid() ? 'Instalar App' : 'Instalar en este dispositivo';
        btn.title = 'PWA no disponible aún — usa Descargar APK';
      }
    });
  }

  function openEntryModal() {
    if (!root || root.querySelector('.wc-modal-backdrop')) return;

    root.hidden = false;
    var backdrop = document.createElement('div');
    backdrop.className = 'wc-modal-backdrop';
    backdrop.innerHTML =
      '<div class="wc-modal" role="dialog" aria-modal="true" aria-label="Instalar Wi Cart">' +
      '<img class="wc-modal__icon" src="icons/Icon-192.png" alt="Wi Cart">' +
      '<h2>Wi Cart en tu teléfono</h2>' +
      '<p>Instala la app Android para usar listas offline, o descarga el APK.</p>' +
      (isAndroid()
        ? ''
        : '<div class="wc-qr"><img alt="QR" src="' + qrUrl(APP_URL) + '"></div>') +
      '<div class="wc-modal__actions">' +
      '<button type="button" class="wc-btn wc-btn--primary" data-wc-install>Instalar App</button>' +
      '<a class="wc-btn wc-btn--secondary" href="' +
      APK_URL +
      '" download>Descargar APK</a>' +
      '</div>' +
      '<button type="button" class="wc-modal__close" data-wc-modal-close>Ahora no</button>' +
      '</div>';

    backdrop.addEventListener('click', function (e) {
      if (e.target === backdrop || e.target.hasAttribute('data-wc-modal-close')) {
        dismissForWeek();
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
    root.hidden = true;
    document.body.appendChild(root);

    if (isStandalone() || isDismissed()) return;
    openEntryModal();
  }

  window.addEventListener('beforeinstallprompt', function (e) {
    e.preventDefault();
    deferredPrompt = e;
    updateInstallButtons();
  });

  window.addEventListener('appinstalled', function () {
    deferredPrompt = null;
    dismissForWeek();
  });

  window.WiCartInstall = {
    install: installPwa,
    dismiss: dismissForWeek,
    isAndroid: isAndroid,
    isStandalone: isStandalone,
    apkUrl: APK_URL,
    open: openEntryModal,
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', mount);
  } else {
    mount();
  }
})();
