import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// BCV rates (Bs per 1 USD / 1 EUR). Fetched on app open via bcv.today.
class ExchangeRateService extends ChangeNotifier {
  ExchangeRateService({Dio? dio}) : _dio = dio ?? Dio();

  static const apiUrl = 'https://bcv.today/api/v1/rate.json';

  static const _kUsd = 'bcv_usd_rate';
  static const _kEur = 'bcv_eur_rate';
  static const _kFetched = 'bcv_fetched_at';
  static const _kEffective = 'bcv_effective_date';
  static const _kShowEur = 'bcv_show_eur';

  final Dio _dio;

  double? usdToBs;
  double? eurToBs;
  DateTime? fetchedAt;
  String? effectiveDate;
  bool showEur = false;
  bool loading = false;
  String? error;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    usdToBs = prefs.getDouble(_kUsd);
    eurToBs = prefs.getDouble(_kEur);
    showEur = prefs.getBool(_kShowEur) ?? false;
    effectiveDate = prefs.getString(_kEffective);
    final raw = prefs.getString(_kFetched);
    if (raw != null) fetchedAt = DateTime.tryParse(raw);
    notifyListeners();
  }

  Future<void> setShowEur(bool value) async {
    showEur = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kShowEur, value);
    notifyListeners();
    // Refresh so EUR is always up to date when enabled.
    if (value) await refresh();
  }

  /// Call on every cold start (and manually from settings).
  Future<void> refresh() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        apiUrl,
        options: Options(
          headers: {'Cache-Control': 'no-cache'},
          responseType: ResponseType.json,
        ),
      );
      final data = res.data ?? {};
      final usd = _asDouble(data['USD']);
      final eur = _asDouble(data['EUR']);
      if (usd == null || usd <= 0) {
        throw StateError('Respuesta BCV sin USD');
      }
      usdToBs = usd;
      if (eur != null && eur > 0) eurToBs = eur;
      effectiveDate = data['effective_date']?.toString() ??
          data['date']?.toString();
      fetchedAt = DateTime.now().toUtc();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_kUsd, usdToBs!);
      if (eurToBs != null) await prefs.setDouble(_kEur, eurToBs!);
      if (effectiveDate != null) {
        await prefs.setString(_kEffective, effectiveDate!);
      }
      await prefs.setString(_kFetched, fetchedAt!.toIso8601String());
    } catch (e) {
      error = e.toString();
      // Keep last cached rates if any.
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  double? toBs(double usd) {
    if (usdToBs == null) return null;
    return usd * usdToBs!;
  }

  /// USD → EUR via Bs cross (only meaningful when both rates exist).
  double? toEur(double usd) {
    if (!showEur || usdToBs == null || eurToBs == null || eurToBs == 0) {
      return null;
    }
    return usd * usdToBs! / eurToBs!;
  }

  static double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll(',', '.'));
  }
}
