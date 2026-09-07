import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';
import 'package:expense/models/get_profile_details_response_model.dart';

import 'package:flutter/material.dart';

class UpdateUserApi {
  static Future<dynamic> updateUserApi({
    BuildContext? context,
    required FormData body,
  }) async {
    try {
      final response = await PatchApiServices.callApi(
        context: context,
        url: ApiConstants.profileUpdation,
        body: body,
      );

      if (response.data == null) {
        return null;
      }

      final model = GetProfileDetailsResponseModel.fromJson(response.data);

      return model;
    } catch (e, stackTrace) {
      log('update Profile API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
