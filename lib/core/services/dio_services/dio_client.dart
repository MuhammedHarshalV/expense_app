import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/auth_interceptor.dart';

class DioClient {
  static final Dio dio = Dio(
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

  static void initialize() {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();

        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

        return client;
      },
    );

    dio.interceptors.add(AuthInterceptor(dio));
  }
}
