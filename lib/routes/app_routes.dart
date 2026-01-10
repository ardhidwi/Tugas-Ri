import 'package:get/get.dart';

// Import Views & Bindings
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/dashboard_statistik_tidur/bindings/dashboard_statistik_tidur_binding.dart';
import '../modules/dashboard_statistik_tidur/views/dashboard_statistik_tidur_view.dart';
import '../modules/dashboard_statistik_tidur/views/panduan_tidur_view.dart'; // Import Panduan
import '../modules/tracker_tidur/bindings/tracker_tidur_binding.dart';
import '../modules/tracker_tidur/views/tracker_tidur_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/bindings/edit_profile_binding.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/alarm_tidur/bindings/alarm_tidur_binding.dart';
import '../modules/alarm_tidur/views/alarm_tidur_view.dart';

class AppRoutes {
  // 1. Deklarasi String Nama Rute
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const DASHBOARD_STATISTIK_TIDUR = '/dashboard-statistik-tidur';
  static const PANDUAN_TIDUR = '/panduan-tidur';
  static const TRACKER_TIDUR = '/tracker-tidur';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const ALARM_TIDUR = '/alarm-tidur';

  // 2. Daftar Halaman GetPage
  static final routes = [
    GetPage(name: LOGIN, page: () => LoginView(), binding: LoginBinding()),
    GetPage(
      name: REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: DASHBOARD_STATISTIK_TIDUR,
      page: () => const DashboardStatistikTidurView(),
      binding: DashboardStatistikTidurBinding(),
    ),
    // Route Panduan Tidur
    GetPage(
      name: PANDUAN_TIDUR,
      page: () => const PanduanTidurView(),
      transition: Transition.rightToLeft, // Animasi masuk dari kanan
    ),
    GetPage(
      name: TRACKER_TIDUR,
      page: () => TrackerTidurView(),
      binding: TrackerTidurBinding(),
    ),
    GetPage(
      name: PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: ALARM_TIDUR,
      page: () => AlarmTidurView(),
      binding: AlarmTidurBinding(),
    ),
  ];
}
