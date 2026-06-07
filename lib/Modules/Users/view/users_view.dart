import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Users_Model/user_model.dart';
import 'package:racha_ruchi_admin_panel/Modules/Users/controller/user_controller.dart';
import 'package:racha_ruchi_admin_panel/Modules/Users/view/all_users_view.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xfff5f3ff),
      body: Column(
        children: [
          _buildHeader(controller),
          Expanded(
            child: Obx(() {
              switch (controller.selectedTabIndex.value) {
                case 0:
                  return const AllUsersView();
                case 1:
                  return _buildAddUserView(controller);
                case 2:
                  return _buildRolesView(controller);
                case 3:
                  return _buildPermissionsView(controller);
                case 4:
                  return _buildActiveUsersView(controller);
                case 5:
                  return _buildBlockedUsersView(controller);
                case 6:
                  return _buildReportsView(controller);
                default:
                  return const AllUsersView();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(UserController controller) {
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
            "User Management",
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
            "Manage users, roles, permissions, and user reports",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          _buildTabs(controller),
        ],
      ),
    );
  }

  Widget _buildTabs(UserController controller) {
    final tabs = [
      {'label': 'All Users', 'icon': Iconsax.people},
      {'label': 'Add User', 'icon': Iconsax.user_add},
      {'label': 'User Roles', 'icon': Iconsax.shield_tick},
      {'label': 'Permissions', 'icon': Iconsax.key},
      {'label': 'Active Users', 'icon': Iconsax.user_tick},
      {'label': 'Blocked Users', 'icon': Iconsax.lock},
      {'label': 'Reports', 'icon': Iconsax.document_text},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              tabs.asMap().entries.map((entry) {
                int index = entry.key;
                Map tab = entry.value;
                return _buildTabItem(
                  controller,
                  index,
                  tab['label'],
                  tab['icon'],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabItem(
    UserController controller,
    int index,
    String title,
    IconData icon,
  ) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectedTabIndex.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color:
                controller.selectedTabIndex.value == index
                    ? const Color(0xff7c3aed)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color:
                    controller.selectedTabIndex.value == index
                        ? Colors.white
                        : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      controller.selectedTabIndex.value == index
                          ? Colors.white
                          : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddUserView(UserController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add New User",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller.nameController,
                  "Full Name",
                  Iconsax.user,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller.emailController,
                  "Email",
                  Iconsax.sms,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller.phoneController,
                  "Phone",
                  Iconsax.call,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller.passwordController,
                  "Password",
                  Iconsax.lock,
                  obscure: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller.confirmPasswordController,
                  "Confirm Password",
                  Iconsax.lock,
                  obscure: true,
                ),
                const SizedBox(height: 16),
                _buildDropdownField(controller.roleController, "Role", [
                  'user',
                  'moderator',
                  'admin',
                ]),
                const SizedBox(height: 16),
                _buildTextField(
                  controller.addressController,
                  "Address",
                  Iconsax.house,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller.cityController,
                        "City",
                        Iconsax.buildings,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller.stateController,
                        "State",
                        Iconsax.map,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller.zipCodeController,
                        "Zip Code",
                        Iconsax.code,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.addUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff7c3aed),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Add User",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildRolesView(UserController controller) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: controller.roles.length,
        itemBuilder: (context, index) {
          final role = controller.roles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xff7c3aed).withValues(alpha: 0.1),
                child: Icon(
                  Iconsax.shield_tick,
                  color: const Color(0xff7c3aed),
                ),
              ),
              title: Text(
                role.name,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(role.description),
              trailing:
                  role.isDefault
                      ? null
                      : IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteRole(role.id),
                      ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPermissionsView(UserController controller) {
    // Group permissions by category
    final groupedPermissions = <String, List<Permission>>{};
    for (var perm in controller.permissions) {
      groupedPermissions.putIfAbsent(perm.category, () => []).add(perm);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: groupedPermissions.keys.length,
      itemBuilder: (context, index) {
        final category = groupedPermissions.keys.elementAt(index);
        final perms = groupedPermissions[category]!;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ExpansionTile(
            title: Text(
              category,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            children:
                perms.map((perm) {
                  return SwitchListTile(
                    title: Text(perm.name),
                    subtitle: Text(perm.description),
                    value: perm.isEnabled,
                    onChanged:
                        (val) => controller.updatePermissions(perm.id, val),
                    activeThumbColor: const Color(0xff7c3aed),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildActiveUsersView(UserController controller) {
    controller.setStatusFilter('active');
    return const AllUsersView();
  }

  Widget _buildBlockedUsersView(UserController controller) {
    controller.setStatusFilter('blocked');
    return const AllUsersView();
  }

  Widget _buildReportsView(UserController controller) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: controller.userReports.length,
        itemBuilder: (context, index) {
          final report = controller.userReports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    report.status == 'pending'
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                child: Icon(
                  report.status == 'pending'
                      ? Iconsax.clock
                      : Iconsax.tick_circle,
                ),
              ),
              title: Text(
                "Report on ${report.userName}",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "Reason: ${report.reason}\nReported by: ${report.reporterName}",
              ),
              trailing:
                  report.status == 'pending'
                      ? TextButton(
                        onPressed:
                            () => _showResolveDialog(controller, report.id),
                        child: const Text(
                          "Resolve",
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                      : Chip(
                        label: Text(report.status),
                        backgroundColor: Colors.grey[200],
                      ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    TextEditingController controller,
    String label,
    List<String> items,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      initialValue: controller.text.isNotEmpty ? controller.text : items.first,
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: (value) => controller.text = value!,
    );
  }

  void _showResolveDialog(UserController controller, String reportId) {
    final resolutionController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text("Resolve Report"),
        content: TextField(
          controller: resolutionController,
          decoration: const InputDecoration(
            hintText: "Enter resolution details",
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              controller.resolveReport(reportId, resolutionController.text);
              Get.back();
            },
            child: const Text("Resolve", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
