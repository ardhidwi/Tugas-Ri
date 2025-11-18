import 'package:get/get.dart';

import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/stats/stats_view.dart';
import '../modules/alarm/alarm_view.dart';
import '../modules/community/community_view.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.STATS,
      page: () => const StatsView(),
    ),
    GetPage(
      name: Routes.ALARM,
      page: () => const AlarmView(),
    ),
    GetPage(
      name: Routes.COMMUNITY,
      page: () => const CommunityView(),
    ),
  ];
}
