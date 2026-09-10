import 'dart:developer';

import 'package:expense/core/constants/api_constants.dart';
import 'package:expense/core/services/dio_services/api_services.dart';

import 'package:expense/models/clinic_related/search_clinic_response_model.dart';

import 'package:flutter/material.dart';

class SearchClinicsApi {
  static Future<dynamic> searchClinicsApi({
    BuildContext? context,
    int? limit,
    required int page,
    required String search,
  }) async {
    try {
      final response = await GetApiServices.callApi(
        context: context,
        url: ApiConstants.searchClinic,
        requiresAuth: true,
        queryParams: {"limit": limit, "page": page, "search": search},
      );

      if (response == null) {
        return null;
      }

      final model = SearchClinicsDetailsResponseModel.fromJson(response.data);

      return model;
    } catch (e, stackTrace) {
      log('search clinic details API error: $e', stackTrace: stackTrace);

      return null;
    }
  }
}
