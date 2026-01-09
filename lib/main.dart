import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// 1. TAMBAHKAN IMPORT ANALYTICS
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

// --- IMPORT SERVICE & VIEW ---
import 'services/audio_service.dart';
import 'services/storage_service.dart';
import 'views/song_picker_page.dart';
import 'modules/profile/controllers/profile_controller.dart';
import 'routes/app_routes.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    String laguPilihan = await StorageService.ambilLagu();
    await AudioService.putarLagu(laguPilihan);
  } catch (e) {
    print("Gagal memutar suara alarm: $e");
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'alarm_channel',
    'Alarm Notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    "Alarm Tidur",
    "Waktunya untuk bangun!",
    const NotificationDetails(android: androidDetails),
  );
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    alarmCallback();
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. INISIALISASI FIREBASE & ANALYTICS
  try {
    await Firebase.initializeApp();
    // Mengaktifkan koleksi data analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch (e) {
    print("Firebase init error: $e");
  }

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: const DarwinInitializationSettings(),
  );

  try {
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  } catch (e) {
    print("Notifikasi tidak didukung: $e");
  }

  Get.put(ProfileController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // 3. BUAT STATIC INSTANCE UNTUK ANALYTICS
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

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

      // 4. TAMBAHKAN NAVIGATOR OBSERVER
      // Ini akan mencatat otomatis setiap kali user pindah halaman
      navigatorObservers: [observer],

      initialRoute: FirebaseAuth.instance.currentUser != null
          ? AppRoutes.DASHBOARD_STATISTIK_TIDUR
          : AppRoutes.LOGIN,

      getPages: [
        ...AppRoutes.routes,
        GetPage(
          name: '/song_picker',
          page: () => const SongPickerPage(),
          transition: Transition.cupertino,
        ),
      ],
    );
  }
}
