import 'package:get/get.dart';

class HomeNavController extends GetxController {
  // Indeks halaman aktif pada BottomNavigationBar
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
