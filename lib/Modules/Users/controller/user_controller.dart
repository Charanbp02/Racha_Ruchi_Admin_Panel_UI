import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Users_Model/user_model.dart';

class UserController extends GetxController {
  // Observable variables
  final users = <UserModel>[].obs;
  final filteredUsers = <UserModel>[].obs;
  final roles = <UserRole>[].obs;
  final permissions = <Permission>[].obs;
  final userReports = <UserReport>[].obs;

  var selectedTabIndex = 0.obs;
  final isLoading = false.obs;
  final selectedUser = Rx<UserModel?>(null);
  final selectedRole = Rx<UserRole?>(null);
  final searchQuery = ''.obs;
  final selectedRoleFilter = Rx<String?>(null);
  final selectedStatusFilter = Rx<String?>(null);

  // Statistics
  final totalUsers = 0.obs;
  final activeUsers = 0.obs;
  final blockedUsers = 0.obs;
  final pendingReports = 0.obs;

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final roleController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  // Role form controllers
  final roleNameController = TextEditingController();
  final roleDescriptionController = TextEditingController();

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    loadRoles();
    loadPermissions();
    loadUserReports();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    roleController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    roleNameController.dispose();
    roleDescriptionController.dispose();
    super.onClose();
  }

  // Load users from Firestore
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;

      final QuerySnapshot userSnapshot =
          await _firestore
              .collection('users')
              .orderBy('createdAt', descending: true)
              .get();

      users.value =
          userSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return UserModel.fromFirestore(doc.id, data);
          }).toList();

      applyFilters();
      calculateStats();
    } catch (e) {
      print('Error loading users: $e');
      Get.snackbar(
        'Error',
        'Failed to load users: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load roles from Firestore
  Future<void> loadRoles() async {
    try {
      final QuerySnapshot roleSnapshot =
          await _firestore.collection('roles').get();

      roles.value =
          roleSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return UserRole.fromFirestore(doc.id, data);
          }).toList();
    } catch (e) {
      print('Error loading roles: $e');
    }
  }

  // Load permissions from Firestore
  Future<void> loadPermissions() async {
    try {
      final QuerySnapshot permissionSnapshot =
          await _firestore.collection('permissions').get();

      permissions.value =
          permissionSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Permission.fromFirestore(doc.id, data);
          }).toList();
    } catch (e) {
      print('Error loading permissions: $e');
    }
  }

  // Load user reports from Firestore
  Future<void> loadUserReports() async {
    try {
      final QuerySnapshot reportSnapshot =
          await _firestore
              .collection('user_reports')
              .orderBy('createdAt', descending: true)
              .get();

      userReports.value =
          reportSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return UserReport.fromFirestore(doc.id, data);
          }).toList();

      calculateReportStats();
    } catch (e) {
      print('Error loading reports: $e');
    }
  }

  void calculateStats() {
    totalUsers.value = users.length;
    activeUsers.value = users.where((u) => u.status == 'active').length;
    blockedUsers.value = users.where((u) => u.status == 'blocked').length;
  }

  void calculateReportStats() {
    pendingReports.value =
        userReports.where((r) => r.status == 'pending').length;
  }

  void applyFilters() {
    var filtered = List<UserModel>.from(users);

    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered.where((user) {
            return user.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                user.email.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                user.phone.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                );
          }).toList();
    }

    if (selectedRoleFilter.value != null &&
        selectedRoleFilter.value!.isNotEmpty) {
      filtered =
          filtered
              .where((user) => user.role == selectedRoleFilter.value)
              .toList();
    }

    if (selectedStatusFilter.value != null &&
        selectedStatusFilter.value!.isNotEmpty) {
      filtered =
          filtered
              .where((user) => user.status == selectedStatusFilter.value)
              .toList();
    }

    filteredUsers.value = filtered;
  }

  // Add user to Firestore
  Future<void> addUser() async {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter user name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      final String uid = userCredential.user!.uid;

      // Create user document in Firestore
      final newUser = UserModel(
        id: uid,
        name: nameController.text,
        email: emailController.text.trim(),
        phone: phoneController.text,
        avatar:
            'https://ui-avatars.com/api/?background=7c3aed&color=fff&name=${nameController.text[0]}',
        role:
            roleController.text.isNotEmpty
                ? roleController.text.toLowerCase()
                : 'user',
        status: 'active',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        profile: {
          'address': addressController.text,
          'city': cityController.text,
          'state': stateController.text,
          'zipCode': zipCodeController.text,
        },
        permissions: ['view_products', 'place_orders'],
        orderCount: 0,
        totalSpent: 0,
        reviewCount: 0,
        reportCount: 0,
      );

      await _firestore.collection('users').doc(uid).set(newUser.toFirestore());

      users.add(newUser);
      applyFilters();
      calculateStats();
      clearForm();

      Get.back();
      Get.snackbar(
        'Success',
        'User added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error adding user: $e');
      Get.snackbar(
        'Error',
        'Failed to add user: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update user in Firestore
  Future<void> updateUser() async {
    if (selectedUser.value == null) return;

    try {
      isLoading.value = true;

      final updatedUser = selectedUser.value!.copyWith(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        role: roleController.text.toLowerCase(),
        profile: {
          'address': addressController.text,
          'city': cityController.text,
          'state': stateController.text,
          'zipCode': zipCodeController.text,
        },
      );

      await _firestore
          .collection('users')
          .doc(selectedUser.value!.id)
          .update(updatedUser.toFirestore());

      final index = users.indexWhere((u) => u.id == selectedUser.value!.id);
      if (index != -1) {
        users[index] = updatedUser;
      }

      applyFilters();
      clearForm();

      Get.back();
      Get.snackbar(
        'Success',
        'User updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating user: $e');
      Get.snackbar(
        'Error',
        'Failed to update user',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete user from Firestore
  Future<void> deleteUser(String id) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: const Text(
          'Are you sure you want to delete this user? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                isLoading.value = true;

                await _firestore.collection('users').doc(id).delete();

                users.removeWhere((u) => u.id == id);
                applyFilters();
                calculateStats();

                Get.snackbar(
                  'Success',
                  'User deleted successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                print('Error deleting user: $e');
                Get.snackbar(
                  'Error',
                  'Failed to delete user',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
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

  // Block user in Firestore
  Future<void> blockUser(String id, String reason) async {
    try {
      isLoading.value = true;

      await _firestore.collection('users').doc(id).update({
        'status': 'blocked',
        'blockedAt': FieldValue.serverTimestamp(),
        'blockedReason': reason,
      });

      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = users[index].copyWith(
          status: 'blocked',
          blockedAt: DateTime.now(),
          blockedReason: reason,
        );
      }

      applyFilters();
      calculateStats();

      Get.snackbar(
        'Success',
        'User blocked successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error blocking user: $e');
      Get.snackbar(
        'Error',
        'Failed to block user',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Unblock user in Firestore
  Future<void> unblockUser(String id) async {
    try {
      isLoading.value = true;

      await _firestore.collection('users').doc(id).update({
        'status': 'active',
        'blockedAt': FieldValue.delete(),
        'blockedReason': FieldValue.delete(),
      });

      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = users[index].copyWith(
          status: 'active',
          blockedAt: null,
          blockedReason: null,
        );
      }

      applyFilters();
      calculateStats();

      Get.snackbar(
        'Success',
        'User unblocked successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error unblocking user: $e');
      Get.snackbar(
        'Error',
        'Failed to unblock user',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void editUser(UserModel user) {
    selectedUser.value = user;
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;
    roleController.text = user.role;
    addressController.text = user.profile['address'] ?? '';
    cityController.text = user.profile['city'] ?? '';
    stateController.text = user.profile['state'] ?? '';
    zipCodeController.text = user.profile['zipCode'] ?? '';
  }

  void addRole() async {
    if (roleNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter role name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final newRole = UserRole(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: roleNameController.text,
        description: roleDescriptionController.text,
        userCount: 0,
        permissions: [],
        isDefault: false,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('roles')
          .doc(newRole.id)
          .set(newRole.toFirestore());

      roles.add(newRole);
      roleNameController.clear();
      roleDescriptionController.clear();

      Get.snackbar(
        'Success',
        'Role added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error adding role: $e');
      Get.snackbar(
        'Error',
        'Failed to add role',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void deleteRole(String id) async {
    try {
      await _firestore.collection('roles').doc(id).delete();
      roles.removeWhere((r) => r.id == id);
      Get.snackbar(
        'Success',
        'Role deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting role: $e');
      Get.snackbar(
        'Error',
        'Failed to delete role',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void updatePermissions(String permissionId, bool isEnabled) {
    final index = permissions.indexWhere((p) => p.id == permissionId);
    if (index != -1) {
      permissions[index] = permissions[index].copyWith(isEnabled: isEnabled);
      _firestore.collection('permissions').doc(permissionId).update({
        'isEnabled': isEnabled,
      });
    }
  }

  void resolveReport(String reportId, String resolution) async {
    try {
      await _firestore.collection('user_reports').doc(reportId).update({
        'status': 'resolved',
        'resolvedAt': FieldValue.serverTimestamp(),
        'resolution': resolution,
      });

      final index = userReports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        userReports[index] = UserReport(
          id: userReports[index].id,
          userId: userReports[index].userId,
          userName: userReports[index].userName,
          userEmail: userReports[index].userEmail,
          reporterId: userReports[index].reporterId,
          reporterName: userReports[index].reporterName,
          reason: userReports[index].reason,
          description: userReports[index].description,
          status: 'resolved',
          createdAt: userReports[index].createdAt,
          resolvedAt: DateTime.now(),
          resolution: resolution,
        );
      }
      calculateReportStats();
      Get.snackbar(
        'Success',
        'Report resolved',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error resolving report: $e');
      Get.snackbar(
        'Error',
        'Failed to resolve report',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearForm() {
    selectedUser.value = null;
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    roleController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    zipCodeController.clear();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void setRoleFilter(String? role) {
    selectedRoleFilter.value = role;
    applyFilters();
  }

  void setStatusFilter(String? status) {
    selectedStatusFilter.value = status;
    applyFilters();
  }

  List<UserModel> getActiveUsers() {
    return users.where((u) => u.status == 'active').toList();
  }

  List<UserModel> getBlockedUsers() {
    return users.where((u) => u.status == 'blocked').toList();
  }

  String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
