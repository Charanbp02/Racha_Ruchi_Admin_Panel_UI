import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/controller/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}
