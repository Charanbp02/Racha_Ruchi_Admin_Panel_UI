import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/controller/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
