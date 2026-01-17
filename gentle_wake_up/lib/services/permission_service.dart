import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PermissionService {
  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    // Android 12+ (API 31+) requires this
    if (await Permission.scheduleExactAlarm.isDenied) {
      // For exact alarms, we usually have to open settings
      // status is typically 'denied' if not granted, but for this specific permission
      // request() might not show a dialog, it usually requires opening settings.
      // However, let's try request() first or check the status.

      final status = await Permission.scheduleExactAlarm.status;
      if (status.isDenied) {
         // It seems for scheduleExactAlarm, we often need to send user to settings
         // but let's try request first just in case.
         final result = await Permission.scheduleExactAlarm.request();
         return result.isGranted;
      }
    }
    return await Permission.scheduleExactAlarm.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    // Android 13+ (API 33+)
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return await Permission.notification.isGranted;
  }

  Future<bool> requestBatteryOptimization() async {
    if (!Platform.isAndroid) return true;

    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      final status = await Permission.ignoreBatteryOptimizations.request();
      return status.isGranted;
    }
    return await Permission.ignoreBatteryOptimizations.isGranted;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }

  Future<Map<String, bool>> checkPermissions() async {
    if (!Platform.isAndroid) {
      return {
        'exactAlarm': true,
        'notification': true,
        'battery': true,
      };
    }

    return {
      'exactAlarm': await Permission.scheduleExactAlarm.isGranted,
      'notification': await Permission.notification.isGranted,
      'battery': await Permission.ignoreBatteryOptimizations.isGranted,
    };
  }
}
