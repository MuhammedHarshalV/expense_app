import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class DeviceRequest {
  static Future<dynamic> deviceRequest({required BuildContext? context}) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,

        url: ApiConstants.devicerequestApi,
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
