import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepify/routes/app_routes.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  // Inisialisasi controller
  final LoginController controller = Get.put(LoginController());

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4B0082), Color(0xFF1A0033)],
              ),
            ),
          ),

          // 2. KONTEN UTAMA
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const Text(
                      "Sleeplify",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- BAGIAN LOGO LOKAL (MENGGANTIKAN IMAGE.NETWORK) ---
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.15),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png', // Aset lokal sesuai pubspec.yaml
                        fit: BoxFit.contain,
                      ),
                    ),

                    // -------------------------------------------------------
                    const SizedBox(height: 40),

                    // Input Fields
                    _buildLabel("Email"),
                    _buildTextField(
                      controller: controller.emailController,
                      hint: "Enter your email...",
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("Password"),
                    _buildTextField(
                      controller: controller.passwordController,
                      hint: "Enter your password...",
                      isPassword: true,
                    ),

                    // Remember Me & Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: true,
                              onChanged: (v) {},
                              activeColor: Colors.white,
                              activeTrackColor: Colors.grey,
                            ),
                            const Text(
                              "Remember me",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.REGISTER),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade400,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tombol Masuk dengan Obx
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.isFalse
                              ? () => controller.login()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC85C7C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isLoading.isFalse
                              ? const Text(
                                  "Masuk",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                )
                              : const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "Or login with",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 15),

                    // Social Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialButton(Icons.g_mobiledata, Colors.grey.shade800),
                        _socialButton(Icons.apple, Colors.grey.shade800),
                        _socialButton(Icons.facebook, Colors.grey.shade800),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper UI
  Widget _buildLabel(String label) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword
              ? const Icon(Icons.visibility_off_outlined, color: Colors.grey)
              : null,
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) => Container(
    width: 80,
    height: 50,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: Colors.white, size: 30),
  );
}
