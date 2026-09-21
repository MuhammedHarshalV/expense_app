import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class UpdateExpenseApi {
  static Future<dynamic> updateExpenseApi({
    BuildContext? context,
    required FormData body,
    required int id,
    required int expId,
  }) async {
    try {
      final response = await PatchApiServices.callApi(
        context: context,
        url: ApiConstants.editExpense,
        body: body,
        queryParams: {"clinic_id": id, "expense_id": expId},
      );

      if (response.data == null) {
        return null;
      }

      return response.data;
    } catch (e, stackTrace) {
      log('edit clinic expense API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
