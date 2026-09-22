import 'dart:developer';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class DeleteExpenseApi {
  static Future<dynamic> deleteExpenseApi({
    BuildContext? context,

    required int clinicId,
    required int expId,
  }) async {
    try {
      final response = await DeleteApiServices.callApi(
        context: context,
        url: ApiConstants.deleteExpense,
        queryParams: {"clinic_id": clinicId, "expense_id": expId},
      );

      if (response.data == null) {
        return null;
      }

      return response.data['success'];
    } catch (e, stackTrace) {
      log('delete expense API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
