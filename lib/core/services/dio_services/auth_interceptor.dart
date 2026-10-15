import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/device_details/device_details_picking.dart';

import 'package:expense/core/services/global_listener/refresh_token_listener.dart';
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
    // Prevent retry loop
    if (err.requestOptions.extra['retried'] == true) {
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
          baseUrl: dio.options.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      final String deviceId = await DeviceIdPicking.getDeviceId();
      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken, 'deviceId': deviceId},
      );

      final newAccessToken = response.data['data']['access_token'];

      if (newAccessToken == null) {
        await TokenStorage.clear();

        return handler.next(err);
      }

      await TokenStorage.saveAccessToken(newAccessToken);

      log('New access token saved');

      // Update original failed request
      final requestOptions = err.requestOptions;

      requestOptions.extra['retried'] = true;

      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      //if formdata
      if (requestOptions.data is FormData) {
        requestOptions.data = (requestOptions.data as FormData).clone();

        // Let Dio generate the new multipart boundary
        requestOptions.headers.remove(Headers.contentLengthHeader);

        requestOptions.headers.remove(Headers.contentTypeHeader);
      }

      // Retry SAME API request
      final retryResponse = await dio.fetch(requestOptions);

      return handler.resolve(retryResponse);
    } on DioException catch (refreshError) {
      final refreshStatus = refreshError.response?.statusCode;

      log(
        'Refresh failed. '
        'Status: $refreshStatus '
        'Type: ${refreshError.type}',
      );

      // ==============================
      // REFRESH TOKEN EXPIRED/INVALID
      // ==============================
      if (refreshStatus == 401) {
        log('Refresh token expired/invalid');

        await TokenStorage.clear();
        AppNavigator.goToLogin();
        // Login navigation should happen
        // from your auth/session layer.
        return handler.next(err);
      }

      // ==============================
      // NETWORK ERROR
      // ==============================
      if (refreshError.type == DioExceptionType.connectionError ||
          refreshError.type == DioExceptionType.connectionTimeout ||
          refreshError.type == DioExceptionType.receiveTimeout ||
          refreshError.type == DioExceptionType.sendTimeout) {
        log(
          'Network error during refresh. '
          'Keeping tokens.',
        );

        // IMPORTANT:
        // DON'T clear storage
        return handler.next(err);
      }

      // ==============================
      // SERVER ERROR 500 etc.
      // ==============================
      log(
        'Server error during refresh. '
        'Keeping tokens.',
      );

      // DON'T clear storage
      return handler.next(err);
    } catch (e, stackTrace) {
      log('Unexpected refresh error: $e', stackTrace: stackTrace);

      // Don't clear credentials for an
      // unknown client-side error.
      return handler.next(err);
    }
  }
}
