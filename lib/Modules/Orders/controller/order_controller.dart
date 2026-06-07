import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Order_Models/order_model.dart';

class OrderController extends GetxController {
  // Observable variables
  final orders = <OrderModel>[].obs;
  final filteredOrders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final selectedOrder = Rx<OrderModel?>(null);
  final searchQuery = ''.obs;
  final selectedStatusFilter = Rx<String?>(null);
  final selectedPaymentFilter = Rx<String?>(null);
  final dateRange = Rx<DateTimeRange?>(null);

  // Statistics
  final totalOrders = 0.obs;
  final totalRevenue = 0.0.obs;
  final pendingOrders = 0.obs;
  final completedOrders = 0.obs;
  final cancelledOrders = 0.obs;
  final returnedOrders = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    isLoading.value = true;

    // Simulate API call with sample data
    Future.delayed(const Duration(milliseconds: 500), () {
      orders.value = _getSampleOrders();
      applyFilters();
      calculateStats();
      isLoading.value = false;
    });
  }

  List<OrderModel> _getSampleOrders() {
    return [
      OrderModel(
        id: '1',
        orderNumber: 'ORD-001',
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '+1 234 567 8900',
        customerAddress: '123 Main St, New York, NY 10001',
        items: [
          OrderItem(
            id: '101',
            productId: 'P001',
            productName: 'Chicken Biryani',
            productImage: 'https://via.placeholder.com/100',
            quantity: 2,
            price: 12.99,
            total: 25.98,
          ),
          OrderItem(
            id: '102',
            productId: 'P002',
            productName: 'Garlic Naan',
            productImage: 'https://via.placeholder.com/100',
            quantity: 3,
            price: 2.99,
            total: 8.97,
          ),
        ],
        subtotal: 34.95,
        tax: 5.24,
        deliveryFee: 2.99,
        discount: 5.00,
        total: 38.18,
        paymentMethod: 'Credit Card',
        paymentStatus: 'Paid',
        orderStatus: 'Processing',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        deliveryPartner: 'Fast Delivery',
        trackingId: 'TRK123456',
      ),
      OrderModel(
        id: '2',
        orderNumber: 'ORD-002',
        customerName: 'Jane Smith',
        customerEmail: 'jane@example.com',
        customerPhone: '+1 234 567 8901',
        customerAddress: '456 Oak Ave, Los Angeles, CA 90001',
        items: [
          OrderItem(
            id: '103',
            productId: 'P003',
            productName: 'Margherita Pizza',
            productImage: 'https://via.placeholder.com/100',
            quantity: 1,
            price: 15.99,
            total: 15.99,
          ),
        ],
        subtotal: 15.99,
        tax: 2.40,
        deliveryFee: 2.99,
        discount: 0,
        total: 21.38,
        paymentMethod: 'PayPal',
        paymentStatus: 'Paid',
        orderStatus: 'New',
        orderDate: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      OrderModel(
        id: '3',
        orderNumber: 'ORD-003',
        customerName: 'Mike Johnson',
        customerEmail: 'mike@example.com',
        customerPhone: '+1 234 567 8902',
        customerAddress: '789 Pine Rd, Chicago, IL 60601',
        items: [
          OrderItem(
            id: '104',
            productId: 'P004',
            productName: 'Butter Chicken',
            productImage: 'https://via.placeholder.com/100',
            quantity: 1,
            price: 14.99,
            total: 14.99,
          ),
          OrderItem(
            id: '105',
            productId: 'P005',
            productName: 'Jeera Rice',
            productImage: 'https://via.placeholder.com/100',
            quantity: 2,
            price: 4.99,
            total: 9.98,
          ),
        ],
        subtotal: 24.97,
        tax: 3.75,
        deliveryFee: 2.99,
        discount: 0,
        total: 31.71,
        paymentMethod: 'Cash on Delivery',
        paymentStatus: 'Pending',
        orderStatus: 'New',
        orderDate: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      OrderModel(
        id: '4',
        orderNumber: 'ORD-004',
        customerName: 'Sarah Williams',
        customerEmail: 'sarah@example.com',
        customerPhone: '+1 234 567 8903',
        customerAddress: '321 Elm St, Houston, TX 77001',
        items: [
          OrderItem(
            id: '106',
            productId: 'P006',
            productName: 'Chocolate Cake',
            productImage: 'https://via.placeholder.com/100',
            quantity: 1,
            price: 8.99,
            total: 8.99,
          ),
        ],
        subtotal: 8.99,
        tax: 1.35,
        deliveryFee: 2.99,
        discount: 0,
        total: 13.33,
        paymentMethod: 'Credit Card',
        paymentStatus: 'Paid',
        orderStatus: 'Completed',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        deliveryDate: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      OrderModel(
        id: '5',
        orderNumber: 'ORD-005',
        customerName: 'David Brown',
        customerEmail: 'david@example.com',
        customerPhone: '+1 234 567 8904',
        customerAddress: '654 Cedar Ln, Phoenix, AZ 85001',
        items: [
          OrderItem(
            id: '107',
            productId: 'P007',
            productName: 'Veg Burger',
            productImage: 'https://via.placeholder.com/100',
            quantity: 2,
            price: 6.99,
            total: 13.98,
          ),
        ],
        subtotal: 13.98,
        tax: 2.10,
        deliveryFee: 2.99,
        discount: 0,
        total: 19.07,
        paymentMethod: 'Credit Card',
        paymentStatus: 'Paid',
        orderStatus: 'Cancelled',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        cancellationReason: 'Customer changed mind',
      ),
      OrderModel(
        id: '6',
        orderNumber: 'ORD-006',
        customerName: 'Emily Davis',
        customerEmail: 'emily@example.com',
        customerPhone: '+1 234 567 8905',
        customerAddress: '987 Maple Dr, Philadelphia, PA 19101',
        items: [
          OrderItem(
            id: '108',
            productId: 'P008',
            productName: 'Pasta Alfredo',
            productImage: 'https://via.placeholder.com/100',
            quantity: 1,
            price: 13.99,
            total: 13.99,
          ),
        ],
        subtotal: 13.99,
        tax: 2.10,
        deliveryFee: 2.99,
        discount: 0,
        total: 19.08,
        paymentMethod: 'Credit Card',
        paymentStatus: 'Refunded',
        orderStatus: 'Returned',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        returnReason: 'Item damaged',
        returnStatus: 'Refund Initiated',
      ),
    ];
  }

  void applyFilters() {
    var filtered = List<OrderModel>.from(orders);

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered.where((order) {
            return order.orderNumber.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                order.customerName.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                order.customerEmail.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                );
          }).toList();
    }

    // Status filter
    if (selectedStatusFilter.value != null &&
        selectedStatusFilter.value!.isNotEmpty) {
      filtered =
          filtered
              .where((order) => order.orderStatus == selectedStatusFilter.value)
              .toList();
    }

    // Payment filter
    if (selectedPaymentFilter.value != null &&
        selectedPaymentFilter.value!.isNotEmpty) {
      filtered =
          filtered
              .where(
                (order) => order.paymentStatus == selectedPaymentFilter.value,
              )
              .toList();
    }

    // Date range filter
    if (dateRange.value != null) {
      filtered =
          filtered.where((order) {
            return order.orderDate.isAfter(dateRange.value!.start) &&
                order.orderDate.isBefore(
                  dateRange.value!.end.add(const Duration(days: 1)),
                );
          }).toList();
    }

    filteredOrders.value = filtered;
  }

  void calculateStats() {
    totalOrders.value = orders.length;
    totalRevenue.value = orders.fold(0.0, (sum, order) => sum + order.total);
    pendingOrders.value = orders.where((o) => o.orderStatus == 'New').length;
    completedOrders.value =
        orders.where((o) => o.orderStatus == 'Completed').length;
    cancelledOrders.value =
        orders.where((o) => o.orderStatus == 'Cancelled').length;
    returnedOrders.value =
        orders.where((o) => o.orderStatus == 'Returned').length;
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      orders[index] = orders[index].copyWith(orderStatus: newStatus);
      applyFilters();
      calculateStats();
      Get.snackbar(
        'Success',
        'Order status updated to $newStatus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void updatePaymentStatus(String orderId, String newStatus) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      orders[index] = orders[index].copyWith(paymentStatus: newStatus);
      applyFilters();
      Get.snackbar(
        'Success',
        'Payment status updated to $newStatus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void cancelOrder(String orderId, String reason) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      orders[index] = orders[index].copyWith(
        orderStatus: 'Cancelled',
        cancellationReason: reason,
      );
      applyFilters();
      calculateStats();
      Get.snackbar(
        'Success',
        'Order cancelled successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void processReturn(String orderId, String reason) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      orders[index] = orders[index].copyWith(
        orderStatus: 'Returned',
        returnReason: reason,
        returnStatus: 'Return Requested',
      );
      applyFilters();
      calculateStats();
      Get.snackbar(
        'Success',
        'Return request processed',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  List<OrderModel> getOrdersByStatus(String status) {
    return orders.where((order) => order.orderStatus == status).toList();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedStatusFilter.value = null;
    selectedPaymentFilter.value = null;
    dateRange.value = null;
    applyFilters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void setStatusFilter(String? status) {
    selectedStatusFilter.value = status;
    applyFilters();
  }

  void setPaymentFilter(String? payment) {
    selectedPaymentFilter.value = payment;
    applyFilters();
  }

  void setDateRange(DateTimeRange? range) {
    dateRange.value = range;
    applyFilters();
  }
}
