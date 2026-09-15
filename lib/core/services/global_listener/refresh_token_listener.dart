import 'package:expense/presentation/screens/login_screen/screen/login_screen.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void goToLogin({bool? isLogout}) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) =>
            LoginScreen(isRefreshExpired: isLogout == null ? true : null),
      ),
      (route) => false,
    );
  }
}
