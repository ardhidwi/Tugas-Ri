import 'package:get/get.dart';

// LOGIN MODULE
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

// REGISTER MODULE
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

// DASHBOARD STATISTIK TIDUR MODULE
import '../modules/dashboard_statistik_tidur/bindings/dashboard_statistik_tidur_binding.dart';
import '../modules/dashboard_statistik_tidur/views/dashboard_statistik_tidur_view.dart';

// TRACKER TIDUR MODULE
import '../modules/tracker_tidur/bindings/tracker_tidur_binding.dart'; // sudah benar
import '../modules/tracker_tidur/views/tracker_tidur_view.dart';

// PROFILE MODULE
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

// EDIT PROFILE MODULE
import '../modules/profile/bindings/edit_profile_binding.dart';
import '../modules/profile/views/edit_profile_view.dart';

// ALARM TIDUR MODULE
// *** Perbaiki import ini ***
import '../modules/alarm_tidur/bindings/alarm_tidur_binding.dart'; // *** Hapus duplikasi/typo ***
import '../modules/alarm_tidur/views/alarm_tidur_view.dart';

class AppRoutes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const DASHBOARD_STATISTIK_TIDUR = '/dashboard-statistik-tidur';
  static const TRACKER_TIDUR = '/tracker-tidur';

  // NEW ROUTES
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const ALARM_TIDUR = '/alarm-tidur';

  static final routes = [
    GetPage(
      name: LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
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
    GetPage(
      name: TRACKER_TIDUR,
      page: () => TrackerTidurView(),
      binding: TrackerTidurBinding(),
    ),
    // PROFILE ROUTING
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
