import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepify/modules/home_nav/controllers/home_nav_controller.dart';
import '../../../routes/app_routes.dart';
import '../controllers/dashboard_statistik_tidur_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../tracker_tidur/views/tracker_tidur_view.dart';
import '../../alarm_tidur/views/alarm_tidur_view.dart';
import '../../profile/views/profile_view.dart';
import '../../tracker_tidur/controllers/tracker_tidur_controller.dart';
// IMPORT INI PENTING UNTUK MEMPERBAIKI ERROR
import '../../alarm_tidur/controllers/alarm_tidur_controller.dart';

class DashboardStatistikTidurView
    extends GetView<DashboardStatistikTidurController> {
  const DashboardStatistikTidurView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    final profile = Get.find<ProfileController>();
    final navCtrl = Get.put(HomeNavController());

    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            // BACKGROUND GRADIENT (Tema Malam sesuai gambar)
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
            _getBody(navCtrl.selectedIndex.value, ctrl, profile, context),
          ],
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(canvasColor: const Color(0xFF1A0033)),
          child: BottomNavigationBar(
            currentIndex: navCtrl.selectedIndex.value,
            onTap: navCtrl.changePage,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                label: 'STATS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alarm_outlined),
                label: 'ALARM',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'PROFILE',
              ),
            ],
          ),
        ),
        // Expert Advice Floating Button (Sesuai Gambar)
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: Colors.blueAccent,
          label: const Text("EXPERT ADVICE", style: TextStyle(fontSize: 10)),
          icon: const Icon(Icons.chat_bubble_outline),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _getBody(
    int index,
    DashboardStatistikTidurController ctrl,
    profile,
    BuildContext context,
  ) {
    switch (index) {
      case 0:
        return _buildDashboardBody(ctrl, profile, context);
      case 1:
        if (!Get.isRegistered<TrackerTidurController>()) {
          Get.lazyPut(() => TrackerTidurController());
        }
        return TrackerTidurView();
      case 2:
        // SOLUSI ERROR: Daftarkan controller secara manual jika belum ada
        if (!Get.isRegistered<AlarmTidurController>()) {
          Get.put(AlarmTidurController());
        }
        return AlarmTidurView();
      case 3:
        return const ProfileView();
      default:
        return _buildDashboardBody(ctrl, profile, context);
    }
  }

  Widget _buildDashboardBody(
    DashboardStatistikTidurController ctrl,
    profile,
    BuildContext context,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () => Get.offAllNamed(AppRoutes.LOGIN),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Grafik Placeholder
            const Center(
              child: Icon(Icons.auto_graph, color: Colors.white54, size: 150),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildSmallCard(
                    "Peningkatan Bulanan",
                    "32%",
                    Colors.greenAccent,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildSmallCard(
                    "Perubahan Mingguan",
                    "-26%",
                    Colors.redAccent,
                    Icons.trending_down,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Card Tidur Semalam
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.pink],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tidur Semalam",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "6h 37m",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Info Masalah Tidur
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Apakah ada masalah\nTidur?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/3069/3069172.png',
                  height: 80,
                ),
              ],
            ),
            const SizedBox(height: 80), // Ruang agar FAB tidak menutupi konten
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
