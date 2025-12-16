import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Use lazyPut so controller is created only when EditProfileView is opened
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
