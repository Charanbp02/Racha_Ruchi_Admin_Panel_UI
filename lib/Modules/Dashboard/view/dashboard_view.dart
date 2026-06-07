import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Modules/Dashboard/controller/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff5f3ff),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshDashboard(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Obx(() {
            if (controller.isLoading.value) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER WITH ADMIN NAME
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back, ${controller.adminName.value} 👋",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff1e1e2e),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Here's what's happening with your platform today.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.calendar,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getFormattedDate(),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                /// STATS GRID
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount:
                      width > 1400
                          ? 5
                          : width > 1000
                          ? 3
                          : width > 650
                          ? 2
                          : 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio:
                      width > 1400
                          ? 1.9
                          : width > 1000
                          ? 1.7
                          : width > 650
                          ? 1.5
                          : 1.35,
                  children: [
                    _StatCard(
                      title: "Total Videos",
                      value: controller.formatNumber(
                        controller.totalVideos.value,
                      ),
                      trend: "",
                      trendLabel: "videos",
                      color: const Color(0xfff97316),
                      icon: Iconsax.video,
                      onTap: controller.handleTotalVideosClick,
                    ),
                    _StatCard(
                      title: "Pending Approvals",
                      value: controller.formatNumber(
                        controller.pendingApprovals.value,
                      ),
                      trend: "Needs Review",
                      trendLabel: "",
                      color: const Color(0xfff59e0b),
                      icon: Iconsax.timer,
                      onTap: controller.handlePendingApprovalsClick,
                    ),
                    _StatCard(
                      title: "Total Users",
                      value: controller.formatNumber(
                        controller.totalUsers.value,
                      ),
                      trend: "+${controller.newUsersThisMonth.value}",
                      trendLabel: "new this month",
                      color: const Color(0xff3b82f6),
                      icon: Iconsax.profile_2user,
                      onTap: controller.handleTotalUsersClick,
                    ),
                    _StatCard(
                      title: "Total Products",
                      value: controller.formatNumber(
                        controller.totalProducts.value,
                      ),
                      trend:
                          controller.lowStockCount.value > 0
                              ? "${controller.lowStockCount.value} Low Stock"
                              : "In Stock",
                      trendLabel: "",
                      color: const Color(0xffec4899),
                      icon: Iconsax.box,
                      onTap: controller.handleTotalProductsClick,
                    ),
                    _StatCard(
                      title: "Total Orders",
                      value: controller.formatNumber(
                        controller.totalOrders.value,
                      ),
                      trend: "+${controller.newOrdersThisMonth.value}",
                      trendLabel: "this month",
                      color: const Color(0xff10b981),
                      icon: Iconsax.shopping_cart,
                      onTap: controller.handleTotalOrdersClick,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// SECONDARY STATS ROW
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount:
                      width > 1000
                          ? 3
                          : width > 650
                          ? 2
                          : 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: width > 1000 ? 2.2 : 1.8,
                  children: [
                    _SecondaryStatCard(
                      title: "Total Categories",
                      value: controller.formatNumber(
                        controller.totalCategories.value,
                      ),
                      icon: Iconsax.category,
                      color: const Color(0xff8b5cf6),
                      onTap: controller.handleTotalCategoriesClick,
                    ),
                    _SecondaryStatCard(
                      title: "Total Revenue",
                      value: controller.formatCurrency(
                        controller.totalRevenue.value,
                      ),
                      icon: Iconsax.money,
                      color: const Color(0xff06b6d4),
                      onTap: controller.handleRevenueClick,
                    ),
                    _SecondaryStatCard(
                      title: "New Orders",
                      value: controller.formatNumber(
                        controller.newOrdersThisMonth.value,
                      ),
                      icon: Iconsax.shopping_bag,
                      color: const Color(0xfff43f5e),
                      onTap: controller.handleTotalOrdersClick,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// NOTIFICATION
                if (controller.showNotification.value)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.info_circle, color: Colors.green.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.notificationMessage.value,
                            style: GoogleFonts.poppins(
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final String trendLabel;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.trendLabel,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// LEFT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1e1e2e),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (trend.isNotEmpty)
                    Row(
                      children: [
                        if (trend.startsWith('+'))
                          const Icon(
                            Iconsax.arrow_up,
                            size: 12,
                            color: Colors.green,
                          ),
                        if (trend.contains('Low'))
                          const Icon(
                            Iconsax.arrow_down,
                            size: 12,
                            color: Colors.red,
                          ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            trendLabel.isEmpty ? trend : "$trend $trendLabel",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color:
                                  trend.startsWith('+')
                                      ? Colors.green
                                      : trend.contains('Low')
                                      ? Colors.red
                                      : color,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            /// ICON
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.18),
                    color.withValues(alpha: 0.06),
                  ],
                ),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _SecondaryStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.15),
                    color.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1e1e2e),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
