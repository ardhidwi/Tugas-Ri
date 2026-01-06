import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  void register() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        usernameController.text.isEmpty) {
      Get.snackbar("Error", "Semua kolom harus diisi");
      return;
    }

    isLoading.value = true;

    // Memanggil fungsi registerUser yang menyimpan data ke Auth & Firestore
    String? result = await _authService.registerUser(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      username: usernameController.text.trim(),
    );

    isLoading.value = false;

    if (result == "success") {
      Get.snackbar("Berhasil", "Akun berhasil dibuat!");
      Get.offAllNamed(AppRoutes.DASHBOARD_STATISTIK_TIDUR);
    } else {
      Get.snackbar("Registrasi Gagal", result ?? "Terjadi kesalahan");
    }
  }
}
