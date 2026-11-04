import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_scope.dart';
import 'data/database.dart';
import 'data/outbox.dart';
import 'data/repository.dart';
import 'services/api_client.dart';
import 'services/exchange_rate_service.dart';
import 'sync/sync_engine.dart';
import 'ui/auth/login_page.dart';
import 'ui/home_shell.dart';
import 'ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final baseUrl =
      prefs.getString('api_base_url') ?? const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://10.0.2.2:8000',
      );

  final db = AppDatabase();
  final api = ApiClient(baseUrl: baseUrl);
  final outbox = OutboxWriter(db);
  final repo = CartRepository(db, outbox);
  final sync = SyncEngine(db: db, api: api, outbox: outbox);
  final rates = ExchangeRateService();
  await rates.init();
  await sync.start();
  // Fresh BCV rates every cold start (cached values used offline if fail).
  unawaited(rates.refresh());

  runApp(WiCartApp(
    db: db,
    api: api,
    outbox: outbox,
    repo: repo,
    sync: sync,
    rates: rates,
  ));
}

class WiCartApp extends StatefulWidget {
  const WiCartApp({
    super.key,
    required this.db,
    required this.api,
    required this.outbox,
    required this.repo,
    required this.sync,
    required this.rates,
  });

  final AppDatabase db;
  final ApiClient api;
  final OutboxWriter outbox;
  final CartRepository repo;
  final SyncEngine sync;
  final ExchangeRateService rates;

  @override
  State<WiCartApp> createState() => _WiCartAppState();
}

class _WiCartAppState extends State<WiCartApp> {
  bool? _authed;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final token = await widget.api.getToken();
    if (token != null) {
      await widget.repo.ensureDefaults();
    }
    if (mounted) setState(() => _authed = token != null);
  }

  @override
  void dispose() {
    widget.sync.dispose();
    widget.rates.dispose();
    widget.db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      db: widget.db,
      api: widget.api,
      outbox: widget.outbox,
      repo: widget.repo,
      sync: widget.sync,
      rates: widget.rates,
      child: MaterialApp(
        title: 'wi-cart',
        theme: AppTheme.light(),
        home: _authed == null
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : _authed!
                ? HomeShell(onLogout: () => setState(() => _authed = false))
                : LoginPage(onAuthed: () => setState(() => _authed = true)),
      ),
    );
  }
}
