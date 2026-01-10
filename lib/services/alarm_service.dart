import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'audio_service.dart';
import 'storage_service.dart';

class AlarmService {
  static const int _alarmId = 101;

  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  static Future<void> aturAlarm(DateTime waktu) async {
    await AndroidAlarmManager.oneShotAt(
      waktu,
      _alarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  static Future<void> batalkanAlarm() async {
    await AndroidAlarmManager.cancel(_alarmId);
    await AudioService.stopLagu();
  }
}

@pragma('vm:entry-point')
void alarmCallback() async {
  String lagu = await StorageService.ambilLagu();
  await AudioService.putarLagu(lagu);
}
