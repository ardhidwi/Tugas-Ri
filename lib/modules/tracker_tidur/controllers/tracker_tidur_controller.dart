import 'package:get/get.dart';
import 'dart:async';

class TrackerTidurController extends GetxController {
  RxBool isSleeping = false.obs;
  RxInt seconds = 0.obs;
  Timer? timer;

  void startSleep() {
    isSleeping.value = true;
    seconds.value = 0;

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      seconds.value++;
    });
  }

  void stopSleep() {
    isSleeping.value = false;
    timer?.cancel();
  }

  String get formattedTime {
    int h = seconds.value ~/ 3600;
    int m = (seconds.value % 3600) ~/ 60;
    int s = seconds.value % 60;
    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }
}
