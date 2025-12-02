import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  RxString username = "Pengguna".obs;
  RxBool isDarkMode = false.obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void updateUsername(String newName) {
    username.value = newName;
  }
}
