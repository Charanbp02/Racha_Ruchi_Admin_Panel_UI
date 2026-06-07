import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Banner/controller/banner_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/controller/category_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Coupons/controller/admin_coupons_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Dashboard/controller/dashboard_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/controller/order_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Pending_Approval/controller/pending_approval_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/controller/product_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Settings/controller/settings_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Users/controller/user_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());

    Get.lazyPut<OrderController>(() => OrderController());

    Get.lazyPut<ProductController>(() => ProductController());

    Get.lazyPut<UserController>(() => UserController());

    Get.lazyPut<PendingApprovalController>(() => PendingApprovalController());

    Get.lazyPut<SettingsController>(() => SettingsController());

    Get.lazyPut<DashboardController>(() => DashboardController());

    Get.lazyPut<BannerController>(() => BannerController());

    // Add more controllers here as needed
    Get.lazyPut<AdminCouponsController>(() => AdminCouponsController());
  }
}
