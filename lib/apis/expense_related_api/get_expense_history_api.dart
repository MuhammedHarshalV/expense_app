import 'dart:developer';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';
import 'package:expense/models/expense_related/get_expense_history_response_model.dart';

import 'package:flutter/material.dart';

class GetExpenseHistoryApi {
  static Future<dynamic> getExpenseHistoryApi({
    BuildContext? context,
    int? pageNumber,
    int? limit,
    String? search,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,
        url: ApiConstants.getExpenseHistory,
        requiresAuth: true,
        queryParams: {
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          "page": pageNumber,
          "limit": limit,
        },
      );

      if (response == null) {
        return null;
      }

      final model = GetExpenseHistoryResponseModel.fromJson(response.data);

      return model;
    } catch (e, stackTrace) {
      log('expense history details API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
