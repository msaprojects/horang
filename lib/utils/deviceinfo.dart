import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class GetDeviceID {
  Future<String?> getDeviceID(BuildContext context) async {
    DeviceInfoPlugin deviceinfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceinfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceinfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }
}
