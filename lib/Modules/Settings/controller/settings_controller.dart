import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // Observable variables
  final adminName = ''.obs;
  final adminEmail = ''.obs;
  final isDarkMode = false.obs;
  final notificationsEnabled = true.obs;
  final language = 'English'.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Loading states
  final isLoading = false.obs;
  final isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAdminData();
  }

  // Load admin data from Firestore
  Future<void> loadAdminData() async {
    try {
      isLoading.value = true;

      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        debugPrint('No user logged in');
        return;
      }

      final DocumentSnapshot adminDoc =
          await _firestore.collection('admins').doc(currentUser.uid).get();

      if (adminDoc.exists) {
        final data = adminDoc.data() as Map<String, dynamic>;
        adminName.value = data['name'] ?? 'Admin User';
        adminEmail.value = data['email'] ?? currentUser.email ?? '';
      } else {
        adminName.value = 'Admin User';
        adminEmail.value = currentUser.email ?? '';
      }

      // Load saved preferences
      await loadPreferences();
    } catch (e) {
      debugPrint('Error loading admin data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load user preferences from local storage
  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDarkMode.value = prefs.getBool('dark_mode') ?? false;
      notificationsEnabled.value = prefs.getBool('notifications') ?? true;
      language.value = prefs.getString('language') ?? 'English';
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  // Save preferences to local storage
  Future<void> savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('dark_mode', isDarkMode.value);
      await prefs.setBool('notifications', notificationsEnabled.value);
      await prefs.setString('language', language.value);
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  // Update profile
  Future<void> updateProfile(String newName) async {
    if (newName.isEmpty || newName == adminName.value) {
      return;
    }

    try {
      isUpdating.value = true;

      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Update in Firestore
      await _firestore.collection('admins').doc(currentUser.uid).update({
        'name': newName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local observable
      adminName.value = newName;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validate passwords
    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'New passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isUpdating.value = true;

      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Re-authenticate user
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to change password';
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Current password is incorrect';
          break;
        case 'weak-password':
          errorMessage = 'New password is too weak';
          break;
        case 'requires-recent-login':
          errorMessage = 'Please login again to change password';
          break;
        default:
          errorMessage = e.message ?? 'Authentication failed';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error changing password: $e');
      Get.snackbar(
        'Error',
        'Failed to change password: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Toggle dark mode
  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    savePreferences();
    // Apply theme change
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  // Toggle notifications
  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    savePreferences();
  }

  // Change language
  void changeLanguage(String newLanguage) {
    language.value = newLanguage;
    savePreferences();
    // Update app locale if needed
    // Get.updateLocale(Locale(newLanguage.toLowerCase()));
  }

  // Logout
  Future<void> logout() async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Sign out from Firebase
      await _auth.signOut();

      // Close dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Clear controllers
      adminName.value = '';
      adminEmail.value = '';

      // Navigate to login
      Get.offAllNamed('/login');

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      debugPrint('Logout error: $e');
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      isUpdating.value = true;

      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Delete admin document from Firestore
      await _firestore.collection('admins').doc(user.uid).delete();

      // Delete user from Authentication
      await user.delete();

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Get.snackbar(
        'Account Deleted',
        'Your account has been permanently deleted',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate to login
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed('/login');
      });
    } catch (e) {
      debugPrint('Error deleting account: $e');
      Get.snackbar(
        'Error',
        'Failed to delete account: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Get initials for avatar
  String getInitials() {
    String name = adminName.value;
    if (name.isEmpty) return 'A';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
