import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class CreateClinicApi {
  static Future<dynamic> createClinicApi({
    BuildContext? context,
    required FormData body,
  }) async {
    try {
      final response = await PostApiServices.callApi(
        context: context,
        url: ApiConstants.createClinic,
        body: body,
      );

      if (response.data == null) {
        return null;
      }

      return response.data;
    } catch (e, stackTrace) {
      log('create clinic API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
