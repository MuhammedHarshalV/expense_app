import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:expense/apis/clinic_related_api/search_clinics_api.dart';
import 'package:expense/apis/clinic_related_api/update_clinic_api.dart';
import 'package:expense/models/clinic_related/get_all_clinic_details_response_model.dart'
    as initial;
import 'package:expense/controller/edit_clinic_controller/edit_clinic_state.dart';

import 'package:expense/core/services/image_helper/network_image_to_bytes.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/models/clinic_related/search_clinic_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

class EditClinicController extends StateNotifier<EditClinicState> {
  EditClinicController() : super(const EditClinicState());

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  Timer? _debounce;
  Future<void> searchClinic({required String search, required int page}) async {
    try {
      final text = search.trim();

      if (text.length < 2) {
        state = state.copyWith(
          clinicDetails: [],
          isLoading: false,
          isPaginationLoading: false,
          page: 1,
          totalPages: 0,
          error: null,
        );
        return;
      }

      // Initial search
      if (page == 1) {
        state = state.copyWith(
          isLoading: true,
          isPaginationLoading: false,
          error: null,
        );
      } else {
        // Prevent multiple pagination calls
        if (state.isPaginationLoading) {
          return;
        }

        // No more pages
        if (page > state.totalPages) {
          return;
        }

        state = state.copyWith(isPaginationLoading: true, error: null);
      }

      final SearchClinicsDetailsResponseModel? response =
          await SearchClinicsApi.searchClinicsApi(search: text, page: page);

      if (response != null && response.success == true) {
        final newClinics = response.data ?? [];

        if (page == 1) {
          // First page -> replace old search result
          state = state.copyWith(
            clinicDetails: newClinics,
            page: page,
            totalPages: response.pagination?.totalPages ?? 0,
          );
        } else {
          // Next pages -> append
          state = state.copyWith(
            clinicDetails: [...state.clinicDetails, ...newClinics],
            page: page,
            totalPages: response.pagination?.totalPages ?? state.totalPages,
          );
        }
      } else {
        // Only clear list if page 1 failed
        if (page == 1) {
          state = state.copyWith(clinicDetails: [], page: 1, totalPages: 0);
        }
      }
    } catch (e) {
      log('Search clinic error: $e');

      // Don't remove already loaded data
      // when pagination fails.
      if (page == 1) {
        state = state.copyWith(
          clinicDetails: [],
          page: 1,
          totalPages: 0,
          error: e.toString(),
        );
      } else {
        state = state.copyWith(error: e.toString());
      }
    } finally {
      state = state.copyWith(isLoading: false, isPaginationLoading: false);
    }
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();

    final text = value.trim();

    if (text.length < 3) {
      state = state.copyWith(
        clinicDetails: [],
        isLoading: false,
        isPaginationLoading: false,
        error: null,
      );
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchClinic(search: text, page: 1);
    });
  }

  void clearSearch() {
    searchController.clear();

    state = state.copyWith(clinicDetails: [], isLoading: false, error: null);
  }

  //edit clinic api
  Future<bool> updateClinicApi({
    required BuildContext? context,
    required int id,
  }) async {
    try {
      state = state.copyWith(isSubmit: true);
      final formData = await createClinicFormData(
        clinicName: nameController.text.trim(),
        clinicPlace: placeController.text.trim(),
        selectedImage: state.selectedImage,
        networkImageUrl: state.networkImageUrl,
      );

      final response = await UpdateClinicApi.updateClinicApi(
        body: formData,
        context: context,
        id: id,
      );
      log('update clinic response: $response');

      if (response != null && response['success'] == true && context != null) {
        if (!context.mounted) return true;

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Clinic updation successfully',
              style: TextStyle(
                fontFamily: "Notche",
                color: AppColors.appWhite,
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
        return true;
      } else if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Clinic updation failed',
              style: TextStyle(
                fontFamily: "Notche",
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.appRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        return false;
      }
      // handle response
    } catch (e) {
      log(e.toString());
      return false;
    } finally {
      state = state.copyWith(isSubmit: false);
    }
    return false;
  }

  //form data creation
  Future<FormData> createClinicFormData({
    required String clinicName,
    required String clinicPlace,
    XFile? selectedImage,
    String? networkImageUrl,
  }) async {
    MultipartFile? clinicPhoto;

    // 1. User selected new image from gallery/camera
    if (selectedImage != null) {
      clinicPhoto = await MultipartFile.fromFile(
        selectedImage.path,
        filename: selectedImage.name,
      );
    }
    // 2. Existing searched clinic image
    else if (networkImageUrl != null && networkImageUrl.trim().isNotEmpty) {
      clinicPhoto = await networkImageToMultipart(networkImageUrl);
    }

    final formData = FormData.fromMap({
      'clinic_name': clinicName,
      'clinic_place': clinicPlace,

      // ignore: use_null_aware_elements
      if (clinicPhoto != null) 'clinic_photo': clinicPhoto,
    });

    return formData;
  }

  //select searched clinic
  void selectSearchedClinic(Datum clinic) {
    state = state.copyWith(
      networkImageUrl: clinic.clinicPhoto,
      clearSelectedImage: true,
      clinicDetails: [],
      isLoading: false,
      isPaginationLoading: false,
      error: null,
      clinicName: clinic.clinicName,
      clinicPlace: clinic.clinicPlace,
    );
    nameController.text = clinic.clinicName ?? '';
    placeController.text = clinic.clinicPlace ?? '';
    searchController.clear();
  }

  //select own image
  void ownImage(XFile image) {
    state = state.copyWith(clearNetworkImageUrl: true, selectedImage: image);
  }

  void onNameChanged(String value) {
    state = state.copyWith(clinicName: value);
  }

  void onPlaceChanged(String value) {
    state = state.copyWith(clinicPlace: value);
  }

  //delete photo
  void deletePhoto() {
    state = state.copyWith(
      clearNetworkImageUrl: true,
      clearSelectedImage: true,
    );
  }

  //initial call
  void initializeClinic(initial.Datum clinic) {
    nameController.text = clinic.clinicName ?? '';
    placeController.text = clinic.clinicPlace ?? '';

    state = state.copyWith(
      clinicName: clinic.clinicName ?? '',
      clinicPlace: clinic.clinicPlace ?? '',
      networkImageUrl: clinic.clinicPhoto,
      clearSelectedImage: true,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    log('===== update clinic screen disposed =====');
    super.dispose();
  }
}

final updateClinicProvider =
    StateNotifierProvider.autoDispose<EditClinicController, EditClinicState>(
      (ref) => EditClinicController(),
    );
