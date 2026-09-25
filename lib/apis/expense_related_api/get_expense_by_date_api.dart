import 'dart:developer';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';
import 'package:expense/models/expense_related/get_expense_by_date_response_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetExpenseByDateApi {
  static Future<dynamic> getExpenseByDateApi({
    BuildContext? context,
    int? clinicId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,
        url: ApiConstants.getExpenseByDate,
        requiresAuth: true,
        queryParams: {
          "clinic_id": clinicId,
          "start_date": convertDate(startDate),
          "end_date": convertDate(endDate),
        },
      );

      if (response == null) {
        return null;
      }

      final model = GetExpenseByDateResponseModel.fromJson(response.data);

      return model;
    } catch (e, stackTrace) {
      log(
        'clinic expense details by date API error: $e',
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  static String? convertDate(String? date) {
    if (date == null || date.isEmpty) return null;

    final parsedDate = DateFormat('dd-MMM-yyyy').parse(date);

    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }
}
