import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/controller/product_controller.dart';

class EditProductView extends StatelessWidget {
  EditProductView({super.key});

  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final product = controller.selectedProduct.value;
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Edit Product")),
        body: const Center(child: Text("No product selected")),
      );
    }

    final nameController = TextEditingController(text: product.name);
    final descriptionController = TextEditingController(
      text: product.description,
    );
    final brandController = TextEditingController(text: product.brand);
    final skuController = TextEditingController(text: product.sku);
    final priceController = TextEditingController(
      text: product.price.toString(),
    );
    final stockController = TextEditingController(
      text: product.stock.toString(),
    );
    final categoryController = TextEditingController(text: product.category);
    final subCategoryController = TextEditingController(
      text: product.subCategory,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(nameController, "Product Name", Iconsax.box),
            const SizedBox(height: 16),
            _buildTextField(
              descriptionController,
              "Description",
              Iconsax.document_text,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(brandController, "Brand", Iconsax.building),
            const SizedBox(height: 16),
            _buildTextField(skuController, "SKU", Iconsax.barcode),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    priceController,
                    "Price (₹)",
                    Iconsax.dollar_circle,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    stockController,
                    "Stock",
                    Iconsax.archive,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    categoryController,
                    "Category",
                    Iconsax.category,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    subCategoryController,
                    "Sub Category",
                    Iconsax.category,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                controller.updateProduct(product.id, {
                  'name': nameController.text.trim(),
                  'description': descriptionController.text.trim(),
                  'brand': brandController.text.trim(),
                  'sku': skuController.text.trim(),
                  'price': double.parse(priceController.text),
                  'stock': int.parse(stockController.text),
                  'category': categoryController.text.trim(),
                  'subCategory': subCategoryController.text.trim(),
                });
                Get.back();
              },
              icon: const Icon(Iconsax.save_2),
              label: const Text(
                "Update Product",
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
