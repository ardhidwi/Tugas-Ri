import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/alarm_tidur_controller.dart';

class AlarmTidurView extends GetView<AlarmTidurController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarm Tidur"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() => Text(
                  controller.alarmStatus.value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  controller.updateSleepTime(pickedTime);

                  final now = DateTime.now();
                  final alarmDate = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  controller.setAlarm(
                    alarmDate.isBefore(now)
                        ? alarmDate.add(Duration(days: 1))
                        : alarmDate,
                  );
                }
              },
              child: Text("Atur Jam Alarm"),
            ),
            const SizedBox(height: 15),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Status Alarm: "),
                    Switch(
                      value: controller.isAlarmActive.value,
                      onChanged: (value) {
                        if (value) {
                          if (controller.selectedTime.value != null) {
                            final now = DateTime.now();
                            final t = controller.selectedTime.value!;
                            controller.setAlarm(DateTime(
                              now.year,
                              now.month,
                              now.day,
                              t.hour,
                              t.minute,
                            ));
                          } else {
                            Get.snackbar("Pilih Jam",
                                "Silahkan pilih jam alarm terlebih dahulu!");
                          }
                        } else {
                          controller.cancelAlarm();
                        }
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
