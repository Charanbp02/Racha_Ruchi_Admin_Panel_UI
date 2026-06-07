import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/controller/order_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/all_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/cancelled_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/completed_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/new_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/processing_orders_view.dart';
import 'package:racha_ruchi_admin_panel/Modules/Orders/view/returns_view.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xfff5f3ff),
      body: Column(
        children: [
          _buildHeader(controller),
          Expanded(
            child: Obx(() {
              switch (controller.selectedStatusFilter.value) {
                case 'New':
                  return const NewOrdersView();
                case 'Processing':
                  return const ProcessingOrdersView();
                case 'Completed':
                  return const CompletedOrdersView();
                case 'Cancelled':
                  return const CancelledOrdersView();
                case 'Returned':
                  return const ReturnsView();
                default:
                  return const AllOrdersView();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(OrderController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withValues(alpha: 0.05)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Management",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              foreground:
                  Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xff7c3aed), Color(0xffec4899)],
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Track and manage all customer orders",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          _buildStatusTabs(controller),
        ],
      ),
    );
  }

  Widget _buildStatusTabs(OrderController controller) {
    final tabs = [
      {'label': 'All Orders', 'status': null, 'icon': Iconsax.document_text},
      {'label': 'New', 'status': 'New', 'icon': Iconsax.add_circle},
      {'label': 'Processing', 'status': 'Processing', 'icon': Iconsax.refresh},
      {
        'label': 'Completed',
        'status': 'Completed',
        'icon': Iconsax.tick_circle,
      },
      {
        'label': 'Cancelled',
        'status': 'Cancelled',
        'icon': Iconsax.close_circle,
      },
      {'label': 'Returns', 'status': 'Returned', 'icon': Iconsax.arrow_left},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children:
            tabs.map((tab) {
              return Obx(
                () => Expanded(
                  child: GestureDetector(
                    onTap:
                        () => controller.setStatusFilter(
                          tab['status'] as String?,
                        ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            controller.selectedStatusFilter.value ==
                                    tab['status']
                                ? const Color(0xff7c3aed)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tab['icon'] as IconData,
                            size: 18,
                            color:
                                controller.selectedStatusFilter.value ==
                                        tab['status']
                                    ? Colors.white
                                    : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tab['label'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color:
                                  controller.selectedStatusFilter.value ==
                                          tab['status']
                                      ? Colors.white
                                      : Colors.grey[600],
                            ),
                          ),
                          if (tab['status'] != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    controller.selectedStatusFilter.value ==
                                            tab['status']
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getOrderCount(
                                  controller,
                                  tab['status'] as String,
                                ).toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      controller.selectedStatusFilter.value ==
                                              tab['status']
                                          ? Colors.white
                                          : Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  int _getOrderCount(OrderController controller, String status) {
    return controller.orders.where((o) => o.orderStatus == status).length;
  }
}
