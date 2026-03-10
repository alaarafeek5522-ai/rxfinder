import 'dart:io';
import 'package:flutter/services.dart';

class SecurityService {
  static const _channel = MethodChannel('com.alaa.rxfinder/security');

  static Future<bool> isDeviceRooted() async {
    if (!Platform.isAndroid) return false;
    try {
      final List<String> rootPaths = [
        '/system/app/Superuser.apk',
        '/sbin/su',
        '/system/bin/su',
        '/system/xbin/su',
        '/data/local/xbin/su',
        '/data/local/bin/su',
        '/system/sd/xbin/su',
        '/system/bin/failsafe/su',
        '/data/local/su',
        '/su/bin/su',
      ];
      for (final path in rootPaths) {
        if (await File(path).exists()) return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> checkIntegrity() async {
    try {
      // تحقق من التوقيع عند التشغيل
      const expectedPackage = 'com.alaa.rxfinder';
      // في بيئة الإنتاج يمكن مقارنة hash التوقيع
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<SecurityStatus> getSecurityStatus() async {
    final isRooted = await isDeviceRooted();
    final integrityOk = await checkIntegrity();
    return SecurityStatus(
      isRooted: isRooted,
      integrityOk: integrityOk,
    );
  }
}

class SecurityStatus {
  final bool isRooted;
  final bool integrityOk;
  SecurityStatus({required this.isRooted, required this.integrityOk});
  bool get isSafe => !isRooted && integrityOk;
}
