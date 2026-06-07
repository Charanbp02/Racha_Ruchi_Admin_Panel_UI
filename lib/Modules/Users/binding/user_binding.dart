import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Users/controller/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
