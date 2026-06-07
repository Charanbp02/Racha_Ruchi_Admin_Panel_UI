import 'dart:async';
import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Banner_Model/banner_model.dart';

class BannerController extends GetxController {
  // Observable variables
  final banners = <BannerModel>[].obs;
  final filteredBanners = <BannerModel>[].obs;
  final isLoading = false.obs;
  final isUploading = false.obs;
  final selectedType = 'all'.obs;
  final searchQuery = ''.obs;
  final uploadProgress = 0.0.obs;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final orderController = TextEditingController();
  final typeController = TextEditingController();
  final linkController = TextEditingController();

  // Selected banner for editing
  final selectedBanner = Rx<BannerModel?>(null);
  final selectedImageFile = Rx<dynamic>(null);
  final imagePreviewUrl = ''.obs;
  final isLocalImage = false.obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Real-time listener subscription
  StreamSubscription<QuerySnapshot>? _bannersSubscription;

  // Banner types
  final List<String> bannerTypes = ['home', 'promo', 'category', 'offer'];

  // Platform check
  final bool isWeb = GetPlatform.isWeb;

  @override
  void onInit() {
    super.onInit();
    _listenToBannersRealtime(); // Use real-time listener instead of one-time load
  }

  @override
  void onClose() {
    // Cancel subscription to avoid memory leaks
    _bannersSubscription?.cancel();

    // Dispose controllers
    titleController.dispose();
    descriptionController.dispose();
    orderController.dispose();
    typeController.dispose();
    linkController.dispose();
    super.onClose();
  }

  // Real-time listener for banners
  void _listenToBannersRealtime() {
    try {
      isLoading.value = true;

      // Set up real-time listener with ordering
      _bannersSubscription = _firestore
          .collection('banners')
          .orderBy('order')
          .snapshots()
          .listen(
            (QuerySnapshot snapshot) {
              // Transform snapshot to banner models
              final List<BannerModel> updatedBanners =
                  snapshot.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return BannerModel.fromFirestore(doc.id, data);
                  }).toList();

              // Update observable list
              banners.value = updatedBanners;

              // Apply current filters
              applyFilters();

              // Log for debugging
              print(
                '✅ Banners updated in real-time: ${updatedBanners.length} banners',
              );

              isLoading.value = false;
            },
            onError: (error) {
              print('❌ Error in real-time listener: $error');
              isLoading.value = false;
              _showError('Failed to load banners: ${error.toString()}');
            },
          );

