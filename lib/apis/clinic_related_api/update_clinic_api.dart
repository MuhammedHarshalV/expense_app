import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class UpdateClinicApi {
  static Future<dynamic> updateClinicApi({
    BuildContext? context,
    required FormData body,
    required int id,
  }) async {
    try {
      final response = await PatchApiServices.callApi(
        context: context,
        url: ApiConstants.updateClinic,
        body: body,
        queryParams: {"clinic_id": id},
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
