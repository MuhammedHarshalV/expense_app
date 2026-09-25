import 'dart:developer';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';
import 'package:expense/models/expense_related/get_expense_history_response_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetExpenseHistoryApi {
  static Future<dynamic> getExpenseHistoryApi({
    BuildContext? context,
    int? pageNumber,
    int? limit,
    String? search,
    String? startDate,
    String? endDate,
    String? filter,
  }) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,
        url: ApiConstants.getExpenseHistory,
        requiresAuth: true,
        queryParams: {
          "search": search,
          "start_date": convertDate(startDate),
          "end_date": convertDate(endDate),
          "page": pageNumber,
          "limit": limit,
          "filter": filter ?? 'latest',
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

  static String? convertDate(String? date) {
    if (date == null || date.isEmpty) return null;

    final parsedDate = DateFormat('dd-MMM-yyyy').parse(date);

    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }
}
