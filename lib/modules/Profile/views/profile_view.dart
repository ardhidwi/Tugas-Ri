import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../routes/app_routes.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT (Tema Malam)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4B0082), // Ungu Tua
                  Color(0xFF1A0033), // Ungu Gelap
                ],
              ),
            ),
          ),

          // 2. KONTEN UTAMA
          SafeArea(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Profil Pengguna",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Avatar & Nama Section
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            controller.username.value,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // KARTU MENU
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // Tombol Edit
                          ListTile(
                            leading: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            title: const Text(
                              "Edit Profil",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            onTap: () => Get.toNamed(AppRoutes.EDIT_PROFILE),
                          ),

                          const Divider(color: Colors.white24),

                          // --- MENU BARU: NADA ALARM ---
                          ListTile(
                            leading: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                            ),
                            title: const Text(
                              "Nada Alarm",
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              "Pilih suara alam favorit Anda",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            onTap: () {
                              // Navigasi ke halaman picker lagu yang sudah dibuat
                              Get.toNamed('/song_picker');
                            },
                          ),

                          // -----------------------------
                          const Divider(color: Colors.white24),

                          // Mode Gelap Switch
                          ListTile(
                            leading: const Icon(
                              Icons.dark_mode,
                              color: Colors.white,
                            ),
                            title: const Text(
                              "Mode Gelap",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Switch(
                              value: controller.isDarkMode.value,
                              activeColor: const Color(
                                0xFFC85C7C,
                              ), // Pink senada
                              onChanged: controller.toggleTheme,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // TOMBOL KELUAR / KEMBALI
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFC85C7C,
                          ), // Pink senada
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Kembali ke Dashboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
