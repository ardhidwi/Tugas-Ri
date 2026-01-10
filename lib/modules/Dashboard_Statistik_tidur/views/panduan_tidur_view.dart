import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PanduanTidurView extends StatelessWidget {
  const PanduanTidurView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna yang senada dengan tema dashboard Anda
      backgroundColor: const Color(0xFF13003B),
      appBar: AppBar(
        title: const Text(
          "Panduan Tidur Sehat",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tips untuk Tidur Lebih Nyenyak",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildTipsCard(
              Icons.timer,
              "Jadwal Konsisten",
              "Tidurlah dan bangun pada waktu yang sama setiap hari, bahkan di akhir pekan.",
            ),
            const SizedBox(height: 15),
            _buildTipsCard(
              Icons.phonelink_off,
              "Kurangi Cahaya Biru",
              "Hindari penggunaan HP atau laptop minimal 30 menit sebelum tidur karena mengganggu melatonin.",
            ),
            const SizedBox(height: 15),
            _buildTipsCard(
              Icons.ac_unit,
              "Suhu Kamar Ideal",
              "Pastikan kamar Anda memiliki suhu yang sejuk (sekitar 18-22°C) untuk kenyamanan maksimal.",
            ),
            const SizedBox(height: 15),
            _buildTipsCard(
              Icons.no_food,
              "Hindari Makan Berat",
              "Jangan mengonsumsi makanan berat atau kafein menjelang waktu tidur Anda.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard(IconData icon, String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
