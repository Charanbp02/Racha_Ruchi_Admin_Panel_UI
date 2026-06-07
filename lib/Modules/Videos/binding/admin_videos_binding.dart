import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Videos/controller/admin_video_controller.dart';

class AdminVideosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminVideosController>(() => AdminVideosController());
  }
}
