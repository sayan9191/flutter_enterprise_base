import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract final class DeviceHelper {
  static Future<String> get deviceName async {
    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      return '${android.manufacturer} ${android.model}';
    }
    if (Platform.isIOS) {
      final ios = await info.iosInfo;
      return ios.utsname.machine;
    }
    return 'Unknown';
  }

  static Future<String> get appVersion async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version}+${info.buildNumber}';
  }

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
}
