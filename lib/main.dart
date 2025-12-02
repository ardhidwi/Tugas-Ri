import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

// Controller Profil
import 'modules/profile/controllers/profile_controller.dart';

// ROUTES
import 'routes/app_routes.dart';

// Notifikasi Plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background Alarm Callback
@pragma('vm:entry-point')
void alarmCallback() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'alarm_channel',
    'Alarm Notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    "Alarm Tidur",
    "Waktunya untuk bangun!",
    platformDetails,
  );
}

// Main Function
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Jalankan service hanya di Android
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  // Initialize Notification
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // REGISTER PROFILE CONTROLLER GLOBAL
  Get.put(ProfileController(), permanent: true);

  runApp(MyApp());
}

// WorkManager Callback
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    alarmCallback();
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sleepify App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),

      // ⬇️ MULAI DARI LOGIN, lalu diarahkan ke HOME_NAV setelah login berhasil
      initialRoute: AppRoutes.LOGIN,

      getPages: AppRoutes.routes,
    );
  }
}
