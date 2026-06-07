// lib/Modules/Products/controller/product_controller.dart
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Product_Model/product_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var isLoading = false.obs;
  var products = <ProductModel>[].obs;
  var selectedProduct = Rx<ProductModel?>(null);
  var selectedTabIndex = 0.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;

  var categories = <String>[].obs;
  var subCategories = <String>[].obs;

  // Real-time subscription
  late Stream<List<ProductModel>> _productsStream;
  StreamSubscription<List<ProductModel>>? _productsSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeRealtimeProducts();
    fetchCategories();
    fetchSubCategories();
  }

  @override
  void onClose() {
    _productsSubscription?.cancel();
    super.onClose();
  }

  // Real-time products listener
  void _initializeRealtimeProducts() {
    _productsStream = _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ProductModel.fromMap(doc.data(), doc.id);
          }).toList();
        });

    _productsSubscription = _productsStream.listen(
      (productList) {
        products.value = productList;
        print('✅ Real-time update: ${productList.length} products loaded');
      },
      onError: (error) {
        print('❌ Error in real-time stream: $error');
      },
    );
  }

  // Web-compatible upload method for multiple images (up to 5)
  Future<List<String>> uploadMultipleImagesWeb(
    List<html.File> images,
    String productId,
  ) async {
    List<String> imageUrls = [];

    try {
      for (int i = 0; i < images.length; i++) {
        String imageType = i == 0 ? 'main_image' : 'image_$i';
        String imageUrl = await _uploadImageWeb(
          images[i],
          'products/$productId/$imageType.jpg',
        );
        imageUrls.add(imageUrl);
        print('Image $i uploaded: $imageUrl');
      }

      return imageUrls;
    } catch (e) {
      print('Error uploading images: $e');
      throw Exception('Failed to upload images: $e');
    }
  }

  Future<String> _uploadImageWeb(html.File file, String storagePath) async {
    try {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoadEnd.first;

      final bytes = reader.result as Uint8List;
      final ref = _storage.ref().child(storagePath);
      final uploadTask = ref.putData(bytes);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  // Add product with multiple images (first image as main)
  // Add product with web support and real-time update
  Future<void> addProductWeb({
    required String name,
    required String description,
    required double price,
    required double originalPrice,
    required String category,
    required String subCategory,
    required String brand,
    required int stock,
    required String sku,
    required List<html.File> productImages, // Changed: single list of images
    required List<String>
    weightVariants, // Changed: weight variants instead of sizes/colors
    required Map<String, dynamic> specifications,
  }) async {
    isLoading.value = true;

    try {
      DocumentReference docRef = _firestore.collection('products').doc();
      String productId = docRef.id;

      List<String> imageUrls = await uploadMultipleImagesWeb(
        productImages,
        productId,
      );

      double discount = ((originalPrice - price) / originalPrice) * 100;

      // Add weight variants to specifications
      Map<String, dynamic> updatedSpecifications = {
        ...specifications,
        'weightVariants': weightVariants,
      };

      ProductModel product = ProductModel(
        id: productId,
        name: name,
        description: description,
        price: price,
        originalPrice: originalPrice,
        discount: discount,
        images: imageUrls,
        category: category,
        subCategory: subCategory,
        brand: brand,
        rating: 0.0,
        reviews: 0,
        isInStock: stock > 0,
        stock: stock,
        sku: sku,
        isFeatured: false,
        weightVariants: weightVariants, // Changed: use weightVariants
        specifications: updatedSpecifications,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(product.toMap());

      Get.back();
      Get.snackbar(
        'Success',
        'Product added successfully! ${imageUrls.length} images uploaded.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('Error adding product: $e');
      Get.snackbar(
        'Error',
        'Failed to add product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update product with new images
  Future<void> updateProductWithImages({
    required String productId,
    required String name,
    required String description,
    required double price,
    required double originalPrice,
    required String category,
    required String subCategory,
    required String brand,
    required int stock,
    required String sku,
    List<html.File>? newImages, // New images to upload
    List<String>? existingImageUrls, // Keep existing images
    required List<String> weightVariants,
    required Map<String, dynamic> specifications,
  }) async {
    isLoading.value = true;

    try {
      List<String> finalImageUrls = [];

      // Keep existing images if provided
      if (existingImageUrls != null && existingImageUrls.isNotEmpty) {
        finalImageUrls.addAll(existingImageUrls);
      }

      // Upload new images if any
      if (newImages != null && newImages.isNotEmpty) {
        List<String> newImageUrls = await uploadMultipleImagesWeb(
          newImages,
          productId,
        );
        finalImageUrls.addAll(newImageUrls);
      }

      double discount = ((originalPrice - price) / originalPrice) * 100;

      Map<String, dynamic> updatedSpecifications = {
        ...specifications,
        'weightVariants': weightVariants,
      };

      await _firestore.collection('products').doc(productId).update({
        'name': name,
        'description': description,
        'price': price,
        'originalPrice': originalPrice,
        'discount': discount,
        'images': finalImageUrls,
        'category': category,
        'subCategory': subCategory,
        'brand': brand,
        'stock': stock,
        'isInStock': stock > 0,
        'sku': sku,
        'specifications': updatedSpecifications,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.back();
      Get.snackbar(
        'Success',
        'Product updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating product: $e');
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update product with real-time sync (without image changes)
  Future<void> updateProduct(
    String productId,
    Map<String, dynamic> data,
  ) async {
    isLoading.value = true;
    try {
      await _firestore.collection('products').doc(productId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.back();
      Get.snackbar(
        'Success',
        'Product updated! Changes will appear instantly in user app.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update stock with real-time sync
  Future<void> updateStock(String productId, int newStock) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'stock': newStock,
        'isInStock': newStock > 0,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Stock updated! Users will see the change immediately.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update stock: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Delete product with real-time sync
  Future<void> deleteProduct(String productId) async {
    isLoading.value = true;
    try {
      // Delete images from storage
      try {
        final ListResult result =
            await _storage.ref().child('products/$productId').listAll();
        for (Reference ref in result.items) {
          await ref.delete();
        }
      } catch (e) {
        print('Error deleting images: $e');
      }

      // Delete document from Firestore
      await _firestore.collection('products').doc(productId).delete();

      Get.snackbar(
        'Success',
        'Product deleted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Bulk stock update
  Future<void> bulkStockUpdate(List<Map<String, dynamic>> stockUpdates) async {
    isLoading.value = true;
    try {
      final batch = _firestore.batch();

      for (var update in stockUpdates) {
        final docRef = _firestore.collection('products').doc(update['id']);
        batch.update(docRef, {
          'stock': update['stock'],
          'isInStock': update['stock'] > 0,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      Get.snackbar(
        'Success',
        'Bulk stock updated! All changes are now live.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update stock: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get product images count
  int getProductImagesCount(ProductModel product) {
    return product.images.length;
  }

  // Check if product has multiple images
  bool hasMultipleImages(ProductModel product) {
    return product.images.length > 1;
  }

  // Get main image (first image)
  String getMainImage(ProductModel product) {
    return product.images.isNotEmpty ? product.images.first : '';
  }

  // Get additional images (all except first)
  List<String> getAdditionalImages(ProductModel product) {
    return product.images.length > 1 ? product.images.sublist(1) : [];
  }

  // Get weight variants from specifications
  List<String> getWeightVariants(ProductModel product) {
    if (product.specifications.containsKey('weightVariants')) {
      return List<String>.from(product.specifications['weightVariants']);
    }
    return [];
  }

  List<ProductModel> get filteredProducts {
    var filtered = products.toList();
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered =
          filtered.where((p) {
            return p.name.toLowerCase().contains(query) ||
                p.description.toLowerCase().contains(query) ||
                p.brand.toLowerCase().contains(query) ||
                p.sku.toLowerCase().contains(query);
          }).toList();
    }
    return filtered;
  }

  int get totalProducts => products.length;
  int get inStockCount => products.where((p) => p.stock > 0).length;
  int get lowStockCount =>
      products.where((p) => p.stock <= 5 && p.stock > 0).length;
  int get outOfStockCount => products.where((p) => p.stock == 0).length;

  Future<void> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      if (snapshot.docs.isNotEmpty) {
        categories.value =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
      } else {
        categories.value = [
          'Cookware',
          'Kitchen',
          'Appliances',
          'Books',
          'Spices',
        ];
      }
    } catch (e) {
      categories.value = [
        'Cookware',
        'Kitchen',
        'Appliances',
        'Books',
        'Spices',
      ];
    }
  }

  Future<void> fetchSubCategories() async {
    try {
      final snapshot = await _firestore.collection('subCategories').get();
      if (snapshot.docs.isNotEmpty) {
        subCategories.value =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
      } else {
        subCategories.value = [
          'Masala Powders',
          'Meal Kits',
          'Gravy Curries',
          'Snacks',
        ];
      }
    } catch (e) {
      subCategories.value = [
        'Masala Powders',
        'Meal Kits',
        'Gravy Curries',
        'Snacks',
      ];
    }
  }
}
