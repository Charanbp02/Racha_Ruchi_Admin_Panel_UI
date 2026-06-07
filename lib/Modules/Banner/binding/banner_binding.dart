import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Banner/controller/banner_controller.dart';

class BannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BannerController>(() => BannerController());
  }
}
