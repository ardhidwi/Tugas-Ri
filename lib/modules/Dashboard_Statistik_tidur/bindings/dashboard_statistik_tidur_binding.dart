import 'package:get/get.dart';
import '../../alarm_tidur/controllers/alarm_tidur_controller.dart';
import '../controllers/dashboard_statistik_tidur_controller.dart';

class DashboardStatistikTidurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardStatistikTidurController>(
        () => DashboardStatistikTidurController());
    Get.lazyPut<AlarmTidurController>(() => AlarmTidurController());
  }
}
