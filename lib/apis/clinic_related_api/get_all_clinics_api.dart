import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';
import 'package:expense/models/clinic_related/get_all_clinic_details_response_model.dart';

import 'package:flutter/material.dart';

class GetAllClinicsApi {
  static Future<dynamic> getAllClinicsApi({
    BuildContext? context,
    int? limit,
    required int page,
  }) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,
        url: ApiConstants.getAllClinics,
        requiresAuth: true,
        queryParams: {"limit": limit, "page": page},
      );

      if (response == null) {
        return null;
      }

      final model = GetAllClinicsDetailsResponseModel.fromJson(response.data);

      return model;
    } catch (e, stackTrace) {
      log('clinic details API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
