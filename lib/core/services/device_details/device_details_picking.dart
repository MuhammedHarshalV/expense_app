import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdPicking {
  static Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String serialid = androidInfo.serialNumber;
      String fingerPrint = androidInfo.fingerprint;

      log("Device Serial ID : ${serialid.toString()}");
      log("Device fingerprint ID : ${fingerPrint.toString()}");
      log('===============${androidInfo.id.toString()}');
      return androidInfo.id; // device id
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.identifierForVendor ?? '';
    }

    return '';
  }
}
