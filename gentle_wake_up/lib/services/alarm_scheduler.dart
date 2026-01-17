import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:gentle_wake_up/services/background_callback.dart';
import 'package:gentle_wake_up/models/alarm.dart';

class AlarmScheduler {
  static Future<void> scheduleAlarm(Alarm alarm) async {
    // Generate a unique integer ID for the alarm scheduler based on the UUID hash
    // We use the same ID so we can cancel it later if needed.
    final int alarmId = alarm.id.hashCode;

    // Calculate trigger time: 30 minutes before the alarm time
    DateTime triggerTime = alarm.time.subtract(const Duration(minutes: 30));

    // If the alarm is repeating or in the past, we need logic to find the next occurrence.
    // The current Alarm model has 'time' as a specific Date+Time.
    // If it's in the past, we assume it's for tomorrow (simple logic for now,
    // usually Alarm app handles this by updating the 'time' property).
    // However, if the user sets an alarm for 8:00 AM and it's 7:50 AM,
    // triggerTime (7:30 AM) is in the past.

    if (triggerTime.isBefore(DateTime.now())) {
      // If the 30-min-before mark is passed but the actual alarm is still in future
      if (alarm.time.isAfter(DateTime.now())) {
         // Start immediately (or with a small delay)
         triggerTime = DateTime.now().add(const Duration(seconds: 5));
      } else {
         // The alarm itself is in the past. If repeat is on, schedule for next day?
         // For this simple implementation, if 'time' is absolute, we assume the provider updated it.
         // If we must schedule it, ensure it's in the future.
         return;
      }
    }

    await AndroidAlarmManager.oneShotAt(
      triggerTime,
      alarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
      alarmClock: true,
      rescheduleOnReboot: true,
    );
  }

  static Future<void> cancelAlarm(Alarm alarm) async {
    final int alarmId = alarm.id.hashCode;
    await AndroidAlarmManager.cancel(alarmId);
  }
}
