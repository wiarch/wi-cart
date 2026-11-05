import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  ApiClient({required this.baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {'Accept': 'application/json'},
        )),
        _storage = const FlutterSecureStorage();

  String baseUrl;
  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const tokenKey = 'auth_token';
  static const userJsonKey = 'auth_user_json';

  Dio get dio => _dio;

  void setBaseUrl(String url) {
    baseUrl = url.replaceAll(RegExp(r'/+$'), '');
    _dio.options.baseUrl = baseUrl;
  }

  Future<void> setToken(String? token) async {
    if (token == null) {
      await _storage.delete(key: tokenKey);
      _dio.options.headers.remove('Authorization');
      return;
    }
    await _storage.write(key: tokenKey, value: token);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<void> restoreToken() async {
    final token = await _storage.read(key: tokenKey);
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<String?> getToken() => _storage.read(key: tokenKey);

  Future<Map<String, dynamic>> loginWithGoogle({
    required String idToken,
    String deviceName = 'mobile',
  }) async {
    final res = await _dio.post('/api/auth/google', data: {
      'id_token': idToken,
      'device_name': deviceName,
    });
    await _persistAuth(res.data as Map<String, dynamic>);
    return res.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/logout');
    } catch (_) {}
    await setToken(null);
    await _storage.delete(key: userJsonKey);
  }

  Future<String?> getUserId() async {
    final raw = await _storage.read(key: userJsonKey);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map['id']?.toString();
    } catch (_) {
      return null;
    }
  }

  /// Bidirectional sync: push mutations + pull delta in one round-trip.
  Future<Map<String, dynamic>> sync({
    required String deviceId,
    required List<Map<String, dynamic>> mutations,
    String? since,
  }) async {
    final res = await _dio.post('/api/sync', data: {
      'device_id': deviceId,
      if (since != null) 'since': since,
      'mutations': mutations,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> push({
    required String deviceId,
    required List<Map<String, dynamic>> mutations,
  }) async {
    final res = await _dio.post('/api/sync/push', data: {
      'device_id': deviceId,
      'mutations': mutations,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> pull({String? since}) async {
    final res = await _dio.get('/api/sync/pull', queryParameters: {
      if (since != null) 'since': since,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> uploadProductImage({
    required String productId,
    required String filePath,
    required DateTime clientUpdatedAt,
  }) async {
    final form = FormData.fromMap({
      'product_id': productId,
      'client_updated_at': clientUpdatedAt.toUtc().toIso8601String(),
      'image': await MultipartFile.fromFile(filePath),
    });
    final res = await _dio.post('/api/uploads/product-image', data: form);
    return res.data as Map<String, dynamic>;
  }

  Future<void> _persistAuth(Map<String, dynamic> data) async {
    final token = data['token'] as String?;
    if (token != null) await setToken(token);
    final user = data['user'];
    if (user is Map<String, dynamic>) {
      await _storage.write(key: userJsonKey, value: jsonEncode(user));
    }
  }
}
