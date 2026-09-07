import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/errors/app_message.dart';
import 'package:expense/core/services/dio_services/dio_client.dart';
import 'package:flutter/material.dart';

class ApiResult {
  final dynamic data;
  final int? statusCode;
  final bool isNetworkError;

  const ApiResult({this.data, this.statusCode, this.isNetworkError = false});
}

class GetApiServices {
  static Future<dynamic> callApi({
    BuildContext? context,
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,

    // Default = secured API
    bool requiresAuth = true,
  }) async {
    try {
      log("=========== API REQUEST ===========");
      log("METHOD : GET");
      log("URL    : ${ApiConstants.baseUrl}$url");
      log("QUERY  : ${queryParams ?? {}}");
      log("===================================");

      final response = await DioClient.dio.get(
        url,
        data: body,
        queryParameters: queryParams,

        options: Options(extra: {'requiresAuth': requiresAuth}),
      );

      log("=========== API RESPONSE ===========");
      log("STATUS CODE : ${response.statusCode}");
      log("DATA : ${response.data}");
      log("===================================");

      return ApiResult(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      log("DIO ERROR : ${e.message}");
      log("STATUS : ${e.response?.statusCode}");
      log("DATA : ${e.response?.data}");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        if (context != null && context.mounted) {
          AppMessage.show(context, 'Connection timed out');
        }

        // IMPORTANT: outside context check
        return const ApiResult(isNetworkError: true);
      } else if (e.type == DioExceptionType.connectionError) {
        if (context != null && context.mounted) {
          AppMessage.show(context, 'No Internet Connection');
        }

        // IMPORTANT: outside context check
        return const ApiResult(isNetworkError: true);
      } else if (e.response != null) {
        if (context != null && context.mounted) {
          AppMessage.show(
            context,
            e.response?.data['message'] ?? 'Server Error',
          );
        }
        return ApiResult(
          data: e.response?.data,
          statusCode: e.response?.statusCode,
        );
      }

      return const ApiResult();
    } catch (e, stackTrace) {
      log('POST API ERROR: $e', stackTrace: stackTrace);

      return const ApiResult();
    }
  }
}

//post service
class PostApiServices {
  static Future<dynamic> callApi({
    BuildContext? context,
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParams,

    // Most APIs need token
    bool requiresAuth = true,
  }) async {
    try {
      log("=========== API REQUEST ===========");
      log("METHOD : POST");
      log("URL    : ${ApiConstants.baseUrl}$url");
      log("BODY   : ${body ?? {}}");
      log("QUERY  : ${queryParams ?? {}}");
      log("===================================");

      final response = await DioClient.dio.post(
        url,
        data: body,
        queryParameters: queryParams,

        options: Options(extra: {'requiresAuth': requiresAuth}),
      );

      log("=========== API RESPONSE ===========");
      log("STATUS CODE : ${response.statusCode}");
      log("DATA : ${response.data}");
      log("===================================");

      return ApiResult(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      log("DIO ERROR : ${e.message}");
      log("STATUS : ${e.response?.statusCode}");
      log("DATA : ${e.response?.data}");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        if (context != null && context.mounted) {
          AppMessage.show(context, 'Connection timed out');
        }

        // IMPORTANT: outside context check
        return const ApiResult(isNetworkError: true);
      } else if (e.type == DioExceptionType.connectionError) {
        if (context != null && context.mounted) {
          AppMessage.show(context, 'No Internet Connection');
        }

        // IMPORTANT: outside context check
        return const ApiResult(isNetworkError: true);
      } else if (e.response != null) {
        if (context != null && context.mounted) {
          AppMessage.show(
            context,
            e.response?.data['message'] ?? 'Server Error',
          );
        }
        return ApiResult(
          data: e.response?.data,
          statusCode: e.response?.statusCode,
        );
      }

      return const ApiResult();
    } catch (e, stackTrace) {
      log('POST API ERROR: $e', stackTrace: stackTrace);

      return const ApiResult();
    }
  }
}

//patch api
class PatchApiServices {
  static Future<ApiResult> callApi({
    BuildContext? context,
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParams,

    // Default = secured API
    bool requiresAuth = true,
  }) async {
    try {
      log("=========== API REQUEST ===========");
      log("METHOD : PATCH");
      log("URL    : ${ApiConstants.baseUrl}$url");
      if (body is FormData) {
        log("BODY TYPE : FormData");

        for (final field in body.fields) {
          log("${field.key} : ${field.value}");
        }

        for (final file in body.files) {
          log("${file.key} : ${file.value.filename}");
        }
      } else {
        log("BODY   : ${body ?? {}}");
      }
      log("QUERY  : ${queryParams ?? {}}");
      log("===================================");

      final response = await DioClient.dio.patch(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );

      log("=========== API RESPONSE ===========");
      log("STATUS CODE : ${response.statusCode}");
      log("DATA : ${response.data}");
      log("===================================");

      return ApiResult(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      log("=========== DIO ERROR ===========");
      log("MESSAGE : ${e.message}");
      log("STATUS  : ${e.response?.statusCode}");
      log("DATA    : ${e.response?.data}");
      log("TYPE    : ${e.type}");
      log("=================================");

      // Timeout
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        if (context != null && context.mounted) {
          AppMessage.show(context, 'Connection timed out');
        }

        return const ApiResult(isNetworkError: true);
      }

      // No network / server unreachable
      if (e.type == DioExceptionType.connectionError) {
        if (context != null && context.mounted) {
          AppMessage.show(context, 'No Internet Connection');
        }

        return const ApiResult(isNetworkError: true);
      }

      // Backend returned error response
      if (e.response != null) {
        final data = e.response?.data;

        if (context != null && context.mounted) {
          AppMessage.show(
            context,
            data is Map ? data['message'] ?? 'Server Error' : 'Server Error',
          );
        }

        return ApiResult(data: data, statusCode: e.response?.statusCode);
      }

      return const ApiResult();
    } catch (e, stackTrace) {
      log('PATCH API ERROR: $e', stackTrace: stackTrace);

      return const ApiResult();
    }
  }
}
