import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:expense/models/expense_related/all_expense_response_model.dart';

import 'package:flutter/material.dart';

class GetAllExpenseApi {
  static Future<dynamic> getAllExpenseApi({
    BuildContext? context,
    int? clinicId,
  }) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,
        url: ApiConstants.getAllExpense,
        requiresAuth: true,
        queryParams: {"clinic_id": clinicId},
      );

      if (response == null) {
        return null;
      }

      final model = AllClinicExpenseResponseModel.fromJson(response.data);

      return model;
    } catch (e, stackTrace) {
      log('clinic expense details API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
