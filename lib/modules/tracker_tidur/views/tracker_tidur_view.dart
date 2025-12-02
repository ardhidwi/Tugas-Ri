import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tracker_tidur_controller.dart';

class TrackerTidurView extends GetView<TrackerTidurController> {
  const TrackerTidurView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F3FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sleep Tracker",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.formattedTime,
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  controller.isSleeping.isFalse
                      ? controller.startSleep()
                      : controller.stopSleep();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.isSleeping.isFalse ? Colors.green : Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  controller.isSleeping.isFalse ? "Mulai Tidur" : "Bangun",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
