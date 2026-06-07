import 'dart:async';
import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Category_Model/category_model.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var selectedCategory = Rx<CategoryModel?>(null);
  var isLoading = false.obs;
  var isUploading = false.obs;
  var searchQuery = ''.obs;
  var selectedTabIndex = 0.obs;
  var selectedImageFile = Rx<dynamic>(null);
  var imagePreviewUrl = ''.obs;
  var uploadProgress = 0.0.obs;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final iconController = TextEditingController();
  final colorController = TextEditingController();
  final subNameController = TextEditingController();
  final subDescriptionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final bool isWeb = GetPlatform.isWeb;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    iconController.dispose();
    colorController.dispose();
    subNameController.dispose();
    subDescriptionController.dispose();
    super.onClose();
  }

  // Load categories from Firestore
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;

      final QuerySnapshot categorySnapshot =
          await _firestore
              .collection('categories')
              .orderBy('createdAt', descending: false)
              .get();

      categories.value =
          categorySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return CategoryModel.fromFirestore(doc.id, data);
          }).toList();

      print('✅ Loaded ${categories.length} categories');
    } catch (e) {
      print('Error loading categories: $e');
      _showError('Failed to load categories');
    } finally {
      isLoading.value = false;
    }
  }

  // Pick image for category
  Future<void> pickImage() async {
    try {
      if (isWeb) {
        final html.FileUploadInputElement uploadInput =
            html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();

        uploadInput.onChange.listen((event) {
          final files = uploadInput.files;
          if (files != null && files.isNotEmpty) {
            final file = files.first;
            final reader = html.FileReader();
            reader.readAsDataUrl(file);
            reader.onLoadEnd.listen((event) {
              imagePreviewUrl.value = reader.result as String;
              selectedImageFile.value = file;
            });
          }
        });
      } else {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
          maxWidth: 500,
        );

        if (image != null) {
          selectedImageFile.value = File(image.path);
          imagePreviewUrl.value = image.path;
          _showSuccess('Image selected successfully', duration: 1);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      _showError('Failed to pick image');
    }
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImage(dynamic imageFile, String categoryId) async {
    if (imageFile == null) return null;

    try {
      uploadProgress.value = 0;
      final String fileName =
          'categories/$categoryId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = _storage.ref().child(fileName);

      if (isWeb && imageFile is html.File) {
        final reader = html.FileReader();
        final completer = Completer<Uint8List>();
        reader.readAsArrayBuffer(imageFile);
        reader.onLoadEnd.listen((e) {
          completer.complete(reader.result as Uint8List);
        });
        final bytes = await completer.future;
        final uploadTask = storageRef.putData(bytes);
        uploadTask.snapshotEvents.listen((snapshot) {
          uploadProgress.value =
              snapshot.bytesTransferred / snapshot.totalBytes;
        });
        await uploadTask;
      } else if (imageFile is File) {
        final uploadTask = storageRef.putFile(imageFile);
        uploadTask.snapshotEvents.listen((snapshot) {
          uploadProgress.value =
              snapshot.bytesTransferred / snapshot.totalBytes;
        });
        await uploadTask;
      }

      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Add category
  Future<void> addCategory() async {
    if (nameController.text.isEmpty) {
      _showError('Please enter category name');
      return;
    }

    try {
      isUploading.value = true;
      uploadProgress.value = 0;

      final String categoryId = _firestore.collection('categories').doc().id;

      _showProgressDialog();

      String? imageUrl;
      if (selectedImageFile.value != null) {
        imageUrl = await uploadImage(selectedImageFile.value!, categoryId);
      }

      final newCategory = CategoryModel(
        id: categoryId,
        name: nameController.text,
        description: descriptionController.text,
        icon: iconController.text.isNotEmpty ? iconController.text : '🍽️',
        color:
            colorController.text.isNotEmpty ? colorController.text : '#7c3aed',
        isActive: true,
        createdAt: DateTime.now(),
        subCategories: [],
        imageUrl: imageUrl,
      );

      await _firestore
          .collection('categories')
          .doc(categoryId)
          .set(newCategory.toFirestore());
      categories.add(newCategory);

      Get.back();
      clearForm();
      _showSuccess('Category added successfully');
    } catch (e) {
      print('Error adding category: $e');
      if (Get.isDialogOpen ?? false) Get.back();
      _showError('Failed to add category');
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0;
    }
  }

  // Update category
  Future<void> updateCategory() async {
    if (selectedCategory.value == null) return;
    if (nameController.text.isEmpty) {
      _showError('Please enter category name');
      return;
    }

    try {
      isUploading.value = true;

      String? imageUrl = selectedCategory.value!.imageUrl;

      if (selectedImageFile.value != null) {
        final newImageUrl = await uploadImage(
          selectedImageFile.value!,
          selectedCategory.value!.id,
        );
        if (newImageUrl != null) imageUrl = newImageUrl;
      }

      final updatedCategory = selectedCategory.value!.copyWith(
        name: nameController.text,
        description: descriptionController.text,
        icon:
            iconController.text.isNotEmpty
                ? iconController.text
                : selectedCategory.value!.icon,
        color:
            colorController.text.isNotEmpty
                ? colorController.text
                : selectedCategory.value!.color,
        imageUrl: imageUrl,
      );

      await _firestore
          .collection('categories')
          .doc(selectedCategory.value!.id)
          .update(updatedCategory.toFirestore());

      final index = categories.indexWhere(
        (c) => c.id == selectedCategory.value!.id,
      );
      if (index != -1) {
        categories[index] = updatedCategory;
      }

      clearForm();
      Get.back();
      _showSuccess('Category updated successfully');
    } catch (e) {
      print('Error updating category: $e');
      _showError('Failed to update category');
    } finally {
      isUploading.value = false;
    }
  }

  // Delete category
  Future<void> deleteCategory(String id) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                isLoading.value = true;
                await _firestore.collection('categories').doc(id).delete();
                categories.removeWhere((c) => c.id == id);
                _showSuccess('Category deleted successfully');
              } catch (e) {
                print('Error deleting category: $e');
                _showError('Failed to delete category');
              } finally {
                isLoading.value = false;
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Add sub category
  Future<void> addSubCategory() async {
    if (selectedCategory.value == null) {
      _showError('Please select a category first');
      return;
    }

    if (subNameController.text.isEmpty) {
      _showError('Please enter sub category name');
      return;
    }

    try {
      final newSubCategory = SubCategoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: subNameController.text,
        description:
            subDescriptionController.text.isEmpty
                ? 'No description'
                : subDescriptionController.text,
        isActive: true,
        createdAt: DateTime.now(),
      );

      final updatedSubCategories = [
        ...selectedCategory.value!.subCategories,
        newSubCategory,
      ];
      final updatedCategory = selectedCategory.value!.copyWith(
        subCategories: updatedSubCategories,
      );

      await _firestore
          .collection('categories')
          .doc(selectedCategory.value!.id)
          .update(updatedCategory.toFirestore());

      final index = categories.indexWhere(
        (c) => c.id == selectedCategory.value!.id,
      );
      if (index != -1) {
        categories[index] = updatedCategory;
        selectedCategory.value = updatedCategory;
      }

      clearSubForm();
      Get.back();
      _showSuccess('Sub category added successfully');
    } catch (e) {
      print('Error adding sub category: $e');
      _showError('Failed to add sub category');
    }
  }

  // Delete sub category
  Future<void> deleteSubCategory(String categoryId, String subId) async {
    try {
      final category = categories.firstWhere((c) => c.id == categoryId);
      final updatedSubCategories =
          category.subCategories.where((sub) => sub.id != subId).toList();
      final updatedCategory = category.copyWith(
        subCategories: updatedSubCategories,
      );

      await _firestore
          .collection('categories')
          .doc(categoryId)
          .update(updatedCategory.toFirestore());

      final index = categories.indexWhere((c) => c.id == categoryId);
      if (index != -1) {
        categories[index] = updatedCategory;
        if (selectedCategory.value?.id == categoryId) {
          selectedCategory.value = updatedCategory;
        }
      }

      _showSuccess('Sub category deleted successfully');
    } catch (e) {
      print('Error deleting sub category: $e');
      _showError('Failed to delete sub category');
    }
  }

  void toggleCategoryStatus(String id) async {
    try {
      final index = categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        final updatedCategory = categories[index].copyWith(
          isActive: !categories[index].isActive,
        );
        await _firestore.collection('categories').doc(id).update({
          'isActive': updatedCategory.isActive,
        });
        categories[index] = updatedCategory;
      }
    } catch (e) {
      print('Error toggling category status: $e');
      _showError('Failed to update status');
    }
  }

  void editCategory(CategoryModel category) {
    selectedCategory.value = category;
    nameController.text = category.name;
    descriptionController.text = category.description;
    iconController.text = category.icon;
    colorController.text = category.color;
    imagePreviewUrl.value = category.imageUrl ?? '';
    selectedImageFile.value = null;
    selectedTabIndex.value = 0;
  }

  void selectCategoryForSub(CategoryModel category) {
    selectedCategory.value = category;
  }

  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) return categories.toList();
    return categories
        .where(
          (category) => category.name.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  List<CategoryModel> get activeCategories =>
      categories.where((c) => c.isActive).toList();
  List<CategoryModel> get inactiveCategories =>
      categories.where((c) => !c.isActive).toList();

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    iconController.clear();
    colorController.clear();
    imagePreviewUrl.value = '';
    selectedImageFile.value = null;
    selectedCategory.value = null;
  }

  void clearSubForm() {
    subNameController.clear();
    subDescriptionController.clear();
  }

  void _showProgressDialog() {
    Get.dialog(
      Obx(
        () => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Uploading...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: uploadProgress.value),
              const SizedBox(height: 10),
              Text('${(uploadProgress.value * 100).toStringAsFixed(0)}%'),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccess(String message, {int duration = 2}) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: duration),
    );
  }
}
