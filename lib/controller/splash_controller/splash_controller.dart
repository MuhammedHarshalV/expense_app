import 'dart:developer';

import 'package:expense/controller/splash_controller/splash_state.dart';

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
      return state = state.copyWith(
        navigationScreen: SplashNavigationState.loginScreen,
      );
    });
  }

  //refresh token api calling
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
