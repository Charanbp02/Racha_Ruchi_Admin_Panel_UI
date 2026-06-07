import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Dashboard/controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
