import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tracker_tidur_controller.dart';

class TrackerTidurView extends GetView<TrackerTidurController> {
  const TrackerTidurView({super.key});

  @override
  Widget build(BuildContext context) {
    // Memastikan controller terinisialisasi
    final ctrl = Get.put(TrackerTidurController());

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT (Senada dengan Dashboard & Login)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4B0082), // Ungu Tua
                  Color(0xFF1A0033), // Ungu Gelap
                ],
              ),
            ),
          ),

          // 2. KONTEN UTAMA
          SafeArea(
            child: Column(
              children: [
                // Header Custom
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Tracker Tidur",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Obx(() {
                      bool isSleeping = ctrl.isSleeping.value;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Ilustrasi Ikon dengan Efek Glow saat Tidur
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSleeping
                                  ? Colors.blueAccent.withOpacity(0.1)
                                  : Colors.transparent,
                              boxShadow: isSleeping
                                  ? [
                                      BoxShadow(
                                        color: Colors.blueAccent.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 50,
                                        spreadRadius: 5,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Icon(
                              isSleeping
                                  ? Icons.nights_stay
                                  : Icons.wb_sunny_outlined,
                              size: 100,
                              color: isSleeping
                                  ? Colors.blueAccent
                                  : Colors.orangeAccent,
                            ),
                          ),

                          const SizedBox(height: 50),

                          // Tampilan Waktu (Format Stopwatch)
                          Text(
                            ctrl.formattedTime,
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),

                          Text(
                            isSleeping
                                ? "Sedang merekam tidur..."
                                : "Siap untuk tidur?",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 60),

                          // TOMBOL AKSI (Logika tetap sama)
                          SizedBox(
                            width: 250,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSleeping
                                    ? const Color(0xFFC85C7C) // Pink (Bangun)
                                    : const Color(0xFF4CAF50), // Hijau (Mulai)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 10,
                                shadowColor: isSleeping
                                    ? Colors.pinkAccent.withOpacity(0.5)
                                    : Colors.green.withOpacity(0.5),
                              ),
                              onPressed: () {
                                isSleeping
                                    ? ctrl.stopSleep()
                                    : ctrl.startSleep();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isSleeping
                                        ? Icons.alarm_off
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    isSleeping ? "BANGUN" : "MULAI TIDUR",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
