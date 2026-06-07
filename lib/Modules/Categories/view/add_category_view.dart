import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Modules/Categories/controller/category_controller.dart';

class AddCategoryView extends StatelessWidget {
  const AddCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStats(controller),
            const SizedBox(height: 24),
            _buildAddCategoryForm(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(CategoryController controller) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: [
        _statCard(
          title: "Total Categories",
          value: "${controller.categories.length}",
          icon: Iconsax.category,
          color: const Color(0xff7c3aed),
        ),
        _statCard(
          title: "Active Categories",
          value: "${controller.activeCategories.length}",
          icon: Iconsax.tick_circle,
          color: Colors.green,
        ),
        _statCard(
          title: "Inactive Categories",
          value: "${controller.inactiveCategories.length}",
          icon: Iconsax.close_circle,
          color: Colors.red,
        ),
        _statCard(
          title: "Sub Categories",
          value:
              "${controller.categories.fold<int>(0, (sum, cat) => sum + cat.subCategories.length)}",
          icon: Iconsax.document_text,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1e1e2e),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryForm(CategoryController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff7c3aed), Color(0xffec4899)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.add_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                controller.selectedCategory.value == null
                    ? "Add New Category"
                    : "Edit Category",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1e1e2e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // CATEGORY IMAGE UPLOAD BUTTON - Fixed version
          GestureDetector(
            onTap: controller.pickImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade50,
              ),
              child: Obx(() {
                // Use imagePreviewUrl and selectedImageFile from controller
                if (controller.imagePreviewUrl.value.isNotEmpty) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      controller.imagePreviewUrl.value,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      },
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.gallery_add,
                        size: 50,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Click to upload category image",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "PNG, JPG up to 2MB",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          ),

          const SizedBox(height: 20),

          // CATEGORY NAME FIELD
          _buildTextField(
            controller: controller.nameController,
            label: "Category Name",
            hint: "Enter category name",
            icon: Iconsax.category,
          ),

          const SizedBox(height: 16),

          // DESCRIPTION FIELD
          _buildTextField(
            controller: controller.descriptionController,
            label: "Description",
            hint: "Enter category description",
            icon: Iconsax.message,
            maxLines: 3,
          ),

          const SizedBox(height: 16),

          // ICON AND COLOR ROW
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: controller.iconController,
                  label: "Icon (Emoji)",
                  hint: "🍽️",
                  icon: Iconsax.emoji_happy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: controller.colorController,
                  label: "Color (Hex)",
                  hint: "#7c3aed",
                  icon: Iconsax.colorfilter,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      controller.isUploading.value
                          ? null
                          : () {
                            if (controller.selectedCategory.value == null) {
                              controller.addCategory();
                            } else {
                              controller.updateCategory();
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7c3aed),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      controller.isUploading.value
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            controller.selectedCategory.value == null
                                ? "Add Category"
                                : "Update Category",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              if (controller.selectedCategory.value != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.clearForm,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff7c3aed)),
            ),
          ),
        ),
      ],
    );
  }
}
