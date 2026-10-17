import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class LogoutApi {
  static Future<dynamic> logoutApi({
    required BuildContext context,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await PostApiServices.callApi(
        context: context,
        body: body,
        url: ApiConstants.logOutApi,
      );

      if (response.data["success"] == true) {
        return true;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
