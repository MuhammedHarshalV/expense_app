import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class CreateExpenseApi {
  static Future<dynamic> createExpenseApi({
    BuildContext? context,
    required FormData body,
    required int clinicId,
  }) async {
    try {
      final response = await PostApiServices.callApi(
        context: context,
        url: ApiConstants.createExpense,
        body: body,
        queryParams: {"clinic_id": clinicId},
      );

      if (response.data == null) {
        return null;
      }

      return response.data;
    } catch (e, stackTrace) {
      log('create expense API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
