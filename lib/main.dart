import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart'; // Tambahkan ini
import 'package:firebase_auth/firebase_auth.dart'; // Tambahkan ini
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

// --- IMPORT SERVICE & VIEW ---
import 'services/audio_service.dart';
import 'services/storage_service.dart';
import 'views/song_picker_page.dart';
import 'modules/profile/controllers/profile_controller.dart';
import 'routes/app_routes.dart';

// Inisialisasi plugin notifikasi secara global
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Fungsi ini berjalan di background saat waktu alarm tiba
@pragma('vm:entry-point')
void alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding siap di isolate terpisah

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

  // 1. INISIALISASI FIREBASE
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase init error: $e");
  }

  // Inisialisasi Service Background (Hanya untuk Android)
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  // Inisialisasi Notifikasi
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

  // REGISTER PROFILE CONTROLLER GLOBAL
  Get.put(ProfileController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

      // 2. LOGIKA AUTO LOGIN
      // Jika FirebaseAuth mendeteksi ada user yang aktif, langsung ke Dashboard.
      // Jika tidak ada user, arahkan ke halaman Login.
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
