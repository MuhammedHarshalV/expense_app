import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class DeleteClinicApi {
  static Future<dynamic> deleteClinicApi({
    BuildContext? context,
    FormData? body,
    required int clinicId,
  }) async {
    try {
      final response = await DeleteApiServices.callApi(
        context: context,
        url: ApiConstants.deleteClinic,
        queryParams: {"clinic_id": clinicId},
        body: body,
      );

      if (response.data == null) {
        return null;
      }

      return response.data['success'];
    } catch (e, stackTrace) {
      log('delete clinic API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
