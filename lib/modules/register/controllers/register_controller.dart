import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;

  void register() {
    // logic register (dummy)
    Get.offAllNamed(AppRoutes.DASHBOARD_STATISTIK_TIDUR);
  }
}
