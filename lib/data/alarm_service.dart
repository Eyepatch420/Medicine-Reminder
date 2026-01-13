import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:flutter/services.dart';
import '../core/models/medicine.dart';
import 'hive_service.dart';

class AlarmService {
  static const _channel = MethodChannel("medicine_reminder/alarm_channel");

  static Future<void> initAlarm() async {
    await Alarm.init(showDebugLogs: true);

    // Listen for boot events via method channel
    _channel.setMethodCallHandler((call) async {
      if (call.method == "reschedule_alarms") {
        await rescheduleAllAlarms();
      }
    });
  }

  // Schedules a daily alarm for a medicine
  static Future<void> scheduleDailyAlarm(Medicine medicine) async {
    final now = DateTime.now();
    var alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      medicine.hour,
      medicine.minute,
    );

    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    final alarmId = medicine.id.hashCode.abs();

    final settings = AlarmSettings(
      id: alarmId,
      dateTime: alarmTime,
      assetAudioPath: 'assets/sounds/alarm.mp3',
      volume: 1.0,
      fadeDuration: 0.0,
      loopAudio: false,
      // 'repeat' parameter removed because the current alarm package version
      // does not support it. Repeating behavior is handled by rescheduling
      // alarms daily via the app logic.
      notificationTitle: 'Medicine Reminder',
      notificationBody: 'Time to take ${medicine.name} (${medicine.dosage})',
    );

    await Alarm.set(alarmSettings: settings);
  }

  static Future<void> cancelAlarm(String medicineId) async {
    final alarmId = medicineId.hashCode.abs();
    await Alarm.stop(alarmId);
  }

  static Future<void> rescheduleAllAlarms() async {
    final hive = HiveService();
    final medicines = hive.getMedicines();

    for (final med in medicines) {
      if (med.isActive) {
        await scheduleDailyAlarm(med);
      }
    }
  }
}
