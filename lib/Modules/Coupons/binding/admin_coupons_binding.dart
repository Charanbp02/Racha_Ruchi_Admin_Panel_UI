// lib/Modules/Coupons/bindings/admin_coupons_binding.dart
import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Coupons_Model/coupons_models.dart';
import 'package:racha_ruchi_admin_panel/Modules/Coupons/controller/admin_coupons_controller.dart';

class AdminCouponsBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy put the controller - it will be created when first used
    Get.lazyPut<AdminCouponsController>(() => AdminCouponsController());
  }
}

// Binding for Add/Edit Coupon View
class AddEditCouponBinding implements Bindings {
  final CouponModel? coupon;

  AddEditCouponBinding({this.coupon});

  @override
  void dependencies() {
    // Controller is already registered, just pass the coupon argument
    Get.lazyPut<AdminCouponsController>(() => AdminCouponsController());
  }
}
