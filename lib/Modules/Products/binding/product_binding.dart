import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/controller/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
