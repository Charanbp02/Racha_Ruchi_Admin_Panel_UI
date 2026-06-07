import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/SideBar_Menu_Model/menu_model.dart';
import 'package:racha_ruchi_admin_panel/Modules/Banner/view/banner_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/view/add_category_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/view/manage_categories_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/view/sub_categories_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Coupons/view/add_edit_coupon_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/all_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/cancelled_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/completed_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/new_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/processing_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/returns_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/view/add_product_page.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/view/all_products_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/view/stock_update_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Settings/view/settings_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/SideBar/controller/sidebar_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Dashboard/view/dashboard_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Users/view/all_users_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Videos/view/admin_videos_view.dart';

class SideBarView extends GetView<SidebarController> {
  const SideBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f3ff),
      body: Row(
        children: [
          // Sidebar - Fixed overflow issue
          Obx(
            () => SizedBox(
              width: controller.isSidebarOpen.value ? 280 : 80,
              child: _desktopSidebar(),
            ),
          ),
          // Main Content
          Expanded(child: _getCurrentPage()),
        ],
      ),
    );
  }

  Widget _getCurrentPage() {
    return Obx(() {
      switch (controller.currentRoute.value) {
        case '/dashboard':
          return const DashboardView();
        case '/all-products':
          return AllProductsView();
        case '/products/add':
          return AddProductView();
        case '/products/stock-update':
          return StockUpdateView();

        case '/orders':
          return const OrdersView();
        case '/orders/all':
          return const AllOrdersView();
        case '/orders/new':
          return const NewOrdersView();
        case '/orders/processing':
          return const ProcessingOrdersView();
        case '/orders/completed':
          return const CompletedOrdersView();
        case '/orders/cancelled':
          return const CancelledOrdersView();
        case '/orders/returns':
          return const ReturnsView();

        case '/videos':
          return const AdminVideosView();

        case '/users':
        case '/users/all':
          return const AllUsersView();
        case '/settings':
          return AdminSettingsView();

        case '/banners':
          return const BannerView();

        case '/category':
        case '/category/add':
          return const AddCategoryView();
        case '/category/manage':
          return const ManageCategoriesView();
        case '/category/sub':
          return const SubCategoriesView();

        case '/coupons':
          return const AddEditCouponView();

        default:
          return _buildPlaceholderPage(controller.currentRoute.value);
      }
    });
  }

  Widget _buildPlaceholderPage(String route) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f3ff),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.buildings, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              "Coming Soon",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "$route page is under development",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _desktopSidebar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff581c87), Color(0xff7e22ce), Color(0xff831843)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _logoSection(),
            // Use Expanded to prevent overflow
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: controller.menuItems.length,
                itemBuilder: (context, index) {
                  return _desktopMenuItem(controller.menuItems[index]);
                },
              ),
            ),
            _userSection(),
          ],
        ),
      ),
    );
  }

  Widget _desktopMenuItem(MenuModel item) {
    return Obx(() {
      final expanded = controller.openSubMenus[item.name] ?? false;
      final isOpen = controller.isSidebarOpen.value;
      final isSelected =
          controller.currentRoute.value == item.route ||
          (item.subMenus.any(
            (sub) => sub.route == controller.currentRoute.value,
          ));

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (item.subMenus.isNotEmpty) {
                controller.toggleSubMenu(item.name);
              } else {
                controller.navigateTo(item.route);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    expanded || isSelected
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: Colors.white, size: 22),
                  if (isOpen) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (item.subMenus.isNotEmpty)
                      Icon(
                        expanded ? Iconsax.arrow_up_1 : Iconsax.arrow_down_1,
                        color: Colors.white70,
                        size: 20,
                      ),
                  ],
                ],
              ),
            ),
          ),
          if (expanded && isOpen)
            Padding(
              padding: const EdgeInsets.only(left: 34, bottom: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    item.subMenus
                        .map((sub) => _desktopSubMenuItem(sub))
                        .toList(),
              ),
            ),
        ],
      );
    });
  }

  Widget _desktopSubMenuItem(SubMenuModel sub) {
    return Obx(() {
      final isSelected = controller.currentRoute.value == sub.route;

      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => controller.navigateTo(sub.route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                isSelected
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white70,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  sub.name,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _logoSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.toggleSidebar,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xffa855f7), Color(0xffec4899)],
                ),
              ),
              child: const Center(
                child: Text(
                  "RC",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          if (controller.isSidebarOpen.value) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "RACHA RUCHI",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Admin Panel",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _userSection() {
    return GestureDetector(
      onTap: () => _showLogoutDialog(),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://ui-avatars.com/api/?background=7c3aed&color=fff&name=Admin',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getAdminName(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _getAdminEmail(),
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Iconsax.logout, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }

  String _getAdminName() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return user?.displayName ?? 'Admin User';
    } catch (e) {
      return 'Admin User';
    }
  }

  String _getAdminEmail() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return user?.email ?? 'admin@racharuchi.com';
    } catch (e) {
      return 'admin@racharuchi.com';
    }
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Logout",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.logout();
      },
    );
  }
}
