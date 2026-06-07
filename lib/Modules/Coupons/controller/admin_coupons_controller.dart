// lib/Modules/Coupons/controller/admin_coupons_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Coupons_Model/coupons_models.dart';

class AdminCouponsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var coupons = <CouponModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  StreamSubscription<QuerySnapshot>? _couponsSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeRealtimeCoupons();
  }

  @override
  void onClose() {
    _couponsSubscription?.cancel();
    super.onClose();
  }

  // Real-time listener for admin panel
  void _initializeRealtimeCoupons() {
    isLoading.value = true;

    _couponsSubscription = _firestore
        .collection('coupons')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            coupons.value =
                snapshot.docs.map((doc) {
                  return CouponModel.fromMap(doc.data(), doc.id);
                }).toList();
            isLoading.value = false;
            print('✅ Admin coupons updated: ${coupons.length} coupons');
          },
          onError: (error) {
            print('❌ Error loading coupons: $error');
            isLoading.value = false;
          },
        );
  }

  List<CouponModel> get filteredCoupons {
    if (searchQuery.value.isEmpty) return coupons;
    return coupons.where((coupon) {
      return coupon.code.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          coupon.title.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  // Create coupon - instantly appears in user app
  Future<void> createCoupon({
    required String code,
    required String title,
    required String description,
    required String discount,
    required double minOrder,
    required double maxDiscount,
    required DateTime validTill,
    required CouponType type,
    required int usageLimit,
  }) async {
    isLoading.value = true;

    try {
      final couponRef = _firestore.collection('coupons').doc();

      final coupon = CouponModel(
        id: couponRef.id,
        code: code.toUpperCase(),
        title: title,
        description: description,
        discount: discount,
        minOrder: minOrder,
        maxDiscount: maxDiscount,
        validTill: validTill,
        type: type,
        isNew: true,
        isTrending: false,
        isExpired: false,
        isEnabled: true,
        usageLimit: usageLimit,
        usedCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await couponRef.set(coupon.toMap());

      Get.back();
      Get.snackbar(
        'Success',
        'Coupon created successfully! Users will see it instantly.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('Error creating coupon: $e');
      Get.snackbar(
        'Error',
        'Failed to create coupon',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update coupon - instantly updates in user app
  Future<void> updateCoupon(CouponModel coupon) async {
    isLoading.value = true;

    try {
      final couponRef = _firestore.collection('coupons').doc(coupon.id);
      await couponRef.update(coupon.toMap());

      Get.back();
      Get.snackbar(
        'Success',
        'Coupon updated successfully! Changes are live.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating coupon: $e');
      Get.snackbar(
        'Error',
        'Failed to update coupon',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete coupon - instantly removed from user app
  Future<void> deleteCoupon(String id) async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Coupon'),
        content: const Text('Are you sure you want to delete this coupon?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              isLoading.value = true;

              try {
                await _firestore.collection('coupons').doc(id).delete();
                Get.snackbar(
                  'Success',
                  'Coupon deleted successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                print('Error deleting coupon: $e');
                Get.snackbar(
                  'Error',
                  'Failed to delete coupon',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } finally {
                isLoading.value = false;
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Toggle coupon status - instantly enabled/disabled in user app
  Future<void> toggleCouponStatus(String id, bool currentStatus) async {
    isLoading.value = true;

    try {
      await _firestore.collection('coupons').doc(id).update({
        'isEnabled': !currentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Coupon ${!currentStatus ? 'enabled' : 'disabled'} successfully. Users will see the change instantly.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error toggling coupon status: $e');
      Get.snackbar(
        'Error',
        'Failed to update coupon status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Bulk update - enable/disable multiple coupons at once
  Future<void> bulkUpdateStatus(List<String> couponIds, bool enable) async {
    isLoading.value = true;

    try {
      final batch = _firestore.batch();

      for (var id in couponIds) {
        final ref = _firestore.collection('coupons').doc(id);
        batch.update(ref, {
          'isEnabled': enable,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      Get.snackbar(
        'Success',
        '${couponIds.length} coupons ${enable ? 'enabled' : 'disabled'} successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error in bulk update: $e');
      Get.snackbar(
        'Error',
        'Failed to update coupons',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
