import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Product_Model/product_model.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/controller/product_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/view/add_product_page.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/view/edit_product_page.dart';

class AllProductsView extends StatelessWidget {
  AllProductsView({super.key});

  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Product Management",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 24),
            child: Obx(
              () => Chip(
                label: Text(
                  "${controller.products.length} Products",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.blue.shade50,
                avatar: Icon(
                  Iconsax.box,
                  size: 18,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(
                  Iconsax.search_normal,
                  color: Colors.grey[500],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
          ),
          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatCard(
                  "Total",
                  controller.totalProducts.toString(),
                  Iconsax.box,
                  Colors.blue,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  "In Stock",
                  controller.inStockCount.toString(),
                  Iconsax.tick_circle,
                  Colors.green,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  "Low Stock",
                  controller.lowStockCount.toString(),
                  Iconsax.warning_2,
                  Colors.orange,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  "Out of Stock",
                  controller.outOfStockCount.toString(),
                  Iconsax.close_circle,
                  Colors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Products Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.box_1, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        "No Products Found",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => AddProductView()),
        icon: const Icon(Iconsax.add, size: 20),
        label: const Text("Add Product"),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    MaterialColor color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color.shade700, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.shade900,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: color.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final isLowStock = product.stock <= 5 && product.stock > 0;
    final isOutOfStock = product.stock == 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child:
                  product.images.isNotEmpty
                      ? Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Container(
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.image,
                                  size: 40,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Image not found',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                      : Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Iconsax.image,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isOutOfStock
                                ? Colors.red.shade50
                                : isLowStock
                                ? Colors.orange.shade50
                                : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${product.stock} in stock",
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              isOutOfStock
                                  ? Colors.red.shade700
                                  : isLowStock
                                  ? Colors.orange.shade700
                                  : Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Iconsax.edit, size: 18),
                      onPressed: () {
                        controller.selectedProduct.value = product;
                        Get.to(() => EditProductView());
                      },
                      color: Colors.blue,
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.trash, size: 18),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Delete Product",
                          middleText: "Delete ${product.name}?",
                          onConfirm: () {
                            controller.deleteProduct(product.id);
                            Get.back();
                          },
                          textConfirm: "Delete",
                          textCancel: "Cancel",
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.red,
                        );
                      },
                      color: Colors.red,
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
}
