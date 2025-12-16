import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tracker_tidur_controller.dart';

class TrackerTidurView extends GetView<TrackerTidurController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF3FF),
      appBar: AppBar(
        title: Text(
          'Tracker Tidur',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.formattedTime,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.isSleeping.value ? Colors.red : Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  controller.isSleeping.value
                      ? controller.stopSleep()
                      : controller.startSleep();
                },
                child: Text(
                  controller.isSleeping.value ? "Bangun" : "Mulai Tidur",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
