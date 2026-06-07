import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:racha_ruchi_admin_panel/Modules/Products/controller/product_controller.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final ProductController controller = Get.find<ProductController>();
  final _formKey = GlobalKey<FormState>();

  // Constants
  static const int MAX_IMAGES = 5;

  // Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final brandController = TextEditingController();
  final skuController = TextEditingController();
  final priceController = TextEditingController();
  final originalPriceController = TextEditingController();
  final stockController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();

  // Custom weight controller
  final customWeightController = TextEditingController();

  // Images - All images in one list, first image is main
  List<html.File> productImages = [];
  List<String> imagePreviews = [];

  // Weight Variants
  List<String> selectedWeights = [];
  String customWeightValue = '';
  bool showCustomWeightField = false;

  final List<String> availableWeights = [
    '100g',
    '150g',
    '200g',
    '250g',
    '500g',
  ];

  // Helper methods
  int get currentImageCount => productImages.length;
  int get remainingImageSlots => MAX_IMAGES - currentImageCount;

  void _pickImages() {
    if (remainingImageSlots <= 0) {
      _showMaxImagesError();
      return;
    }

    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null) {
        int filesToAdd = files.length;
        int currentCount = productImages.length;

        if (currentCount + filesToAdd > MAX_IMAGES) {
          final allowedFiles = MAX_IMAGES - currentCount;
          if (allowedFiles > 0) {
            _showWarning(
              'Image Limit Reached',
              'You can only add $allowedFiles more image(s). Maximum $MAX_IMAGES images allowed.',
            );
            filesToAdd = allowedFiles;
          } else {
            _showMaxImagesError();
            return;
          }
        }

        for (var i = 0; i < filesToAdd && i < files.length; i++) {
          final file = files[i];

          if (file.size > 5 * 1024 * 1024) {
            _showError('File too large', '${file.name} exceeds 5MB limit');
            continue;
          }

          productImages.add(file);

          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((event) {
            setState(() {
              imagePreviews.add(reader.result as String);
            });
          });
        }
      }
    });
  }

  void _removeImage(int index) {
    setState(() {
      imagePreviews.removeAt(index);
      productImages.removeAt(index);
    });
  }

  void _reorderImages(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;

    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final html.File file = productImages.removeAt(oldIndex);
      final String preview = imagePreviews.removeAt(oldIndex);
      productImages.insert(newIndex, file);
      imagePreviews.insert(newIndex, preview);
    });

    _showInfo('Image Reordered', 'First image will be the main product image');
  }

  void _addCustomWeight() {
    if (customWeightValue.trim().isEmpty) {
      _showError('Error', 'Please enter a valid weight');
      return;
    }

    // Check if weight already exists in selected weights
    if (selectedWeights.contains(customWeightValue.trim())) {
      _showError('Duplicate', 'This weight is already added');
      return;
    }

    // Check if weight already exists in predefined weights
    if (availableWeights.contains(customWeightValue.trim())) {
      _showError(
        'Duplicate',
        'This weight is already available in predefined list',
      );
      return;
    }

    setState(() {
      selectedWeights.add(customWeightValue.trim());
      customWeightValue = '';
      customWeightController.clear();
      showCustomWeightField = false;
    });

    _showInfo('Weight Added', '${customWeightValue} added successfully');
  }

  void _removeWeight(String weight) {
    setState(() {
      selectedWeights.remove(weight);
    });
  }

  void _togglePredefinedWeight(String weight) {
    setState(() {
      if (selectedWeights.contains(weight)) {
        selectedWeights.remove(weight);
      } else {
        selectedWeights.add(weight);
      }
    });
  }

  void _showMaxImagesError() {
    _showError(
      'Maximum Images Reached',
      'You can only upload up to $MAX_IMAGES images per product.',
    );
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _showWarning(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<List<String>> _uploadImagesToStorage() async {
    List<String> imageUrls = [];
    final storage = FirebaseStorage.instance;

    try {
      if (productImages.isNotEmpty) {
        final productId = DateTime.now().millisecondsSinceEpoch.toString();

        for (int i = 0; i < productImages.length; i++) {
          final imageType = i == 0 ? 'main_image' : 'image_$i';
          final ref = storage.ref().child('products/$productId/$imageType');
          final reader = html.FileReader();
          reader.readAsArrayBuffer(productImages[i]);
          await reader.onLoadEnd.first;

          final bytes = reader.result as Uint8List;
          final uploadTask = ref.putData(bytes);
          final snapshot = await uploadTask;
          final imageUrl = await snapshot.ref.getDownloadURL();
          imageUrls.add(imageUrl);

          print('Image $i uploaded: $imageUrl');
        }
      }

      print('Total images uploaded: ${imageUrls.length}');
      return imageUrls;
    } catch (e) {
      print('Error uploading images: $e');
      throw Exception('Failed to upload images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Add New Product",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 24),
            child: TextButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Iconsax.close_circle),
              label: const Text("Cancel"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPageHeader(),
                        const SizedBox(height: 24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 900) {
                              return _buildMobileLayout();
                            }
                            return _buildDesktopLayout();
                          },
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildImageSection(),
              const SizedBox(height: 20),
              _buildBasicInfoCard(),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPricingCard(),
              const SizedBox(height: 20),
              _buildCategoryStockCard(),
              const SizedBox(height: 20),
              _buildDimensionsCard(),
              const SizedBox(height: 20),
              _buildWeightVariantsSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildImageSection(),
        const SizedBox(height: 20),
        _buildBasicInfoCard(),
        const SizedBox(height: 20),
        _buildPricingCard(),
        const SizedBox(height: 20),
        _buildCategoryStockCard(),
        const SizedBox(height: 20),
        _buildDimensionsCard(),
        const SizedBox(height: 20),
        _buildWeightVariantsSection(),
      ],
    );
  }

  Widget _buildPageHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Iconsax.box_add, size: 32, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Fill in all the details to add a new product to your store",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.image, size: 20, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  "Product Images",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$currentImageCount/$MAX_IMAGES",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.info_circle,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "First image will be the main product image. Drag to reorder.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            imagePreviews.isEmpty
                ? GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.gallery_add,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Click to add up to $MAX_IMAGES images",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        Text(
                          "First image will be main product image",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                        ),
                        Text(
                          "JPG, PNG (Max 5MB each)",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                      itemCount: imagePreviews.length,
                      itemBuilder: (context, index) {
                        final isMain = index == 0;
                        return Draggable<int>(
                          data: index,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imagePreviews[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onDragEnd: (details) {},
                          child: DragTarget<int>(
                            onAccept: (int oldIndex) {
                              _reorderImages(oldIndex, index);
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            isMain
                                                ? Colors.blue.shade400
                                                : Colors.grey.shade200,
                                        width: isMain ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        if (isMain)
                                          BoxShadow(
                                            color: Colors.blue.shade200,
                                            blurRadius: 8,
                                          ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(11),
                                      child: Image.network(
                                        imagePreviews[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if (isMain)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade600,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Iconsax.star,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "Main",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    if (remainingImageSlots > 0)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _pickImages,
                          icon: const Icon(Iconsax.add),
                          label: Text(
                            "Add More Images (${remainingImageSlots} left)",
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    if (currentImageCount == MAX_IMAGES)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.info_circle,
                              size: 16,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Maximum limit of $MAX_IMAGES images reached",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.info_circle,
                  size: 20,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Basic Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              nameController,
              "Product Name",
              Iconsax.box,
              validator: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              descriptionController,
              "Description",
              Iconsax.document_text,
              maxLines: 4,
              validator: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    brandController,
                    "Brand",
                    Iconsax.building,
                    validator: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    skuController,
                    "SKU",
                    Iconsax.barcode,
                    validator: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.dollar_circle,
                  size: 20,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Pricing",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              priceController,
              "Price (₹)",
              Iconsax.discount_circle,
              keyboardType: TextInputType.number,
              validator: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              originalPriceController,
              "MRP (₹)",
              Iconsax.tag,
              keyboardType: TextInputType.number,
              validator: true,
            ),
            const SizedBox(height: 12),
            _buildDiscountPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountPreview() {
    if (priceController.text.isNotEmpty &&
        originalPriceController.text.isNotEmpty) {
      final price = double.tryParse(priceController.text) ?? 0;
      final mrp = double.tryParse(originalPriceController.text) ?? 0;
      if (mrp > price && price > 0) {
        final discount = ((mrp - price) / mrp * 100).toStringAsFixed(0);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Iconsax.discount_shape, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                "You're offering $discount% discount",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildCategoryStockCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.category, size: 20, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  "Category & Stock",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              categoryController,
              "Category",
              controller.categories,
              validator: true,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              subCategoryController,
              "Sub Category",
              controller.subCategories,
              validator: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              stockController,
              "Stock Quantity",
              Iconsax.archive,
              keyboardType: TextInputType.number,
              validator: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDimensionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.box_1, size: 20, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  "Dimensions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              lengthController,
              "Length (cm)",
              Iconsax.arrow_swap,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              widthController,
              "Width (cm)",
              Iconsax.arrow_swap,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              heightController,
              "Height (cm)",
              Iconsax.arrow_swap,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightVariantsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.weight, size: 20, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  "Weight Variants",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                if (selectedWeights.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${selectedWeights.length} selected",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Predefined weights
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  availableWeights.map((weight) {
                    final isSelected = selectedWeights.contains(weight);
                    return FilterChip(
                      label: Text(weight),
                      selected: isSelected,
                      onSelected: (_) => _togglePredefinedWeight(weight),
                      backgroundColor: Colors.grey.shade50,
                      selectedColor: Colors.blue.shade100,
                      labelStyle: TextStyle(
                        color:
                            isSelected
                                ? Colors.blue.shade700
                                : Colors.grey.shade700,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 12),

            // Custom weight section
            if (!showCustomWeightField)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      showCustomWeightField = true;
                    });
                  },
                  icon: const Icon(Iconsax.add, size: 16),
                  label: const Text("Add Custom Weight"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purple.shade700,
                  ),
                ),
              ),

            if (showCustomWeightField) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: customWeightController,
                            onChanged: (value) {
                              customWeightValue = value;
                            },
                            decoration: InputDecoration(
                              hintText: "e.g., 750g, 1kg, 2kg",
                              prefixIcon: const Icon(Iconsax.edit, size: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _addCustomWeight,
                          icon: const Icon(
                            Iconsax.tick_circle,
                            color: Colors.green,
                          ),
                          tooltip: 'Add Weight',
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              showCustomWeightField = false;
                              customWeightValue = '';
                              customWeightController.clear();
                            });
                          },
                          icon: const Icon(
                            Iconsax.close_circle,
                            color: Colors.red,
                          ),
                          tooltip: 'Cancel',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Custom weight will be added to the list",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.purple.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Selected weights display with remove option
            if (selectedWeights.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                "Selected Weights:",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    selectedWeights.map((weight) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              weight,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _removeWeight(weight),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
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
    bool validator = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator:
          validator ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
    );
  }

  Widget _buildDropdownField(
    TextEditingController controller,
    String label,
    RxList<String> items, {
    bool validator = false,
  }) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonFormField<String>(
          initialValue: controller.text.isEmpty ? null : controller.text,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(Iconsax.category, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: (value) => controller.text = value ?? '',
          validator: validator ? (v) => v == null ? 'Required' : null : null,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        controller.isLoading.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              "Add Product",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (productImages.isEmpty) {
      _showError('Error', 'Please add at least one product image');
      return;
    }

    if (selectedWeights.isEmpty) {
      _showError('Error', 'Please add at least one weight variant');
      return;
    }

    controller.isLoading.value = true;

    try {
      double price = double.parse(priceController.text);
      double originalPrice = double.parse(originalPriceController.text);

      await controller.addProductWeb(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: price,
        originalPrice: originalPrice,
        category: categoryController.text.trim(),
        subCategory: subCategoryController.text.trim(),
        brand: brandController.text.trim(),
        stock: int.parse(stockController.text),
        sku: skuController.text.trim(),
        productImages: productImages,
        weightVariants: selectedWeights,
        specifications: {
          'dimensions': {
            'length': double.tryParse(lengthController.text) ?? 0,
            'width': double.tryParse(widthController.text) ?? 0,
            'height': double.tryParse(heightController.text) ?? 0,
          },
        },
      );
    } catch (e) {
      print('Error in _submitForm: $e');
      _showError('Error', 'Failed to add product: $e');
    } finally {
      controller.isLoading.value = false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    brandController.dispose();
    skuController.dispose();
    priceController.dispose();
    originalPriceController.dispose();
    stockController.dispose();
    categoryController.dispose();
    subCategoryController.dispose();
    customWeightController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    super.dispose();
  }
}
