import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/alarm_tidur_controller.dart';

class AlarmTidurView extends GetView<AlarmTidurController> {
  const AlarmTidurView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller jika belum terdaftar
    final ctrl = Get.put(AlarmTidurController());

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT (Tema Malam)
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // Header dengan tombol back kustom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const Text(
                        "Alarm Tidur",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 48), // Agar teks tetap di tengah
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Ikon Alarm dengan Efek Glow
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.2),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.alarm,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // STATUS ALARM (Pesan Status)
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        ctrl.alarmStatus.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // KARTU PENGATURAN ALARM
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        // Tombol Pilih Jam
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFC85C7C,
                              ), // Pink senada tombol Login
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            icon: const Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "ATUR JAM ALARM",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                ctrl.updateSleepTime(pickedTime);
                                final now = DateTime.now();
                                final alarmDate = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );

                                ctrl.setAlarm(
                                  alarmDate.isBefore(now)
                                      ? alarmDate.add(const Duration(days: 1))
                                      : alarmDate,
                                );
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 10),

                        // Switch On/Off Alarm
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Status Alarm",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    ctrl.isAlarmActive.value
                                        ? "Aktif"
                                        : "Non-Aktif",
                                    style: TextStyle(
                                      color: ctrl.isAlarmActive.value
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: ctrl.isAlarmActive.value,
                                activeColor: const Color(0xFFC85C7C),
                                onChanged: (value) {
                                  if (value) {
                                    if (ctrl.selectedTime.value != null) {
                                      final now = DateTime.now();
                                      final t = ctrl.selectedTime.value!;
                                      ctrl.setAlarm(
                                        DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          t.hour,
                                          t.minute,
                                        ),
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Pilih Jam",
                                        "Silahkan pilih jam alarm terlebih dahulu!",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.white,
                                      );
                                    }
                                  } else {
                                    ctrl.cancelAlarm();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Pastikan volume perangkat Anda cukup keras\nagar alarm terdengar saat waktunya bangun.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
