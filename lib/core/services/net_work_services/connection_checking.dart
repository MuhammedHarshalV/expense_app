import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {
  static Future<bool> hasConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    log(connectivityResult.toString());

    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
