import 'package:expense/core/services/global_listener/refresh_token_listener.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: accessTokenKey, value: accessToken);

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

  static Future<void> clear() async {
    await _storage.delete(key: accessTokenKey);

    await _storage.delete(key: refreshTokenKey);
    final String? refreshTokem = await _storage.read(key: refreshTokenKey);
    if (refreshTokem == null) {
      AppNavigator.goToLogin(isLogout: true);
    }
  }
}
