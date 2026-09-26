import 'dart:developer';

import 'package:expense/apis/auth_api/login_api.dart';
import 'package:expense/controller/login_controller/login_state.dart';

import 'package:expense/core/errors/app_message.dart';
import 'package:expense/core/services/dio_services/dio_client.dart';

import 'package:expense/presentation/screens/bottom_nav_screen/screen/bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(const LoginState());

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController baseUrlController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  //login api
  Future<void> login({required BuildContext context}) async {
    if (phoneController.text.trim().isEmpty) {
      AppMessage.show(context, 'Please enter your mobile number');
      return;
    }

    if (pinController.text.trim().isEmpty) {
      AppMessage.show(context, 'Please enter your PIN');
      return;
    }
    if (baseUrlController.text.trim().isEmpty) {
      AppMessage.show(context, 'Please enter your Base URL');
      return;
    }

    try {
      state = state.copyWith(isSubmit: true);
      final baseUrl = baseUrlController.text.trim();

      if (baseUrl.isEmpty) {
        AppMessage.show(context, 'Please enter Base URL');
        return;
      }

      // Login needs to use entered URL
      DioClient.setBaseUrl(baseUrl);

      final response = await SignInChecking.signInChecking(
        context: context,
        url: baseUrl,
        body: {
          'user_phone_number': phoneController.text.trim(),
          'user_pin': pinController.text.trim(),
        },
      );

      if (response.data['success'] == false) return;

      if (!context.mounted) return;

      if (response.data['success'] == true &&
          response.data['message'] == 'Login successful') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavScreen()),
          (_) => false,
        );
      }
    } catch (e, stackTrace) {
      log('Login error: $e', stackTrace: stackTrace);

      if (context.mounted) {
        AppMessage.show(context, 'Something went wrong. Please try again.');
      }
    } finally {
      state = state.copyWith(isSubmit: false);
    }
  }

  //update sate
  void updateState({bool? isSee}) {
    state = state.copyWith(isSee: isSee);
  }

  @override
  void dispose() {
    phoneController.dispose();
    pinController.dispose();
    super.dispose();
  }
}

final loginProvider = StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(),
);
