import 'package:get/get.dart';
import '../controllers/alarm_tidur_controller.dart';

class AlarmTidurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmTidurController>(() => AlarmTidurController());
  }
}
