/**
 * Ensures a service worker is registered so Chrome can treat the site as installable.
 * Production Flutter builds already register flutter_service_worker.js via bootstrap;
 * this is a safe no-op / fallback for custom hosts.
 */
(function () {
  if (!('serviceWorker' in navigator)) return;

  window.addEventListener('load', function () {
    // Prefer Flutter-generated SW when present (after `flutter build web`).
    var candidates = [
      'flutter_service_worker.js',
      'flutter_service_worker.js?v=',
    ];

    navigator.serviceWorker.getRegistration().then(function (existing) {
      if (existing) return;
      // Try Flutter SW; ignore failures in `flutter run` (dev may lack the file).
      navigator.serviceWorker
        .register('flutter_service_worker.js')
        .catch(function () {
          /* dev / missing artifact — install prompt may wait until production build */
        });
    });
  });
})();
