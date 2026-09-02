import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra['requiresAuth'] ?? true;

    // Public API
    if (requiresAuth == false) {
      return handler.next(options);
    }

    final accessToken = await TokenStorage.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    final requiresAuth = err.requestOptions.extra['requiresAuth'] ?? true;

    // Public API should not try refresh token
    if (requiresAuth == false) {
      return handler.next(err);
    }

    // Only handle 401
    if (statusCode != 401) {
      return handler.next(err);
    }

    // Avoid refresh loop
    if (err.requestOptions.path == ApiConstants.refreshToken) {
      await TokenStorage.clear();
      return handler.next(err);
    }

    try {
      final refreshToken = await TokenStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await TokenStorage.clear();

        return handler.next(err);
      }

      log('Access token expired. Refreshing...');

      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'];

      if (newAccessToken == null) {
        await TokenStorage.clear();

        return handler.next(err);
      }

      await TokenStorage.saveAccessToken(newAccessToken);

      log('New access token saved');

      // Update original failed request
      final requestOptions = err.requestOptions;

      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      // Retry SAME API request
      final retryResponse = await dio.fetch(requestOptions);

      return handler.resolve(retryResponse);
    } catch (e) {
      log('Refresh token failed: $e');

      await TokenStorage.clear();

      return handler.next(err);
    }
  }
}
