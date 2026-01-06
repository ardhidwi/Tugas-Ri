import 'package:get/get.dart';
import '../controllers/home_nav_controller.dart';

class HomeNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeNavController>(() => HomeNavController());
  }
}
