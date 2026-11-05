import 'dart:async';

/// Emits [combine] of latest values once both streams have emitted.
Stream<R> combineLatest2<A, B, R>(
  Stream<A> a,
  Stream<B> b,
  R Function(A, B) combine,
) {
  final controller = StreamController<R>();
  A? va;
  B? vb;
  var ha = false, hb = false;
  void emit() {
    if (ha && hb && !controller.isClosed) {
      controller.add(combine(va as A, vb as B));
    }
  }

  final subs = <StreamSubscription<dynamic>>[
    a.listen((v) {
      va = v;
      ha = true;
      emit();
    }, onError: controller.addError),
    b.listen((v) {
      vb = v;
      hb = true;
      emit();
    }, onError: controller.addError),
  ];
  controller.onCancel = () async {
    for (final s in subs) {
      await s.cancel();
    }
  };
  return controller.stream;
}

/// Emits [combine] of latest values once all three streams have emitted.
Stream<R> combineLatest3<A, B, C, R>(
  Stream<A> a,
  Stream<B> b,
  Stream<C> c,
  R Function(A, B, C) combine,
) {
  final ab = combineLatest2(a, b, (A x, B y) => (x, y));
  return combineLatest2(ab, c, (r, C z) => combine(r.$1, r.$2, z));
}

/// Emits [combine] of latest values once all four streams have emitted.
Stream<R> combineLatest4<A, B, C, D, R>(
  Stream<A> a,
  Stream<B> b,
  Stream<C> c,
  Stream<D> d,
  R Function(A, B, C, D) combine,
) {
  final abc = combineLatest2(
    combineLatest2(a, b, (A x, B y) => (x, y)),
    c,
    (r, C z) => (r.$1, r.$2, z),
  );
  return combineLatest2(abc, d, (r, D w) => combine(r.$1, r.$2, r.$3, w));
}
