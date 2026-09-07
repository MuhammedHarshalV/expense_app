import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';
import 'package:expense/models/get_profile_details_response_model.dart';

import 'package:flutter/material.dart';

class ProfileApi {
  static Future<dynamic> getProfile({BuildContext? context}) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,
        url: ApiConstants.profileApi,
        requiresAuth: true,
      );

      if (response == null) {
        return null;
      }

      final model = GetProfileDetailsResponseModel.fromJson(response.data);

      return model;
    } catch (e, stackTrace) {
      log('Profile API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
