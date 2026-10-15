import 'dart:developer';
import 'dart:io';

import 'package:expense/core/services/dio_services/dio_client.dart';
import 'package:expense/core/services/global_listener/refresh_token_listener.dart';
import 'package:expense/core/storage/token_storage.dart';
import 'package:expense/core/themes/theme.dart';
import 'package:expense/presentation/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioClient.initialize();

  final String? url = await TokenStorage.getBaseUrl();

  if (url != null && url.isNotEmpty) {
    DioClient.setBaseUrl(url);

    log('Saved base URL: $url');
  } else {
    log('No saved base URL');
  }
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        navigatorKey: AppNavigator.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        themeMode: ThemeMode.system,
        theme: Apptheme.lighttheme.copyWith(
          scaffoldBackgroundColor: Apptheme.lighttheme.scaffoldBackgroundColor,
        ),
        darkTheme: Apptheme.darkTheme.copyWith(
          scaffoldBackgroundColor: Apptheme.darkTheme.scaffoldBackgroundColor,
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          log('SSL HOST: $host');
          log('SSL PORT: $port');

          return true;
        };

    return client;
  }
}
