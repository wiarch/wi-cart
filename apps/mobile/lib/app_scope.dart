import 'package:flutter/widgets.dart';

import 'data/database.dart';
import 'data/outbox.dart';
import 'data/repository.dart';
import 'services/api_client.dart';
import 'services/exchange_rate_service.dart';
import 'sync/sync_engine.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.db,
    required this.api,
    required this.outbox,
    required this.repo,
    required this.sync,
    required this.rates,
    required super.child,
  });

  final AppDatabase db;
  final ApiClient api;
  final OutboxWriter outbox;
  final CartRepository repo;
  final SyncEngine sync;
  final ExchangeRateService rates;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope missing');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      rates != oldWidget.rates || sync != oldWidget.sync;
}
