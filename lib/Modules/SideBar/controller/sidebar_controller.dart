import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/SideBar_Menu_Model/menu_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SidebarController extends GetxController {
  // Set sidebar to OPEN by default
  RxBool isSidebarOpen = true.obs;
  RxBool isHovered = false.obs;
  RxString hoveredMenuItem = ''.obs;
  RxString currentRoute = '/dashboard'.obs;

  RxMap<String, bool> openSubMenus = <String, bool>{}.obs;

  final List<MenuModel> menuItems = [
    MenuModel(
      name: "Dashboard",
      icon: Iconsax.element_4,
      route: "/dashboard",
      subMenus: [],
    ),
    MenuModel(
      name: "Products",
      icon: Iconsax.box,
      route: "/all-products",
      subMenus: [
        SubMenuModel(
          name: "All Products",
          route: "/all-products",
          icon: Iconsax.box,
        ),
        SubMenuModel(
          name: "Add Product",
          route: "/products/add",
          icon: Iconsax.add_circle,
        ),
        SubMenuModel(
          name: "Stock Management",
          route: "/products/stock-update",
          icon: Iconsax.box1,
        ),
      ],
    ),
    MenuModel(
      name: "Orders",
      icon: Iconsax.shopping_cart,
      route: "/orders",
      subMenus: [
        SubMenuModel(
          name: "All Orders",
          route: "/orders/all",
          icon: Iconsax.document_text,
        ),
        SubMenuModel(
          name: "New Orders",
          route: "/orders/new",
          icon: Iconsax.add_circle,
        ),
        SubMenuModel(
          name: "Processing",
          route: "/orders/processing",
          icon: Iconsax.refresh,
        ),
        SubMenuModel(
          name: "Completed",
          route: "/orders/completed",
          icon: Iconsax.tick_circle,
        ),
        SubMenuModel(
          name: "Cancelled",
          route: "/orders/cancelled",
          icon: Iconsax.close_circle,
        ),
        SubMenuModel(
          name: "Returns",
          route: "/orders/returns",
          icon: Iconsax.arrow_left,
        ),
      ],
    ),
    MenuModel(
      name: "Users",
      icon: Iconsax.profile_2user,
      route: "/users",
      subMenus: [
        SubMenuModel(
          name: "All Users",
          route: "/users/all",
          icon: Iconsax.people,
        ),
      ],
    ),
    MenuModel(
      name: "Top Recipes Videos",
      icon: Iconsax.video,
      route: "/top-recipes-videos",
      subMenus: [
        SubMenuModel(
          name: "Top Videos",
          route: "/top-recipes-videos/all",
          icon: Iconsax.video1,
        ),
      ],
    ),
    MenuModel(
      name: "Categories",
      icon: Iconsax.category,
      route: "/category",
      subMenus: [
        SubMenuModel(
          name: "Add Category",
          route: "/category/add",
          icon: Iconsax.add_circle,
        ),
        SubMenuModel(
          name: "Manage Categories",
          route: "/category/manage",
          icon: Iconsax.setting_2,
        ),
        SubMenuModel(
          name: "Sub Categories",
          route: "/category/sub",
          icon: Iconsax.category,
        ),
      ],
    ),
    MenuModel(name: "Videos", icon: Iconsax.video, route: "/videos"),
    MenuModel(name: "Banners", icon: Iconsax.image, route: "/banners"),
    MenuModel(
      name: "Settings",
      icon: Iconsax.setting_2,
      route: "/settings",
      subMenus: [],
    ),
    MenuModel(
      name: "Coupons",
      icon: Iconsax.discount_circle,
      route: "/coupons",
      subMenus: [],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Ensure sidebar is open when controller initializes
    isSidebarOpen.value = true;
  }

  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
    if (!isSidebarOpen.value) {
      openSubMenus.clear();
    }
  }

  void toggleSubMenu(String menuName) {
    openSubMenus[menuName] = !(openSubMenus[menuName] ?? false);
  }

  void setHoveredItem(String menuName) {
    hoveredMenuItem.value = menuName;
  }

  void clearHoveredItem() {
    hoveredMenuItem.value = '';
  }

  void navigateTo(String route) {
    currentRoute.value = route;

    // Always close all submenus first when sidebar is closed
    if (!isSidebarOpen.value) {
      return;
    }

    // Auto-expand parent menu when navigating to submenu
    for (var menu in menuItems) {
      for (var sub in menu.subMenus) {
        if (sub.route == route) {
          if (!(openSubMenus[menu.name] ?? false)) {
            openSubMenus[menu.name] = true;
          }
          break;
        }
      }
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Close dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Navigate to login
      Get.offAllNamed('/login');

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      debugPrint('Logout error: $e');
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
