import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  void login(String email, String password) {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;

      // Snackbar setelah login berhasil
      Get.snackbar("Status", "Login berhasil!");

      // Arahkan ke Dashboard
      Get.offAllNamed(AppRoutes.DASHBOARD_STATISTIK_TIDUR);
    });
  }
}
