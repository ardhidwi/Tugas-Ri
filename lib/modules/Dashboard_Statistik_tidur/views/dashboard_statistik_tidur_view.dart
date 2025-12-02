import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sleepify_app/modules/home_nav/controllers/home_nav_controller.dart';
import '../../../routes/app_routes.dart';
import '../controllers/dashboard_statistik_tidur_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../tracker_tidur/views/tracker_tidur_view.dart';
import '../../alarm_tidur/views/alarm_tidur_view.dart';
import '../../profile/views/profile_view.dart';
// HomeNavController imported via package import above

class DashboardStatistikTidurView
    extends GetView<DashboardStatistikTidurController> {
  const DashboardStatistikTidurView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    final profile = Get.find<ProfileController>();
    final navCtrl = Get.put(HomeNavController());

    return Obx(() => Scaffold(
          backgroundColor: const Color(0xFFE9F3FF),
          body: _getBody(navCtrl.selectedIndex.value, ctrl, profile, context),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navCtrl.selectedIndex.value,
            onTap: navCtrl.changePage,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.nights_stay), label: 'Tracker'),
              BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarm'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ));
  }

  Widget _getBody(int index, DashboardStatistikTidurController ctrl, profile,
      BuildContext context) {
    switch (index) {
      case 0:
        return _buildDashboardBody(ctrl, profile, context);
      case 1:
        return TrackerTidurView();
      case 2:
        return AlarmTidurView();
      case 3:
        return ProfileView();
      default:
        return _buildDashboardBody(ctrl, profile, context);
    }
  }

  Widget _buildDashboardBody(
      DashboardStatistikTidurController ctrl, profile, BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F3FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Statistik Tidur",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Edit Profil',
            onPressed: () => Get.toNamed(AppRoutes.EDIT_PROFILE),
            icon: const Icon(Icons.edit, color: Colors.black54),
          ),
          IconButton(
            tooltip: 'Atur Alarm',
            onPressed: () => Get.toNamed(AppRoutes.ALARM_TIDUR),
            icon: const Icon(Icons.alarm, color: Colors.black54),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- User Info Card ---
            Obx(() => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black12,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blueAccent,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Selamat Datang,",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                          Text(profile.username.value,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent)),
                        ],
                      ),
                    ],
                  ),
                )),
            // --- Statistik Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                      offset: Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 90,
                    percent: (ctrl.qualityScore.value.toDouble() / 100.0)
                        .clamp(0.0, 1.0),
                    progressColor: Colors.blueAccent,
                    lineWidth: 12,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text("${ctrl.qualityScore.value}%",
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ),
                  const SizedBox(height: 20),
                  const Text("Kualitas Tidur",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // --- Statistik kecil ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard(
                    icon: Icons.nights_stay,
                    title: "Jam Tidur",
                    value:
                        "${ctrl.totalSleepHours.value.toStringAsFixed(1)} jam"),
                _statCard(
                    icon: Icons.bar_chart,
                    title: "Efisiensi",
                    value: "${ctrl.qualityScore.value}%"),
              ],
            ),
            const SizedBox(height: 20),
            _statCard(
                icon: Icons.bedtime,
                title: "Durasi Ideal",
                value: "8 Jam / Hari",
                fullWidth: true),
            const SizedBox(height: 30),
            // ... Lanjutkan semua widget lainnya sama seperti sebelumnya
            // Tracker, Riwayat, Rekomendasi Jam Tidur, Statistik Bulanan, Logout
          ],
        ),
      ),
    );
  }

  Widget _statCard(
      {required IconData icon,
      required String title,
      required String value,
      bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(blurRadius: 10, color: Colors.black12, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.blueAccent),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent)),
        ],
      ),
    );
  }
}
