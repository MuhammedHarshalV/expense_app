import 'package:expense/core/services/global_listener/refresh_token_listener.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String baseUrlKey = 'base_url';
  static const String deviceIdKey = 'deviceId';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String? baseUrl,
    required String? deviceId,
  }) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
    if (baseUrl != null) await _storage.write(key: baseUrlKey, value: baseUrl);
    if (deviceId != null)
      await _storage.write(key: deviceIdKey, value: deviceId);
    await _storage.write(key: refreshTokenKey, value: refreshToken);
  }

  static Future<void> saveAccessToken(String accessToken) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
  }

  static Future<String?> getAccessToken() async {
    return _storage.read(key: accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: refreshTokenKey);
  }

  static Future<String?> getBaseUrl() async {
    return _storage.read(key: baseUrlKey);
  }

  static Future<String?> getDeviceId() async {
    return _storage.read(key: deviceIdKey);
  }

  static Future<void> clear() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: deviceIdKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: baseUrlKey);
    final String? refreshTokem = await _storage.read(key: refreshTokenKey);
    if (refreshTokem == null) {
      AppNavigator.goToLogin(isLogout: true);
    }
  }
}
