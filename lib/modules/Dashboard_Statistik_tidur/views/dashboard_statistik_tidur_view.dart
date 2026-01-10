import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sleepify/modules/home_nav/controllers/home_nav_controller.dart';
import '../../../routes/app_routes.dart';
import '../controllers/dashboard_statistik_tidur_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../tracker_tidur/views/tracker_tidur_view.dart';
import '../../alarm_tidur/views/alarm_tidur_view.dart';
import '../../profile/views/profile_view.dart';
import '../../tracker_tidur/controllers/tracker_tidur_controller.dart';
import '../../alarm_tidur/controllers/alarm_tidur_controller.dart';
import 'panduan_tidur_view.dart';

class DashboardStatistikTidurView
    extends GetView<DashboardStatistikTidurController> {
  const DashboardStatistikTidurView({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.put(HomeNavController());
    final ctrl = controller;

    // Inisialisasi ProfileController secara aman
    final profile = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Obx(
      () => Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            // Background Gradient Utama
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF31007E), Color(0xFF13003B)],
                ),
              ),
            ),
            _getBody(navCtrl.selectedIndex.value, ctrl, profile, context),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(navCtrl),
      ),
    );
  }

  // --- LOGIKA PERPINDAHAN HALAMAN NAVIGASI ---
  Widget _getBody(int index, ctrl, profile, context) {
    switch (index) {
      case 0:
        return _buildDashboardBody(ctrl, profile, context);
      case 1:
        if (!Get.isRegistered<TrackerTidurController>())
          Get.lazyPut(() => TrackerTidurController());
        return TrackerTidurView();
      case 2:
        if (!Get.isRegistered<AlarmTidurController>())
          Get.put(AlarmTidurController());
        return AlarmTidurView();
      case 3:
        return const ProfileView();
      default:
        return _buildDashboardBody(ctrl, profile, context);
    }
  }

  // --- TAMPILAN UTAMA DASHBOARD ---
  Widget _buildDashboardBody(ctrl, profile, context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildCustomAppBar(),
            const SizedBox(height: 25),
            _buildMainChartCard(), // Grafik Line Chart
            const SizedBox(height: 20),
            _buildSecondaryStats(), // Card Kembar (Persentase)
            const SizedBox(height: 20),
            _buildSleepDurationCard(), // Card Oranye Durasi Tidur
            const SizedBox(height: 20),
            _buildProblemSection(), // Masalah Tidur & Koala
            const SizedBox(height: 110), // Spasi agar tidak tertutup Nav Bar
          ],
        ),
      ),
    );
  }

  // --- APP BAR: JUDUL DI TENGAH & LOGOUT DI KANAN ---
  Widget _buildCustomAppBar() {
    return Row(
      children: [
        // Spacer kiri seukuran tombol kanan agar judul benar-benar di tengah
        const SizedBox(width: 44),

        const Expanded(
          child: Center(
            child: Text(
              "Dashboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Tombol Logout Ikon Panah
        _appBarButton(Icons.logout, _showLogoutDialog),
      ],
    );
  }

  // DIALOG KONFIRMASI LOGOUT
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF13003B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Konfirmasi Logout",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Apakah Anda yakin ingin keluar dari Sleepify?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal", style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Get.offAllNamed(AppRoutes.LOGIN),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _appBarButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  // --- GRAFIK UTAMA (FL CHART) ---
  Widget _buildMainChartCard() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ];
                  if (value.toInt() >= 0 && value.toInt() < 7) {
                    return Text(
                      days[value.toInt()],
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 4),
                FlSpot(2, 3),
                FlSpot(3, 5),
                FlSpot(4, 4),
                FlSpot(5, 7),
                FlSpot(6, 6),
              ],
              isCurved: true,
              color: Colors.orangeAccent,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orangeAccent.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CARD STATISTIK KEMBAR ---
  Widget _buildSecondaryStats() {
    return Row(
      children: [
        Expanded(
          child: _buildSmallChartCard(
            "Perubahan Bulanan",
            "32%",
            Colors.greenAccent,
            true,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildSmallChartCard(
            "Perubahan Mingguan",
            "-26%",
            Colors.redAccent,
            false,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallChartCard(
    String title,
    String val,
    Color color,
    bool isUp,
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
            style: const TextStyle(color: Colors.black54, fontSize: 11),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                val,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                isUp ? Icons.trending_up : Icons.trending_down,
                color: color,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CARD TIDUR SEMALAM (GRADIENT) ---
  Widget _buildSleepDurationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9D00), Color(0xFFFF3D91)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tidur Semalam",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Text(
            "6h 37m",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          CustomPaint(
            size: const Size(double.infinity, 20),
            painter: WavePainter(),
          ),
        ],
      ),
    );
  }

  // --- BAGIAN MASALAH TIDUR & NAVIGASI PANDUAN ---
  Widget _buildProblemSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Apakah ada masalah\nTidur?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigasi Langsung ke Panduan Tidur
                Get.to(() => const PanduanTidurView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Baca Panduan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        // Gambar Ilustrasi Koala
        Image.network(
          'https://cdn-icons-png.flaticon.com/512/3069/3069172.png',
          height: 100,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.nightlight_round,
            size: 80,
            color: Colors.white24,
          ),
        ),
      ],
    );
  }

  // --- BOTTOM NAVIGATION BAR ---
  Widget _buildBottomNav(HomeNavController navCtrl) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF13003B),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_filled, 0, navCtrl),
          _navIcon(Icons.bar_chart, 1, navCtrl),
          _navIcon(Icons.alarm, 2, navCtrl),
          _navIcon(Icons.person, 3, navCtrl),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index, HomeNavController navCtrl) {
    return GestureDetector(
      onTap: () => navCtrl.changePage(index),
      child: Obx(
        () => Icon(
          icon,
          color: navCtrl.selectedIndex.value == index
              ? Colors.white
              : Colors.white38,
          size: 28,
        ),
      ),
    );
  }
}

// Painter untuk garis gelombang di card oranye
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    var path = Path();
    path.moveTo(0, size.height / 2);
    for (var i = 1; i <= 3; i++) {
      path.quadraticBezierTo(
        size.width * (i * 0.25 - 0.125),
        0,
        size.width * i * 0.25,
        size.height / 2,
      );
      path.quadraticBezierTo(
        size.width * (i * 0.25 + 0.125),
        size.height,
        size.width * (i + 1) * 0.25,
        size.height / 2,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
