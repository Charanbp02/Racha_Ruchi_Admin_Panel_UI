import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Product_Model/product_model.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/controller/product_controller.dart';

class StockUpdateView extends StatelessWidget {
  StockUpdateView({super.key});

  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Stock Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          // Real-time indicator instead of refresh button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Obx(
              () => Row(
                children: [
                  Icon(
                    Iconsax.wifi,
                    size: 18,
                    color:
                        controller.isLoading.value
                            ? Colors.orange
                            : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    controller.isLoading.value ? 'Syncing...' : 'Live',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          controller.isLoading.value
                              ? Colors.orange
                              : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.products.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        final lowStockProducts =
            controller.products
                .where((p) => p.stock <= 10 && p.stock > 0)
                .toList();
        final outOfStockProducts =
            controller.products.where((p) => p.stock == 0).toList();

        return RefreshIndicator(
          onRefresh: () async {
            // Manual refresh - data will update from real-time stream
            controller.isLoading.value = true;
            await Future.delayed(const Duration(milliseconds: 500));
            controller.isLoading.value = false;
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Stats Cards
              Row(
                children: [
                  _buildStatsCard(
                    "Total Products",
                    controller.products.length.toString(),
                    Iconsax.box,
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildStatsCard(
                    "Low Stock",
                    lowStockProducts.length.toString(),
                    Iconsax.warning_2,
                    Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  _buildStatsCard(
                    "Out of Stock",
                    outOfStockProducts.length.toString(),
                    Iconsax.close_circle,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Real-time update notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.flash, size: 20, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Stock updates are saved in real-time. Changes appear instantly in user app.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (lowStockProducts.isNotEmpty) ...[
                const Text(
                  "Low Stock Alert",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...lowStockProducts.map(
                  (p) => _buildStockCard(p, isLowStock: true),
                ),
                const SizedBox(height: 24),
              ],

              const Text(
                "All Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...controller.products.map((p) => _buildStockCard(p)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsCard(
    String title,
    String value,
    IconData icon,
    MaterialColor color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color.shade700),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color.shade900,
              ),
            ),
            Text(title, style: TextStyle(fontSize: 12, color: color.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard(ProductModel product, {bool isLowStock = false}) {
    final stockController = TextEditingController(
      text: product.stock.toString(),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLowStock ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLowStock ? Colors.orange.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "SKU: ${product.sku}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      product.stock == 0
                          ? Colors.red.shade100
                          : isLowStock
                          ? Colors.orange.shade100
                          : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.stock == 0
                      ? "Out of Stock"
                      : isLowStock
                      ? "Low Stock"
                      : "In Stock",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        product.stock == 0
                            ? Colors.red.shade700
                            : isLowStock
                            ? Colors.orange.shade700
                            : Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Stock Quantity",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  final newStock = int.tryParse(stockController.text);
                  if (newStock != null && newStock != product.stock) {
                    controller.updateStock(product.id, newStock);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: const Text("Update"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
