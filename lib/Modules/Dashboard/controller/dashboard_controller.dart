import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardController extends GetxController {
  // Reactive states
  final RxBool showNotification = false.obs;
  final RxString notificationMessage = ''.obs;
  final RxBool isLoading = true.obs;

  // Statistics data
  final RxInt totalVideos = 0.obs;
  final RxInt pendingApprovals = 0.obs;
  final RxInt totalUsers = 0.obs;
  final RxInt newUsersThisMonth = 0.obs;
  final RxInt totalProducts = 0.obs;
  final RxInt lowStockCount = 0.obs;
  final RxInt newOrders = 0.obs;
  final RxInt revenue = 0.obs;
  final RxInt pendingTasks = 0.obs;
  final RxInt totalOrders = 0.obs;
  final RxInt newOrdersThisMonth = 0.obs;
  final RxInt totalCategories = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Admin info
  final RxString adminName = ''.obs;
  final RxString adminEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    loadAdminInfo();
  }

  // Load admin info from Firestore
  Future<void> loadAdminInfo() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot adminDoc =
            await _firestore.collection('admins').doc(user.uid).get();

        if (adminDoc.exists) {
          final data = adminDoc.data() as Map<String, dynamic>;
          adminName.value = data['name'] ?? 'Admin';
          adminEmail.value = data['email'] ?? user.email ?? '';
        } else {
          adminName.value = user.displayName ?? 'Admin';
          adminEmail.value = user.email ?? '';
        }
      }
    } catch (e) {
      print('Error loading admin info: $e');
      adminName.value = 'Admin';
    }
  }

  // Load all dashboard data from Firestore
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      // Load all data in parallel for better performance
      await Future.wait([
        _loadTotalUsers(),
        _loadNewUsersThisMonth(),
        _loadTotalProducts(),
        _loadLowStockProducts(),
        _loadTotalOrders(),
        _loadNewOrdersThisMonth(),
        _loadTotalVideos(),
        _loadTotalRevenue(),
        _loadTotalCategories(),
      ]);
    } catch (e) {
      print('Error loading dashboard data: $e');
      showNotificationMessage('Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  // Load total users count
  Future<void> _loadTotalUsers() async {
    try {
      final QuerySnapshot userSnapshot =
          await _firestore.collection('users').get();

      totalUsers.value = userSnapshot.docs.length;
    } catch (e) {
      print('Error loading total users: $e');
      totalUsers.value = 0;
    }
  }

  // Load new users this month
  Future<void> _loadNewUsersThisMonth() async {
    try {
      final DateTime startOfMonth = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      );
      final DateTime endOfMonth = DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
        0,
      );

      final QuerySnapshot userSnapshot =
          await _firestore
              .collection('users')
              .where(
                'createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
              )
              .where(
                'createdAt',
                isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth),
              )
              .get();

      newUsersThisMonth.value = userSnapshot.docs.length;
    } catch (e) {
      print('Error loading new users: $e');
      newUsersThisMonth.value = 0;
    }
  }

  // Load total products
  Future<void> _loadTotalProducts() async {
    try {
      final QuerySnapshot productSnapshot =
          await _firestore.collection('products').get();

      totalProducts.value = productSnapshot.docs.length;
    } catch (e) {
      print('Error loading products: $e');
      totalProducts.value = 0;
    }
  }

  // Load low stock products
  Future<void> _loadLowStockProducts() async {
    try {
      final QuerySnapshot productSnapshot =
          await _firestore
              .collection('products')
              .where('stock', isLessThan: 10)
              .get();

      lowStockCount.value = productSnapshot.docs.length;
    } catch (e) {
      print('Error loading low stock: $e');
      lowStockCount.value = 0;
    }
  }

  // Load total orders
  Future<void> _loadTotalOrders() async {
    try {
      final QuerySnapshot orderSnapshot =
          await _firestore.collection('orders').get();

      totalOrders.value = orderSnapshot.docs.length;
    } catch (e) {
      print('Error loading orders: $e');
      totalOrders.value = 0;
    }
  }

  // Load new orders this month
  Future<void> _loadNewOrdersThisMonth() async {
    try {
      final DateTime startOfMonth = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      );
      final DateTime endOfMonth = DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
        0,
      );

      final QuerySnapshot orderSnapshot =
          await _firestore
              .collection('orders')
              .where(
                'createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
              )
              .where(
                'createdAt',
                isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth),
              )
              .get();

      newOrdersThisMonth.value = orderSnapshot.docs.length;
    } catch (e) {
      print('Error loading new orders: $e');
      newOrdersThisMonth.value = 0;
    }
  }

  Future<void> _loadTotalVideos() async {
    try {
      final QuerySnapshot videoSnapshot =
          await _firestore.collection('recipe_videos').get();

      totalVideos.value = videoSnapshot.docs.length;
    } catch (e) {
      print('Error loading videos: $e');
      totalVideos.value = 0;
    }
  }

  // Load pending approvals
  Future<void> _loadPendingApprovals() async {
    pendingApprovals.value = 0;
  }

  // Load total revenue
  Future<void> _loadTotalRevenue() async {
    try {
      final QuerySnapshot orderSnapshot =
          await _firestore
              .collection('orders')
              .where('status', isEqualTo: 'completed')
              .get();

      double total = 0;
      for (var doc in orderSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += (data['totalAmount'] ?? 0).toDouble();
      }

      totalRevenue.value = total;
      revenue.value = total.toInt();
    } catch (e) {
      print('Error loading revenue: $e');
      totalRevenue.value = 0;
      revenue.value = 0;
    }
  }

  // Load total categories
  Future<void> _loadTotalCategories() async {
    try {
      final QuerySnapshot categorySnapshot =
          await _firestore.collection('categories').get();

      totalCategories.value = categorySnapshot.docs.length;
    } catch (e) {
      print('Error loading categories: $e');
      totalCategories.value = 0;
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboardData();
    showNotificationMessage('Dashboard refreshed');
  }

  // Show notification message
  void showNotificationMessage(String message) {
    notificationMessage.value = message;
    showNotification.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      if (showNotification.value) {
        showNotification.value = false;
      }
    });
  }

  // Navigation handlers
  void navigateTo(String route) {
    Get.toNamed(route);
  }

  void handleTotalVideosClick() {
    navigateTo('/videos');
  }

  void handlePendingApprovalsClick() {
    navigateTo('/pending-approvals');
  }

  void handleTotalUsersClick() {
    navigateTo('/users');
  }

  void handleTotalProductsClick() {
    navigateTo('/products');
  }

  void handleTotalOrdersClick() {
    navigateTo('/orders');
  }

  void handleTotalCategoriesClick() {
    navigateTo('/categories');
  }

  void handleRevenueClick() {
    showNotificationMessage("Revenue details coming soon!");
  }

  String getCurrentTime() {
    return DateTime.now().toLocal().toString().split(' ')[1].substring(0, 5);
  }

  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
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
