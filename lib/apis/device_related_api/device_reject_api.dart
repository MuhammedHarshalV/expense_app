import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class DeviceRejectApi {
  static Future<dynamic> deviceRejectApi({
    required BuildContext? context,
  }) async {
    try {
      final response = await PostApiServices.callApi(
        context: context,

        url: ApiConstants.deviceRequestRejection,
      );

      final data = response.data;

      if (data["success"] == true) {
        return true;
      }

      return false;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
