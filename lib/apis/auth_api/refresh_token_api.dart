import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:flutter/material.dart';

class RefreshTokenApi {
  static Future<dynamic> refreshTokenApi({
    required BuildContext? context,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await PostApiServices.callApi(
        context: context,
        body: body,
        url: ApiConstants.refreshToken,

        // Login does not need access token
        requiresAuth: false,
      );

      if (response == null) {
        return null;
      }

      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
