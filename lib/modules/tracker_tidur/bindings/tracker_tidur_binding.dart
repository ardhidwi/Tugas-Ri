import 'package:get/get.dart';
import '../controllers/tracker_tidur_controller.dart';

class TrackerTidurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackerTidurController>(() => TrackerTidurController());
  }
}
