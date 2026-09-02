import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/errors/app_message.dart';
import 'package:expense/core/services/dio_services/dio_client.dart';
import 'package:flutter/material.dart';

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

      return response.data;
    } on DioException catch (e) {
      log("DIO ERROR : ${e.message}");
      log("STATUS : ${e.response?.statusCode}");
      log("DATA : ${e.response?.data}");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        if (context != null) {
          AppMessage.show(context, 'Connection timed out');
        }
      } else if (e.type == DioExceptionType.connectionError) {
        if (context != null) {
          AppMessage.show(context, 'No Internet Connection');
        }
      } else if (e.response != null) {
        if (context != null) {
          AppMessage.show(
            context,
            e.response?.data['message'] ?? 'Server Error',
          );
        }
      }

      return null;
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

      return response.data;
    } on DioException catch (e) {
      log("DIO ERROR : ${e.message}");
      log("STATUS : ${e.response?.statusCode}");
      log("DATA : ${e.response?.data}");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        if (context != null) {
          AppMessage.show(context, 'Connection timed out');
        }
      } else if (e.type == DioExceptionType.connectionError) {
        if (context != null) {
          AppMessage.show(context, 'No Internet Connection');
        }
      } else if (e.response != null) {
        if (context != null) {
          AppMessage.show(
            context,
            e.response?.data['message'] ?? 'Server Error',
          );
        }
      }

      return null;
    }
  }
}
