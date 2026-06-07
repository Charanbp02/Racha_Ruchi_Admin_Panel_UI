import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Order_Models/order_model.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/controller/order_controller.dart';

class OrderDetailView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xfff5f3ff),
      appBar: AppBar(
        title: Text(
          'Order ${order.orderNumber}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Iconsax.more, color: Colors.black),
            itemBuilder:
                (context) => [
                  if (order.orderStatus == 'New')
                    const PopupMenuItem(
                      value: 'process',
                      child: Text('Process Order'),
                    ),
                  if (order.orderStatus == 'Processing')
                    const PopupMenuItem(
                      value: 'complete',
                      child: Text('Complete Order'),
                    ),
                  if (order.orderStatus == 'New' ||
                      order.orderStatus == 'Processing')
                    const PopupMenuItem(
                      value: 'cancel',
                      child: Text('Cancel Order'),
                    ),
                  const PopupMenuItem(
                    value: 'print',
                    child: Text('Print Invoice'),
                  ),
                ],
            onSelected: (value) {
              switch (value) {
                case 'process':
                  controller.updateOrderStatus(order.id, 'Processing');
                  Get.back();
                  break;
                case 'complete':
                  controller.updateOrderStatus(order.id, 'Completed');
                  Get.back();
                  break;
                case 'cancel':
                  _showCancelDialog(controller);
                  break;
                case 'print':
                  // Implement print functionality
                  Get.snackbar('Info', 'Print feature coming soon');
                  break;
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildOrderStatus(order),
            const SizedBox(height: 24),
            _buildCustomerInfo(order),
            const SizedBox(height: 24),
            _buildOrderItems(order),
            const SizedBox(height: 24),
            _buildPaymentInfo(order),
            const SizedBox(height: 24),
            _buildOrderTimeline(order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatusStep(
                'Order Placed',
                true,
                order.orderStatus != 'Cancelled',
              ),
              _buildConnector(true),
              _buildStatusStep(
                'Processing',
                order.orderStatus == 'Processing' ||
                    order.orderStatus == 'Completed',
                order.orderStatus != 'Cancelled',
              ),
              _buildConnector(order.orderStatus == 'Completed'),
              _buildStatusStep(
                'Completed',
                order.orderStatus == 'Completed',
                order.orderStatus == 'Completed',
              ),
            ],
          ),
          if (order.orderStatus == 'Cancelled')
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Iconsax.info_circle, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Order cancelled: ${order.cancellationReason ?? "No reason provided"}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusStep(String label, bool isActive, bool isCompleted) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xff7c3aed) : Colors.grey[200],
            ),
            child: Icon(
              isCompleted ? Iconsax.tick_circle : Iconsax.timer_start,
              color: isActive ? Colors.white : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? const Color(0xff7c3aed) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xff7c3aed) : Colors.grey[300],
      ),
    );
  }

  Widget _buildCustomerInfo(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.profile_circle,
                size: 20,
                color: Color(0xff7c3aed),
              ),
              const SizedBox(width: 8),
              Text(
                'Customer Information',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow(Iconsax.user, 'Name', order.customerName),
          _infoRow(Iconsax.sms, 'Email', order.customerEmail),
          _infoRow(Iconsax.call, 'Phone', order.customerPhone),
          _infoRow(Iconsax.location, 'Address', order.customerAddress),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.box, size: 20, color: Color(0xff7c3aed)),
              const SizedBox(width: 8),
              Text(
                'Order Items',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            itemBuilder: (context, index) {
              final item = order.items[index];
              return _buildOrderItem(item);
            },
          ),
          const Divider(height: 24),
          _buildPriceRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
          _buildPriceRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
          _buildPriceRow(
            'Delivery Fee',
            '\$${order.deliveryFee.toStringAsFixed(2)}',
          ),
          if (order.discount > 0)
            _buildPriceRow(
              'Discount',
              '-\$${order.discount.toStringAsFixed(2)}',
            ),
          const Divider(height: 16),
          _buildPriceRow(
            'Total',
            '\$${order.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Iconsax.image, size: 24, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Qty: ${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.total.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isTotal ? null : Colors.grey[500],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xff7c3aed) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.card, size: 20, color: Color(0xff7c3aed)),
              const SizedBox(width: 8),
              Text(
                'Payment Information',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow(Iconsax.card, 'Method', order.paymentMethod),
          _infoRow(Iconsax.tick_circle, 'Status', order.paymentStatus),
          if (order.deliveryPartner != null)
            _infoRow(Iconsax.truck, 'Delivery Partner', order.deliveryPartner!),
          if (order.trackingId != null)
            _infoRow(Iconsax.location, 'Tracking ID', order.trackingId!),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.clock, size: 20, color: Color(0xff7c3aed)),
              const SizedBox(width: 8),
              Text(
                'Order Timeline',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _timelineItem('Order Placed', order.orderDate, true),
          if (order.orderStatus != 'New')
            _timelineItem(
              'Order Processed',
              order.orderDate.add(const Duration(minutes: 15)),
              true,
            ),
          if (order.orderStatus == 'Completed')
            _timelineItem(
              'Order Delivered',
              order.deliveryDate ??
                  order.orderDate.add(const Duration(hours: 1)),
              true,
            ),
        ],
      ),
    );
  }

  Widget _timelineItem(String title, DateTime date, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? const Color(0xff7c3aed) : Colors.grey[300],
            ),
            child: Icon(
              isCompleted ? Iconsax.tick_circle : Iconsax.timer_start,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(OrderController controller) {
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
}
