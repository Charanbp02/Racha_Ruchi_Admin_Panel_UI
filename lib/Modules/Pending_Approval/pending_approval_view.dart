import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Modules/Pending_Approval/controller/pending_approval_controller.dart';

class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PendingApprovalController>();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff5f3ff),
      body: Column(
        children: [
          _buildHeader(controller),
          Expanded(
            child: Obx(
              () =>
                  controller.pendingVideos.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: controller.pendingVideos.length,
                        itemBuilder: (context, index) {
                          final item = controller.pendingVideos[index];
                          return _buildApprovalCard(
                            width: width,
                            item: item,
                            controller: controller,
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(PendingApprovalController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pending Approvals",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1e1e2e),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Review and approve uploaded videos",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.timer, size: 18, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        "${controller.pendingCount} Pending",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.pendingCount > 0) ...[
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () => _showApproveAllDialog(controller),
                  icon: const Icon(Iconsax.document_upload, size: 18),
                  label: const Text("Approve All"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalCard({
    required double width,
    required Map<String, dynamic> item,
    required PendingApprovalController controller,
  }) {
    final isMobile = width < 800;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:
          isMobile
              ? _buildMobileCard(item, controller)
              : _buildDesktopCard(item, controller),
    );
  }

  Widget _buildDesktopCard(
    Map<String, dynamic> item,
    PendingApprovalController controller,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// THUMBNAIL WITH ERROR HANDLING
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            item['thumbnail'],
            width: 180,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 180,
                height: 110,
                color: Colors.grey[200],
                child: const Icon(
                  Iconsax.gallery,
                  size: 40,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 20),

        /// DETAILS
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1e1e2e),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                "Uploaded by ${item['chef']}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  _infoChip(
                    icon: Iconsax.clock,
                    text: item['time'],
                    color: Colors.blue,
                  ),
                  _infoChip(
                    icon: Iconsax.video,
                    text: item['duration'],
                    color: Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ),

        /// ACTIONS
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () => controller.approveVideo(item),
              icon: const Icon(Iconsax.tick_circle, size: 18),
              label: const Text("Approve"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => controller.rejectVideo(item),
              icon: const Icon(Iconsax.close_circle, size: 18),
              label: const Text("Reject"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileCard(
    Map<String, dynamic> item,
    PendingApprovalController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            item['thumbnail'],
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(
                  Iconsax.gallery,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          item['title'],
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xff1e1e2e),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          "Uploaded by ${item['chef']}",
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            _infoChip(
              icon: Iconsax.clock,
              text: item['time'],
              color: Colors.blue,
            ),
            _infoChip(
              icon: Iconsax.video,
              text: item['duration'],
              color: Colors.purple,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.approveVideo(item),
                icon: const Icon(Iconsax.tick_circle, size: 18),
                label: const Text("Approve"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.rejectVideo(item),
                icon: const Icon(Iconsax.close_circle, size: 18),
                label: const Text("Reject"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.tick_circle,
            size: 80,
            color: Colors.green.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "All Caught Up!",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1e1e2e),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "No pending videos to approve",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showApproveAllDialog(PendingApprovalController controller) {
    Get.defaultDialog(
      title: "Approve All Videos",
      middleText:
          "Are you sure you want to approve all ${controller.pendingCount} pending videos?",
      textConfirm: "Yes, Approve All",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      cancelTextColor: Colors.red,
      onConfirm: () {
        controller.approveAll();
        Get.back();
      },
    );
  }
}
