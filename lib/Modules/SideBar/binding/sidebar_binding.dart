import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/SideBar/controller/sidebar_controller.dart';

class SidebarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SidebarController>(() => SidebarController());
  }
}