      print('✅ Real-time listener started for banners');
    } catch (e) {
      print('❌ Error setting up real-time listener: $e');
      isLoading.value = false;
      _showError('Failed to setup real-time updates');
    }
  }

  // Manual refresh (optional, can be used with pull-to-refresh)
  Future<void> refreshBanners() async {
    // The real-time listener will handle updates automatically
    // This method is for manual refresh UI feedback
    await Future.delayed(const Duration(milliseconds: 500));
    _showSuccess('Banners refreshed');
  }

  void applyFilters() {
    var filtered = List<BannerModel>.from(banners);

    if (selectedType.value != 'all') {
      filtered = filtered.where((b) => b.type == selectedType.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered.where((b) {
            return b.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                b.description.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                );
          }).toList();
    }

    filteredBanners.value = filtered;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void setTypeFilter(String type) {
    selectedType.value = type;
    applyFilters();
  }

  // Pick image - Works on both Web and Mobile
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
              isLocalImage.value = true;
            });
          }
        });
      } else {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (image != null) {
          selectedImageFile.value = File(image.path);
          imagePreviewUrl.value = image.path;
          isLocalImage.value = true;
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      _showError('Failed to pick image');
    }
  }

  Future<String> uploadImage(dynamic imageFile, String bannerId) async {
    try {
      uploadProgress.value = 0;

      final String fileName =
          'banners/$bannerId/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final Reference storageRef = _storage.ref().child(fileName);

      print('Uploading to: $fileName');

      UploadTask uploadTask;

      // =========================
      // WEB UPLOAD
      // =========================
      if (isWeb && imageFile is html.File) {
        final reader = html.FileReader();
        final completer = Completer<Uint8List>();

        reader.readAsArrayBuffer(imageFile);
        reader.onLoadEnd.listen((e) {
          completer.complete(reader.result as Uint8List);
        });

        final bytes = await completer.future;

        uploadTask = storageRef.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }
      // =========================
      // MOBILE UPLOAD
      // =========================
      else if (imageFile is File) {
        uploadTask = storageRef.putFile(imageFile);
      }
      // =========================
      // ERROR CASE
      // =========================
      else {
        throw Exception('Unsupported file type');
      }

      // =========================
      // PROGRESS TRACKING
      // =========================
      uploadTask.snapshotEvents.listen((snapshot) {
        uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
      });

      // =========================
      // WAIT FOR UPLOAD COMPLETE
      // =========================
      final snapshot = await uploadTask.whenComplete(() {});

      // 🔥 IMPORTANT FIX (THIS IS THE KEY)
      final downloadUrl =
          "https://firebasestorage.googleapis.com/v0/b/racharuchi-02.firebasestorage.app/o/${Uri.encodeComponent(fileName)}?alt=media";

      print('Upload successful: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  Future<void> addBanner() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedImageFile.value == null) {
      _showError('Please select an image');
      return;
    }

    try {
      isUploading.value = true;
      uploadProgress.value = 0;

      final String bannerId = _firestore.collection('banners').doc().id;

      _showProgressDialog();

      final imageUrl = await uploadImage(selectedImageFile.value!, bannerId);

      // Make sure image URL is valid
      if (imageUrl.isEmpty) {
        throw Exception('Failed to get image URL');
      }

      final newBanner = BannerModel(
        id: bannerId,
        title: titleController.text,
        imageUrl: imageUrl, // This should be valid
        description: descriptionController.text,
        order: int.tryParse(orderController.text) ?? 0,
        isActive: true,
        type: typeController.text,
        link: linkController.text.isNotEmpty ? linkController.text : null,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await _firestore
          .collection('banners')
          .doc(bannerId)
          .set(newBanner.toFirestore());

      clearForm();

      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close progress dialog
        Get.back(); // Close form dialog
      }

      _showSuccess('Banner added successfully');
    } catch (e) {
      print('Error adding banner: $e');
      if (Get.isDialogOpen ?? false) Get.back();
      _showError('Failed to add banner: ${e.toString()}');
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0;
    }
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

  // Update banner
  Future<void> updateBanner() async {
    if (selectedBanner.value == null) return;
    if (!formKey.currentState!.validate()) return;

    try {
      isUploading.value = true;

      String imageUrl = selectedBanner.value!.imageUrl;

      if (selectedImageFile.value != null) {
        _showProgressDialog();
        final newImageUrl = await uploadImage(
          selectedImageFile.value!,
          selectedBanner.value!.id,
        );
        imageUrl = newImageUrl;
      }

      final updatedBanner = selectedBanner.value!.copyWith(
        title: titleController.text,
        imageUrl: imageUrl,
        description: descriptionController.text,
        order: int.tryParse(orderController.text) ?? 0,
        type: typeController.text,
        link: linkController.text.isNotEmpty ? linkController.text : null,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('banners')
          .doc(selectedBanner.value!.id)
          .update(updatedBanner.toFirestore());

      // Don't manually update list - real-time listener will handle it
      clearForm();

      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close progress dialog
        Get.back(); // Close form dialog
      }

      _showSuccess('Banner updated successfully');
    } catch (e) {
      print('Error updating banner: $e');
      if (Get.isDialogOpen ?? false) Get.back();
      _showError('Failed to update banner');
    } finally {
      isUploading.value = false;
    }
  }

  // Delete banner
  Future<void> deleteBanner(String id, String imageUrl) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Banner'),
        content: const Text('Are you sure you want to delete this banner?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                isLoading.value = true;

                await _firestore.collection('banners').doc(id).delete();

                // Try to delete image from Storage
                try {
                  final ref = _storage.refFromURL(imageUrl);
                  await ref.delete();
                } catch (e) {
                  print('Error deleting image: $e');
                }

                // Don't manually remove from list - real-time listener will handle it
                _showSuccess('Banner deleted successfully');
              } catch (e) {
                print('Error deleting banner: $e');
                _showError('Failed to delete banner');
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

  // Toggle banner status
  Future<void> toggleBannerStatus(String id, bool currentStatus) async {
    try {
      await _firestore.collection('banners').doc(id).update({
        'isActive': !currentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Don't manually update list - real-time listener will handle it
      _showSuccess('Banner status updated', duration: 1);
    } catch (e) {
      print('Error toggling banner status: $e');
      _showError('Failed to update status');
    }
  }

  void editBanner(BannerModel banner) {
    selectedBanner.value = banner;
    titleController.text = banner.title;
    descriptionController.text = banner.description;
    orderController.text = banner.order.toString();
    typeController.text = banner.type;
    linkController.text = banner.link ?? '';
    imagePreviewUrl.value = banner.imageUrl;
    isLocalImage.value = false;
    selectedImageFile.value = null;
  }

  void clearForm() {
    selectedBanner.value = null;
    titleController.clear();
    descriptionController.clear();
    orderController.clear();
    typeController.clear();
    linkController.clear();
    imagePreviewUrl.value = '';
    isLocalImage.value = false;
    selectedImageFile.value = null;
    uploadProgress.value = 0;
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

  Color getBannerTypeColor(String type) {
    switch (type) {
      case 'home':
        return Colors.blue;
      case 'promo':
        return Colors.orange;
      case 'category':
        return Colors.green;
      case 'offer':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getBannerTypeIcon(String type) {
    switch (type) {
      case 'home':
        return Icons.home;
      case 'promo':
        return Icons.local_offer;
      case 'category':
        return Icons.category;
      case 'offer':
        return Icons.sell;
      default:
        return Icons.image;
    }
  }
}
