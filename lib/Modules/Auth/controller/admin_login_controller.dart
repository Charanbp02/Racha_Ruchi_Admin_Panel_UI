// lib/Modules/Auth/controller/admin_login_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/SideBar/controller/sidebar_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginController extends GetxController {
  // Observable variables
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;
  final isCheckingAuth = true.obs;
  final isSettingUp = false.obs;

  // Pre-set admin credentials
  static const String adminEmail = 'teamracharuchi@gmail.com';
  static const String adminPassword = 'Racharuchi02';

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Pre-fill the email and password
    emailController.text = adminEmail;
    passwordController.text = adminPassword;
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      isCheckingAuth.value = true;
      await loadSavedCredentials();
      await Future.delayed(const Duration(milliseconds: 100));

      // First, try to setup admin if needed
      await autoSetupAdmin();

      // Then check auth status
      await checkAuthStatus();
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      isCheckingAuth.value = false;
    }
  }

  // Auto setup admin user if not exists
  Future<void> autoSetupAdmin() async {
    if (isSettingUp.value) return;
    isSettingUp.value = true;

    try {
      debugPrint('=== AUTO SETUP ADMIN STARTED ===');

      // First, check if user already exists by trying to sign in
      User? user;

      try {
        // Try to sign in first
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        user = userCredential.user;
        debugPrint('✅ Admin already exists, signed in successfully');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // User doesn't exist, create them
          debugPrint('📝 Admin not found, creating new admin user...');
          final userCredential = await _auth.createUserWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
          user = userCredential.user;
          debugPrint('✅ Admin user created successfully');
        } else if (e.code == 'wrong-password') {
          debugPrint('⚠️ Wrong password for existing admin');
          // Password might be wrong, but user exists
          final userCredential = await _auth.signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
          user = userCredential.user;
        } else {
          debugPrint('❌ Auth error: ${e.code} - ${e.message}');
          rethrow;
        }
      }

      if (user == null) {
        throw Exception('Failed to get user');
      }

      debugPrint('👤 User UID: ${user.uid}');

      // Update display name
      if (user.displayName != 'Racha Ruchi') {
        await user.updateDisplayName('Racha Ruchi');
        debugPrint('✅ Display name updated');
      }

      // Check and create Firestore admin document
      final adminDocRef = _firestore.collection('admins').doc(user.uid);
      final adminDoc = await adminDocRef.get();

      if (!adminDoc.exists) {
        debugPrint('📝 Creating Firestore admin document...');
        await adminDocRef.set({
          'email': adminEmail,
          'isAdmin': true,
          'name': 'Racha Ruchi',
          'role': 'super_admin',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'lastLoginIp': 'mobile_app',
        });
        debugPrint('✅ Firestore admin document created');
      } else {
        debugPrint('✅ Firestore admin document already exists');
        // Update last login
        await adminDocRef.update({
          'lastLogin': FieldValue.serverTimestamp(),
          'lastLoginIp': 'mobile_app',
        });
      }

      // Save auth session
      await saveAuthToken(user.uid, adminEmail);
      await saveCredentials(adminEmail);
    } catch (e) {
      debugPrint('❌ Auto setup error: $e');
    } finally {
      isSettingUp.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Check if admin is already logged in
  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');

      if (userId == null) {
        debugPrint('No saved user ID found');
        return;
      }

      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        debugPrint('No current user found in Firebase');
        return;
      }

      if (currentUser.uid != userId) {
        debugPrint('User ID mismatch');
        return;
      }

      // Refresh token to ensure it's valid
      await currentUser.getIdToken(true);

      // Now try to read the admin document with better error handling
      await _checkAdminDocument(userId);
    } catch (e) {
      debugPrint('Check auth status error: $e');
      await clearAuthSession();
    }
  }

  // Separate method to check admin document with proper error handling
  Future<void> _checkAdminDocument(String userId) async {
    try {
      debugPrint('Checking admin document for user: $userId');

      final DocumentSnapshot adminDoc = await _firestore
          .collection('admins')
          .doc(userId)
          .get()
          .timeout(const Duration(seconds: 10));

      if (adminDoc.exists && adminDoc.data() != null) {
        final data = adminDoc.data() as Map<String, dynamic>;
        if (data['isAdmin'] == true) {
          debugPrint('Valid admin found, navigating to sidebar');
          if (Get.context != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              navigateToSidebar();
            });
          } else {
            navigateToSidebar();
          }
        } else {
          debugPrint('User is not admin, clearing session');
          await clearAuthSession();
          _showErrorSnackbar(
            'Access Denied',
            'You do not have admin privileges',
          );
        }
      } else {
        debugPrint('Admin document does not exist for user: $userId');
        // Try to create it
        await _firestore.collection('admins').doc(userId).set({
          'email': adminEmail,
          'isAdmin': true,
          'name': 'Racha Ruchi',
          'role': 'super_admin',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'lastLoginIp': 'mobile_app',
        });
        debugPrint('✅ Created missing admin document');
        navigateToSidebar();
      }
    } on FirebaseException catch (firestoreError) {
      debugPrint('Firestore error in admin check: ${firestoreError.code}');

      if (firestoreError.code == 'permission-denied') {
        debugPrint('⚠️ Permission denied - Check security rules');
        _showErrorSnackbar(
          'Permission Denied',
          'Please update Firestore rules to allow admin creation',
        );
      } else {
        _showErrorSnackbar(
          'Error',
          'Failed to verify admin status: ${firestoreError.message}',
        );
      }
      await clearAuthSession();
    } catch (e) {
      debugPrint('Unexpected error checking admin document: $e');
      _showErrorSnackbar('Error', 'An unexpected error occurred');
      await clearAuthSession();
    }
  }

  // SINGLE navigateToSidebar method
  void navigateToSidebar() {
    debugPrint('=== NAVIGATING TO SIDEBAR ===');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Get.offAllNamed('/');
        debugPrint('Get.offAllNamed("/") executed');

        if (!Get.isRegistered<SidebarController>()) {
          Get.put(SidebarController(), permanent: true);
          debugPrint('SidebarController registered');
        }

        final sidebarController = Get.find<SidebarController>();
        sidebarController.isSidebarOpen.value = true;
        sidebarController.currentRoute.value = '/dashboard';

        debugPrint(
          'Sidebar configured - isSidebarOpen: ${sidebarController.isSidebarOpen.value}',
        );
        debugPrint(
          'Sidebar configured - currentRoute: ${sidebarController.currentRoute.value}',
        );
      } catch (e) {
        debugPrint('Error navigating to sidebar: $e');
        Get.offAllNamed('/dashboard');
      }
    });
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedEmail = prefs.getString('admin_email');
      if (savedEmail != null && savedEmail.isNotEmpty) {
        emailController.text = savedEmail;
      } else {
        emailController.text = adminEmail;
      }
      rememberMe.value = prefs.getBool('remember_admin') ?? false;
    } catch (e) {
      debugPrint('Load credentials error: $e');
    }
  }

  Future<void> saveCredentials(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (rememberMe.value) {
        await prefs.setString('admin_email', email);
        await prefs.setBool('remember_admin', true);
      } else {
        await prefs.remove('admin_email');
        await prefs.remove('remember_admin');
      }
    } catch (e) {
      debugPrint('Save credentials error: $e');
    }
  }

  Future<void> saveAuthToken(String userId, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      await prefs.setString('admin_token', 'firebase_token_$userId');
      await prefs.setString('admin_email', email);
      debugPrint('Auth token saved for user: $userId');
    } catch (e) {
      debugPrint('Save auth token error: $e');
    }
  }

  Future<void> clearAuthSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('admin_token');
      await prefs.remove('user_id');
      await prefs.remove('admin_email');
      await prefs.remove('remember_admin');
      debugPrint('Auth session cleared');
    } catch (e) {
      debugPrint('Clear auth session error: $e');
    }
  }

  // Manual login (if needed)
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text;

      debugPrint('Attempting login for email: $email');

      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 30));

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('User not found');
      }

      debugPrint('User logged in: ${user.uid}');

      await _verifyAdminAndNavigate(user);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');

      String errorMessage = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage =
              'No user found with this email.\n\nAuto setup will create the user.';
          // Try auto setup
          await autoSetupAdmin();
          break;
        case 'wrong-password':
          errorMessage =
              'Wrong password provided.\n\nDefault password is: Racharuchi02';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        default:
          errorMessage = 'Authentication failed: ${e.message}';
      }

      if (errorMessage.isNotEmpty) {
        _showErrorSnackbar('Login Failed', errorMessage);
      }
    } catch (error) {
      isLoading.value = false;
      debugPrint('Login error: $error');
      _showErrorSnackbar('Error', 'An error occurred: ${error.toString()}');
    }
  }

  Future<void> _verifyAdminAndNavigate(User user) async {
    try {
      debugPrint('Verifying admin for user: ${user.uid}');

      final DocumentSnapshot adminDoc = await _firestore
          .collection('admins')
          .doc(user.uid)
          .get()
          .timeout(const Duration(seconds: 10));

      if (!adminDoc.exists) {
        debugPrint('Admin document not found, creating...');
        await _firestore.collection('admins').doc(user.uid).set({
          'email': user.email,
          'isAdmin': true,
          'name': 'Racha Ruchi',
          'role': 'super_admin',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'lastLoginIp': 'mobile_app',
        });
      }

      await saveAuthToken(user.uid, user.email ?? '');
      await saveCredentials(user.email ?? '');

      _firestore
          .collection('admins')
          .doc(user.uid)
          .update({'lastLogin': FieldValue.serverTimestamp()})
          .catchError((e) => debugPrint('Failed to update last login: $e'));

      isLoading.value = false;
      _showSuccessSnackbar('Success', 'Welcome to Admin Panel!');

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      await Future.delayed(const Duration(milliseconds: 500));
      navigateToSidebar();
    } catch (e) {
      isLoading.value = false;
      debugPrint('Error during admin verification: $e');
      _showErrorSnackbar('Error', 'An unexpected error occurred');
      await _auth.signOut();
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final trimmedEmail = value.trim();
    if (!GetUtils.isEmail(trimmedEmail)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      await clearAuthSession();
      emailController.text = adminEmail;
      passwordController.text = adminPassword;
      rememberMe.value = false;
      isLoading.value = false;

      Get.offAllNamed('/login');

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      isLoading.value = false;
      debugPrint('Logout error: $e');
      _showErrorSnackbar('Logout Failed', 'Error logging out: ${e.toString()}');
    }
  }
}
