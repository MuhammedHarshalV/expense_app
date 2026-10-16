import 'dart:developer';

import 'package:expense/apis/auth_api/device_request.dart';

import 'package:expense/apis/clinic_related_api/delete_clinic_api.dart';
import 'package:expense/apis/clinic_related_api/get_all_clinics_api.dart';
import 'package:expense/controller/home_screen/home_screen_state.dart';
import 'package:expense/core/errors/app_message.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/models/clinic_related/get_all_clinic_details_response_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(const HomeState());
  //allow devices

  //get all clinics
  Future<void> getAllclinics({
    required int page,
    required BuildContext? context,
  }) async {
    try {
      // First page
      if (page == 1) {
        state = state.copyWith(isLoading: true);
      } else {
        // Pagination
        if (state.isPaginationLoading) {
          return;
        }

        state = state.copyWith(isPaginationLoading: true);
      }

      final GetAllClinicsDetailsResponseModel response =
          await GetAllClinicsApi.getAllClinicsApi(page: page);

      if (response.success == true) {
        final newClinics = response.data ?? [];

        if (page == 1) {
          // First page / refresh -> replace list
          state = state.copyWith(
            clinicList: newClinics,
            page: page,
            totalPages: response.pagination?.totalPages ?? 0,
            imageVersion: DateTime.now().millisecondsSinceEpoch,
          );
        } else {
          // Next page -> append list
          state = state.copyWith(
            clinicList: [...state.clinicList, ...newClinics],
            page: page,
            totalPages: response.pagination?.totalPages ?? state.totalPages,
            imageVersion: DateTime.now().millisecondsSinceEpoch,
          );
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isLoading: false, isPaginationLoading: false);
      final dynamic request = await DeviceRequest.deviceRequest(
        context: context,
      );
      if (request == true && context != null) {
        AppMessage.show(context, "neww device request");
      }
    }
  }

  //delete existing clinic
  Future<void> deleteClinic({
    required int clinicId,
    required BuildContext context,
  }) async {
    try {
      final response = await DeleteClinicApi.deleteClinicApi(
        clinicId: clinicId,
        context: context,
      );
      if (response == true) {
        getAllclinics(page: 1, context: context);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Clinic delete successfully',
              style: TextStyle(
                fontFamily: "Notche",

                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.appGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

final homeProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) => HomeController()..getAllclinics(page: 1, context: null),
);
