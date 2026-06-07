import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Users_Model/user_model.dart';
import 'package:racha_ruchi_admin_panel/Modules/Users/controller/user_controller.dart';

class AllUsersView extends StatelessWidget {
  const AllUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Column(
      children: [
        _buildHeader(controller),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredUsers.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.filteredUsers.length,
              itemBuilder: (context, index) {
                final user = controller.filteredUsers[index];
                return _buildUserCard(controller, user);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeader(UserController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "All Users",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1e1e2e),
              ),
            ),
          ),
          SizedBox(
            width: 280,
            child: TextField(
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                hintText: "Search users...",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  size: 18,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserController controller, UserModel user) {
    final isBlocked = user.status == 'blocked';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          if (isMobile) {
            return _buildMobileCard(controller, user, isBlocked);
          }
          return _buildDesktopCard(controller, user, isBlocked);
        },
      ),
    );
  }

  Widget _buildDesktopCard(
    UserController controller,
    UserModel user,
    bool isBlocked,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xff7c3aed),
          backgroundImage:
              user.avatar.isNotEmpty ? NetworkImage(user.avatar) : null,
          child:
              user.avatar.isEmpty
                  ? Text(
                    user.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                  : null,
        ),
        const SizedBox(width: 18),
        Expanded(
          flex: 2,
          child: Text(
            user.name,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            user.email,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _getRoleColor(user.role).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getRoleColor(user.role),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            _formatDate(user.createdAt),
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => _showUserDialog(user),
              icon: const Icon(Iconsax.eye, color: Color(0xff3b82f6), size: 20),
            ),
            if (!isBlocked)
              IconButton(
                onPressed:
                    () => controller.blockUser(user.id, "Blocked by admin"),
                icon: const Icon(Iconsax.lock, color: Colors.orange, size: 20),
              )
            else
              IconButton(
                onPressed: () => controller.unblockUser(user.id),
                icon: const Icon(Iconsax.unlock, color: Colors.green, size: 20),
              ),
            IconButton(
              onPressed: () => controller.deleteUser(user.id),
              icon: const Icon(Iconsax.trash, color: Colors.red, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileCard(
    UserController controller,
    UserModel user,
    bool isBlocked,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xff7c3aed),
              backgroundImage:
                  user.avatar.isNotEmpty ? NetworkImage(user.avatar) : null,
              child:
                  user.avatar.isEmpty ? Text(user.name[0].toUpperCase()) : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getRoleColor(user.role).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.role.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _getRoleColor(user.role),
                ),
              ),
            ),
            const Spacer(),
            Text(
              _formatDate(user.createdAt),
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () => _showUserDialog(user),
              icon: const Icon(Iconsax.eye, size: 18, color: Color(0xff3b82f6)),
              label: const Text(
                "View",
                style: TextStyle(color: Color(0xff3b82f6)),
              ),
            ),
            if (!isBlocked)
              TextButton.icon(
                onPressed:
                    () => controller.blockUser(user.id, "Blocked by admin"),
                icon: const Icon(Iconsax.lock, size: 18, color: Colors.orange),
                label: const Text(
                  "Block",
                  style: TextStyle(color: Colors.orange),
                ),
              )
            else
              TextButton.icon(
                onPressed: () => controller.unblockUser(user.id),
                icon: const Icon(Iconsax.unlock, size: 18, color: Colors.green),
                label: const Text(
                  "Unblock",
                  style: TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showUserDialog(UserModel user) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          "User Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage:
                    user.avatar.isNotEmpty ? NetworkImage(user.avatar) : null,
                child:
                    user.avatar.isEmpty
                        ? Text(user.name[0].toUpperCase())
                        : null,
              ),
              const SizedBox(height: 16),
              _detailRow("Name", user.name),
              _detailRow("Email", user.email),
              _detailRow("Phone", user.phone),
              _detailRow("Role", user.role.toUpperCase()),
              _detailRow("Status", user.status.toUpperCase()),
              _detailRow("Joined", _formatDate(user.createdAt)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$title :",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return const Color(0xff7c3aed);
      case 'moderator':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.people, size: 70, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No Users Found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
