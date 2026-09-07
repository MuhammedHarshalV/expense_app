import 'dart:developer';

import 'package:expense/apis/auth_api/refresh_token_api.dart';
import 'package:expense/controller/splash_controller/splash_state.dart';
import 'package:expense/core/storage/token_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class SplashNotifierController extends StateNotifier<SplashState> {
  SplashNotifierController() : super(const SplashState()) {
    _initialize();
  }
  @override
  void dispose() {
    log('======= Splash controller disposed ========');
    super.dispose();
  }

  Future<void> _initialize() async {
    await Future.wait([checkInitialRoute()]);
  }

  Future<void> checkInitialRoute() async {
    await Future.delayed(const Duration(seconds: 2)).then((value) async {
      //await checkAndArchiveMonth();
      await refreshTokenTesting();
    });
  }

  //refresh token api calling
  Future<void> refreshTokenTesting() async {
    try {
      // Get refresh token from secure storage
      final refreshToken = await TokenStorage.getRefreshToken();
      log('refresh token : $refreshToken');
      // No refresh token -> Login
      if (refreshToken == null || refreshToken.isEmpty) {
        _goToLogin();
        return;
      }

      // Call refresh token API
      final response = await RefreshTokenApi.refreshTokenApi(
        context: null,
        body: {'refresh_token': refreshToken},
      );

      if (response.isNetworkError == true) {
        state = state.copyWith(
          navigationScreen: SplashNavigationState.homeScreen,
        );

        return;
      }
      if (response.statusCode == 401) {
        await TokenStorage.clear();

        _goToLogin();

        return;
      }
      // Refresh success
      if (response.data['success'] == true) {
        final newAccessToken = response.data['data']['access_token'];

        final newRefreshToken = response.data['data']['refresh_token'];

        if (newAccessToken == null || newAccessToken.toString().isEmpty) {
          log('2');

          await _clearAndLogin();
          return;
        }

        // Save both tokens
        await TokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken ?? refreshToken,
        );

        // Navigate to home
        state = state.copyWith(
          navigationScreen: SplashNavigationState.homeScreen,
        );
        log('3');

        return;
      }

      state = state.copyWith(
        navigationScreen: SplashNavigationState.homeScreen,
      );
      log('4');
    } catch (e, stackTrace) {
      log('Splash refresh token error: $e', stackTrace: stackTrace);
      state = state.copyWith(
        navigationScreen: SplashNavigationState.homeScreen,
      );
      log('5');
    }
  }

  void _goToLogin() {
    state = state.copyWith(navigationScreen: SplashNavigationState.loginScreen);
  }

  Future<void> _clearAndLogin() async {
    await TokenStorage.clear();

    _goToLogin();
  }
}

final splashProvider =
    StateNotifierProvider.autoDispose<SplashNotifierController, SplashState>((
      ref,
    ) {
      return SplashNotifierController();
    });

final splashScreenProvider = Provider<SplashNavigationState>((ref) {
  return ref.watch(splashProvider).navigationScreen;
});
