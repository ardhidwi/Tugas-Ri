import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../../../main.dart'; // untuk akses notifier

class AlarmTidurController extends GetxController {
  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  RxBool isAlarmActive = false.obs;
  RxString alarmStatus = "Alarm belum diatur".obs;

  // Set alarm ke background
  Future<void> setAlarm(DateTime alarmDateTime) async {
    isAlarmActive.value = true;
    alarmStatus.value =
        "Alarm diatur: ${alarmDateTime.hour}:${alarmDateTime.minute}";

    await AndroidAlarmManager.oneShotAt(
      alarmDateTime,
      1,
      alarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  Future<void> cancelAlarm() async {
    await AndroidAlarmManager.cancel(1);
    isAlarmActive.value = false;
    alarmStatus.value = "Alarm dinonaktifkan";
  }

  // Pilih jam via UI
  void updateSleepTime(TimeOfDay time) {
    selectedTime.value = time;
  }
}
