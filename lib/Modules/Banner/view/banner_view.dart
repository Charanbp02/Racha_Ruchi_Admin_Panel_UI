import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Banner_Model/banner_model.dart';
import 'package:racha_ruchi_admin_panel/Modules/Banner/controller/banner_controller.dart';

class BannerView extends StatelessWidget {
  const BannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BannerController>();

    return Scaffold(
      backgroundColor: const Color(0xfff5f3ff),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBannerDialog(controller),
        backgroundColor: const Color(0xff7c3aed),
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredBanners.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: controller.filteredBanners.length,
                itemBuilder: (context, index) {
                  final banner = controller.filteredBanners[index];
                  return _buildBannerCard(controller, banner);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BannerController controller) {
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
            "Banner Management",
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
            "Manage homepage banners, promotional banners, and category banners",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          _buildFilters(controller),
        ],
      ),
    );
  }

  Widget _buildFilters(BannerController controller) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Obx(
            () => DropdownButton<String>(
              value: controller.selectedType.value,
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Types')),
                ...controller.bannerTypes.map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  ),
                ),
              ],
              onChanged: (value) => controller.setTypeFilter(value!),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                hintText: "Search banners...",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  size: 18,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(BannerController controller, BannerModel banner) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
            child: SizedBox(
              width: 120,
              height: 120,
              child: Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                key: ValueKey(banner.imageUrl),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // ← This should be inside Image.network
                  print('Error loading banner image: ${banner.imageUrl}');
                  print('Error: $error');
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.image, size: 40, color: Colors.grey),
                        const SizedBox(height: 4),
                        Text(
                          'Image Error',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          banner.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff1e1e2e),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: controller
                              .getBannerTypeColor(banner.type)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              controller.getBannerTypeIcon(banner.type),
                              size: 12,
                              color: controller.getBannerTypeColor(banner.type),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              banner.type.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: controller.getBannerTypeColor(
                                  banner.type,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Iconsax.sort, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        "Order: ${banner.order}",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Iconsax.link, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          banner.link ?? 'No link',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Obx(
                  () => Switch(
                    value:
                        controller.banners
                            .firstWhere(
                              (b) => b.id == banner.id,
                              orElse: () => banner,
                            )
                            .isActive,
                    onChanged:
                        (_) => controller.toggleBannerStatus(
                          banner.id,
                          banner.isActive,
                        ),
                    activeThumbColor: const Color(0xff7c3aed),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed:
                          () => _showBannerDialog(controller, banner: banner),
                      icon: const Icon(
                        Iconsax.edit,
                        color: Color(0xff3b82f6),
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed:
                          () => controller.deleteBanner(
                            banner.id,
                            banner.imageUrl,
                          ),
                      icon: const Icon(
                        Iconsax.trash,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(BannerController controller) {
    if (controller.imagePreviewUrl.value.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Iconsax.gallery, size: 40, color: Colors.grey),
        ),
      );
    }

    // Add a unique key to force refresh when URL changes
    return Container(
      key: ValueKey(controller.imagePreviewUrl.value),
      child: Image.network(
        controller.imagePreviewUrl.value,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
                const SizedBox(height: 8),
                Text(
                  'Loading image...',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          print('Image URL: ${controller.imagePreviewUrl.value}');
          return Container(
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  'Failed to load image',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    // Force reload
                    controller.imagePreviewUrl.refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.gallery, size: 70, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No Banners Found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Click the + button to add a banner",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  void _showBannerDialog(BannerController controller, {BannerModel? banner}) {
    if (banner != null) {
      controller.editBanner(banner);
    } else {
      controller.clearForm();
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  banner == null ? "Add New Banner" : "Edit Banner",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1e1e2e),
                  ),
                ),
                const SizedBox(height: 20),
                // Image Picker
                // Image Picker with proper preview
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(
                    () => Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child:
                          controller.imagePreviewUrl.value.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: _buildImagePreview(controller),
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.gallery,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Click to select image",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                TextFormField(
                  controller: controller.titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    prefixIcon: const Icon(Iconsax.text),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? "Enter title" : null,
                ),
                const SizedBox(height: 12),
                // Description
                TextFormField(
                  controller: controller.descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    prefixIcon: const Icon(Iconsax.message),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                // Order and Type Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.orderController,
                        decoration: InputDecoration(
                          labelText: "Order",
                          prefixIcon: const Icon(Iconsax.sort),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? "Enter order" : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue:
                            controller.typeController.text.isNotEmpty
                                ? controller.typeController.text
                                : controller.bannerTypes.first,
                        decoration: InputDecoration(
                          labelText: "Type",
                          prefixIcon: const Icon(Iconsax.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items:
                            controller.bannerTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type.toUpperCase()),
                              );
                            }).toList(),
                        onChanged:
                            (value) => controller.typeController.text = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Link
                TextFormField(
                  controller: controller.linkController,
                  decoration: InputDecoration(
                    labelText: "Link (Optional)",
                    prefixIcon: const Icon(Iconsax.link),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              controller.isUploading.value
                                  ? null
                                  : banner == null
                                  ? controller.addBanner
                                  : controller.updateBanner,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff7c3aed),
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
                                    ),
                                  )
                                  : Text(
                                    banner == null
                                        ? "Add Banner"
                                        : "Update Banner",
                                  ),
                        ),
                      ),
                    ],
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
