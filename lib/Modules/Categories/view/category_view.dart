import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/view/add_category_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/controller/category_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/view/manage_categories_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/view/sub_categories_view.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return Scaffold(
      backgroundColor: const Color(0xfff5f3ff),
      body: Column(
        children: [
          _buildHeader(controller),
          Expanded(
            child: Obx(() {
              switch (controller.selectedTabIndex.value) {
                case 0:
                  return const AddCategoryView();
                case 1:
                  return const ManageCategoriesView();
                case 2:
                  return const SubCategoriesView();
                default:
                  return const AddCategoryView();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(CategoryController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withValues(alpha: 0.05)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category Management",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              foreground:
                  Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xff7c3aed), Color(0xffec4899)],
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Manage your product categories and subcategories",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          _buildTabs(controller),
        ],
      ),
    );
  }

  Widget _buildTabs(CategoryController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem(controller, 0, "Add Category", Iconsax.add_circle),
          _buildTabItem(controller, 1, "Manage Categories", Iconsax.category),
          _buildTabItem(controller, 2, "Sub Categories", Iconsax.document_text),
          _buildTabItem(controller, 3, "Settings", Iconsax.setting_2),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    CategoryController controller,
    int index,
    String title,
    IconData icon,
  ) {
    return Obx(
      () => Expanded(
        child: GestureDetector(
          onTap: () => controller.selectedTabIndex.value = index,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color:
                  controller.selectedTabIndex.value == index
                      ? const Color(0xff7c3aed)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color:
                      controller.selectedTabIndex.value == index
                          ? Colors.white
                          : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                        controller.selectedTabIndex.value == index
                            ? Colors.white
                            : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
