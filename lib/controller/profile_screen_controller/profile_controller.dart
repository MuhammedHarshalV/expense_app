import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/apis/user_related_api/get_profile_api.dart';
import 'package:expense/apis/user_related_api/update_user_api.dart';
import 'package:expense/controller/profile_screen_controller/profile_state.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/models/get_profile_details_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController() : super(const ProfileState()) {
    fetchProfile();
  }
  Future<void> fetchProfile() async {
    try {
      state = state.copyWith(isLoading: true);
      final GetProfileDetailsResponseModel response =
          await ProfileApi.getProfile();

      if (response.success == true && response.data != null) {
        state = state.copyWith(
          profileDetails: response.data,
          imageVersion: DateTime.now().millisecondsSinceEpoch,
        );
      }
    } catch (e, stackTrace) {
      log('Fetch profile error: $e', stackTrace: stackTrace);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  //update profile
  void updateProfileApi({
    bool? isPhoto,
    BuildContext? context,
    String? photoPath,
    String? name,
    String? email,
    String? dateOfBirth,
    String? gender,
    String? location,
    String? about,
  }) async {
    try {
      state = state.copyWith(isUpdate: true);
      final Map<String, dynamic> data = {};

      if (name != null) {
        data['user_name'] = name;
      }

      if (email != null) {
        data['user_email'] = email;
      }

      if (dateOfBirth != null) {
        data['date_of_birth'] = dateOfBirth;
      }

      if (gender != null) {
        data['user_gender'] = gender;
      }

      if (location != null) {
        data['user_location'] = location;
      }

      if (about != null) {
        data['user_about'] = about;
      }

      // Optional profile photo
      if (photoPath != null && photoPath.isNotEmpty) {
        data['user_profile_photo'] = await MultipartFile.fromFile(
          photoPath,
          filename: photoPath.split('/').last,
        );
      }

      final formData = FormData.fromMap(data);

      final response = await UpdateUserApi.updateUserApi(
        context: context,

        body: formData,
      );
      if (response.success == true) {
        state = state.copyWith(
          profileDetails: response.data,
          imageVersion: DateTime.now().millisecondsSinceEpoch,
        );
        if (context != null) {
          // ignore: use_build_context_synchronously
          if (isPhoto == null) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Profile updated successfully',
                style: TextStyle(
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
        }
      } else if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Profile updated failed',
              style: TextStyle(
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
      }
    } catch (e, stackTrace) {
      log('Update profile API error: $e', stackTrace: stackTrace);
    } finally {
      state = state.copyWith(isUpdate: false);
    }
  }

  @override
  void dispose() {
    log('===== profile screen disposed =====');
    super.dispose();
  }
}

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileController, ProfileState>(
      (ref) => ProfileController(),
    );
