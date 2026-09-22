import 'package:expense/core/services/dio_services/dio_client.dart';
import 'package:expense/core/services/global_listener/refresh_token_listener.dart';
import 'package:expense/core/themes/theme.dart';
import 'package:expense/presentation/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioClient.initialize();

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
