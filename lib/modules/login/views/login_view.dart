import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepify_app/routes/app_routes.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  final controller = Get.put(LoginController());

  // Controller input
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9F3FF),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sleepify",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 30),

                // Email Field
                TextField(
                  controller: emailC,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Password Field
                TextField(
                  controller: passC,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Button Login Dengan Loading
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.isFalse
                          ? () {
                              controller.login(
                                emailC.text,
                                passC.text,
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.isFalse
                          ? Text(
                              "Login",
                              style: TextStyle(fontSize: 18),
                            )
                          : CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                    )),

                const SizedBox(height: 20),

                // 🔹 Tambahan Tombol Ke Register Page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum punya akun?"),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.REGISTER);
                      },
                      child: Text(
                        "Daftar di sini",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
