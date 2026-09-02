import 'package:expense/controller/splash_controller/splash_controller.dart';
import 'package:expense/controller/splash_controller/splash_state.dart';
import 'package:expense/presentation/screens/bottom_nav_screen/screen/bottom_nav_screen.dart';
import 'package:expense/presentation/screens/login_screen/screen/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SplashState>(splashProvider, (previous, next) {
      if (next.navigationScreen == SplashNavigationState.homeScreen) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavScreen()),
          (_) => false,
        );
      } else if (next.navigationScreen == SplashNavigationState.loginScreen) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: Brightness.light, // icons = white
        statusBarBrightness: Brightness.dark, // for iOS
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                'asset/lottie/finance.json',
                width: double.infinity,
                // height: 00,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
