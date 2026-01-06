import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_nav_controller.dart';
import '../../dashboard_statistik_tidur/views/dashboard_statistik_tidur_view.dart';
import '../../tracker_tidur/views/tracker_tidur_view.dart';
import '../../tracker_tidur/controllers/tracker_tidur_controller.dart';
import '../../alarm_tidur/views/alarm_tidur_view.dart';
import '../../profile/views/profile_view.dart';

class HomeNavView extends GetView<HomeNavController> {
  const HomeNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = controller;

    return Obx(() {
      Widget page;

      switch (homeCtrl.selectedIndex.value) {
        case 0:
          page = const DashboardStatistikTidurView();
          break;

        case 1:
          // Inject controller bila belum ada
          if (!Get.isRegistered<TrackerTidurController>()) {
            Get.lazyPut(() => TrackerTidurController());
          }
          page = TrackerTidurView();
          break;

        case 2:
          page = AlarmTidurView();
          break;

        case 3:
          page = const ProfileView();
          break;

        default:
          page = const DashboardStatistikTidurView();
      }

      return Scaffold(
        body: page,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homeCtrl.selectedIndex.value,
          onTap: homeCtrl.changePage,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.nights_stay),
              label: 'Tracker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Alarm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
