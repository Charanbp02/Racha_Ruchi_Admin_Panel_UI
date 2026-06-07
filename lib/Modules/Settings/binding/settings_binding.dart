import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Settings/controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
