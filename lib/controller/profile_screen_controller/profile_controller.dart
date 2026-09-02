import 'dart:developer';
import 'dart:io';

import 'package:expense/controller/profile_screen_controller/profile_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController() : super(const ProfileState()) {
    loadProfileImage();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? location,
    String? bio,
    String? dateOfBirth,
    String? gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Update only values that were provided
    if (name != null) {
      await prefs.setString('profile_name', name);
    }

    if (email != null) {
      await prefs.setString('profile_email', email);
    }

    if (phone != null) {
      await prefs.setString('profile_phone', phone);
    }

    if (location != null) {
      await prefs.setString('profile_location', location);
    }

    if (bio != null) {
      await prefs.setString('profile_bio', bio);
    }

    if (dateOfBirth != null) {
      await prefs.setString('profile_date_of_birth', dateOfBirth);
    }

    if (gender != null) {
      await prefs.setString('profile_gender', gender);
    }

    state = state.copyWith(
      name: name,
      email: email,
      phone: phone,
      profileImage: profileImage,
      location: location,
      bio: bio,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final extension = path.extension(imagePath);

      final savedPath = path.join(directory.path, 'profile_image$extension');

      final imageFile = File(imagePath);

      // Copy image to permanent app storage
      await imageFile.copy(savedPath);

      // Update state
      state = state.copyWith(profileImage: imagePath);

      // Save permanent path
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('profile_image_path', savedPath);

      log('Profile image saved: $savedPath');
    } catch (e) {
      log('Error saving profile image: $e');
    }
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    final path = prefs.getString('profile_image_path');

    if (path == null || path.isEmpty) {
      return;
    }

    final file = File(path);

    if (await file.exists()) {
      state = state.copyWith(profileImage: path);

      log('Profile image loaded: $path');
    } else {
      log('Profile image does not exist: $path');

      await prefs.remove('profile_image_path');
//
      state = state.copyWith(profileImage: '');
    }
    state = state.copyWith(
      name: prefs.getString('profile_name'),
      email: prefs.getString('profile_email'),
      phone: prefs.getString('profile_phone'),
      location: prefs.getString('profile_location'),
      bio: prefs.getString('profile_bio'),
      dateOfBirth: prefs.getString('profile_date_of_birth'),
      gender: prefs.getString('profile_gender'),
    );
  }

  @override
  void dispose() {
    log('===== profile screen disposed =====');
    super.dispose();
  }
}

final profileProvider = StateNotifierProvider<ProfileController, ProfileState>(
  (ref) => ProfileController(),
);
