import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Order_Models/order_model.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/controller/order_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/order_detail_view.dart';

class AllOrdersView extends StatelessWidget {
  const AllOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return Column(
      children: [
        _buildFilters(controller),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredOrders.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.filteredOrders.length,
              itemBuilder: (context, index) {
                final order = controller.filteredOrders[index];
                return _buildOrderCard(controller, order);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilters(OrderController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                hintText: "Search by order #, customer name or email...",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildFilterDropdown(
            controller,
            value: controller.selectedPaymentFilter.value,
            items: ['Pending', 'Paid', 'Failed', 'Refunded'],
            hint: 'Payment Status',
            onChanged: controller.setPaymentFilter,
          ),
          const SizedBox(width: 12),
          _buildDateRangePicker(controller),
          const SizedBox(width: 12),
          if (controller.searchQuery.value.isNotEmpty ||
              controller.selectedStatusFilter.value != null ||
              controller.selectedPaymentFilter.value != null ||
              controller.dateRange.value != null)
            IconButton(
              onPressed: controller.clearFilters,
              icon: const Icon(Iconsax.close_circle),
              color: Colors.red,
              tooltip: 'Clear Filters',
            ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    OrderController controller, {
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: GoogleFonts.poppins(fontSize: 13)),
          items: [
            const DropdownMenuItem(value: null, child: Text('All')),
            ...items.map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: GoogleFonts.poppins(fontSize: 13)),
              ),
            ),
          ],
          onChanged: onChanged,
          icon: const Icon(Iconsax.arrow_down_1, size: 18),
        ),
      ),
    );
  }

  Widget _buildDateRangePicker(OrderController controller) {
    return InkWell(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: Get.context!,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          controller.setDateRange(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Iconsax.calendar, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Obx(
              () => Text(
                controller.dateRange.value == null
                    ? 'Select Date Range'
                    : '${_formatDate(controller.dateRange.value!.start)} - ${_formatDate(controller.dateRange.value!.end)}',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildOrderCard(OrderController controller, OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.to(() => OrderDetailView(order: order)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          order.orderStatus,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getStatusIcon(order.orderStatus),
                        color: _getStatusColor(order.orderStatus),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                order.orderNumber,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff1e1e2e),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    order.orderStatus,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  order.orderStatus,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(order.orderStatus),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.customerName,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${order.items.length} items • ${_formatDate(order.orderDate)}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${order.total.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff7c3aed),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getPaymentColor(
                              order.paymentStatus,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.paymentStatus,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: _getPaymentColor(order.paymentStatus),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (order.orderStatus == 'New')
                      _buildActionButton(
                        'Process',
                        Iconsax.refresh,
                        Colors.blue,
                        () => controller.updateOrderStatus(
                          order.id,
                          'Processing',
                        ),
                      ),
                    if (order.orderStatus == 'Processing')
                      _buildActionButton(
                        'Complete',
                        Iconsax.tick_circle,
                        Colors.green,
                        () =>
                            controller.updateOrderStatus(order.id, 'Completed'),
                      ),
                    if (order.orderStatus == 'New' ||
                        order.orderStatus == 'Processing')
                      _buildActionButton(
                        'Cancel',
                        Iconsax.close_circle,
                        Colors.red,
                        () => _showCancelDialog(controller, order),
                      ),
                    _buildActionButton(
                      'View Details',
                      Iconsax.eye,
                      Colors.grey,
                      () => Get.to(() => OrderDetailView(order: order)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: color),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _showCancelDialog(OrderController controller, OrderModel order) {
    final reasonController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this order?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Cancellation reason (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('No')),
          TextButton(
            onPressed: () {
              controller.cancelOrder(order.id, reasonController.text);
              Get.back();
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'Returned':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'New':
        return Iconsax.add_circle;
      case 'Processing':
        return Iconsax.refresh;
      case 'Completed':
        return Iconsax.tick_circle;
      case 'Cancelled':
        return Iconsax.close_circle;
      case 'Returned':
        return Iconsax.arrow_left;
      default:
        return Iconsax.document_text;
    }
  }

  Color _getPaymentColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Paid':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      case 'Refunded':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.shopping_cart, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No orders found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your filters",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
