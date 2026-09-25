import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';
import 'package:expense/core/services/dio_services/dio_client.dart';
import 'package:expense/core/storage/token_storage.dart';
import 'package:expense/models/login_response_model.dart';
import 'package:flutter/material.dart';

class SignInChecking {
  static Future<dynamic> signInChecking({
    required BuildContext context,
    required Map<String, dynamic> body,
    required String url,
  }) async {
    try {
      final response = await PostApiServices.callApi(
        context: context,
        body: body,
        url: ApiConstants.loginApi,

        // Login does not need access token
        requiresAuth: false,
      );

      if (response.data == null) {
        return response;
      }

      if (response.data['success'] != true) {
        return response;
      }

      final model = LoginResponseModel.fromJson(response.data);

      await TokenStorage.saveTokens(
        accessToken: model.accessToken ?? '',
        refreshToken: model.refreshToken ?? '',
        baseUrl: url,
      );

      // Keep current runtime Dio synchronized too
      DioClient.setBaseUrl(url);
      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
