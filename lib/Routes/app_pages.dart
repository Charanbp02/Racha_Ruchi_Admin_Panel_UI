import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Auth/binding/admin_login_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/Auth/view/admin_login_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Banner/binding/banner_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/Banner/view/banner_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/binding/category_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/view/category_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Coupons/binding/admin_coupons_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/Coupons/view/add_edit_coupon_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Dashboard/binding/dashboard_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/Dashboard/view/dashboard_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/binding/order_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Pending_Approval/binding/pending_approval_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/Pending_Approval/pending_approval_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Settings/binding/settings_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/Settings/view/settings_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/SideBar/binding/sidebar_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/SideBar/view/sidebar_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Videos/binding/admin_videos_binding.dart';
import 'package:racha_ruchi_admin_panel/Modules/Videos/view/admin_videos_view.dart';
import 'package:racha_ruchi_admin_panel/Routes/app_routes.dart';

class AppPages {
  static final routes = [
    // Make LOGIN the initial/default route
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const AdminLoginView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: '/', // Add this explicitly
      page: () => const SideBarView(),
      binding: SidebarBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.ORDERS,
      page: () => const OrdersView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: AppRoutes.PENDING_APPROVALS,
      page: () => const PendingApprovalPage(),
      binding: PendingApprovalBinding(),
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const AdminSettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.BANNERS,
      page: () => const BannerView(),
      binding: BannerBinding(),
    ),
    GetPage(
      name: AppRoutes.VIDEO,
      page: () => const AdminVideosView(),
      binding: AdminVideosBinding(),
    ),
    // Add the coupons page route
    GetPage(
      name: AppRoutes.COUPONS,
      page: () => const AddEditCouponView(),
      binding: AdminCouponsBinding(),
    ),
  ];
}
