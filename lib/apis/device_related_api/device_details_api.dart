import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';
import 'package:expense/models/devices/loged_device_details_response_model.dart';

import 'package:flutter/material.dart';

class DeviceDetailsApi {
  static Future<dynamic> deviceDetailsApi({
    required BuildContext? context,
  }) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,

        url: ApiConstants.logedDeviceDetails,
      );

      if (response.data == null) {
        return null;
      }

      final model = LogedDeviceDetailsResponseModel.fromJson(response.data);

      return model;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
