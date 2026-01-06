import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart'; // Import AuthService yang baru dibuat

class LoginController extends GetxController {
  // Tambahkan controller untuk menangkap input dari UI
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  void login() async {
    // Validasi input kosong
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email dan Password tidak boleh kosong");
      return;
    }

    isLoading.value = true;

    // Memanggil fungsi login dari AuthService
    String? result = await _authService.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    isLoading.value = false;

    if (result == "success") {
      Get.snackbar("Status", "Login berhasil!");
      // Pastikan rute ini sesuai dengan yang ada di app_routes.dart Anda
      Get.offAllNamed(AppRoutes.DASHBOARD_STATISTIK_TIDUR);
    } else {
      // Menampilkan pesan error asli dari Firebase (misal: password salah)
      Get.snackbar("Login Gagal", result ?? "Terjadi kesalahan");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
