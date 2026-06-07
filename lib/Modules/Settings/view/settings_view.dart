import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Modules/Settings/controller/settings_controller.dart';

class AdminSettingsView extends GetView<SettingsController> {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Admin Settings",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  // Profile Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: _cardDecoration(),
                    child: Row(
                      children: [
                        _buildAvatar(),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.adminName.value,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.adminEmail.value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      "Active",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _showEditProfileDialog(),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text("Edit Profile"),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildSettingsCard(
                          title: "Account Settings",
                          icon: Icons.person_outline,
                          color: Colors.blue,
                          items: [
                            _SettingsItem(
                              title: "Change Password",
                              icon: Icons.lock_outline,
                              onTap: () => _showChangePasswordDialog(),
                            ),
                            _SettingsItem(
                              title: "Email Notifications",
                              icon: Iconsax.notification,
                              trailing: Obx(
                                () => Switch(
                                  value: controller.notificationsEnabled.value,
                                  onChanged: controller.toggleNotifications,
                                  activeThumbColor: Colors.blue,
                                ),
                              ),
                            ),
                            _SettingsItem(
                              title: "Dark Mode",
                              icon: Icons.dark_mode_outlined,
                              trailing: Obx(
                                () => Switch(
                                  value: controller.isDarkMode.value,
                                  onChanged: controller.toggleDarkMode,
                                  activeThumbColor: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildSettingsCard(
                          title: "Preferences",
                          icon: Iconsax.setting_2,
                          color: Colors.purple,
                          items: [
                            _SettingsItem(
                              title: "Language",
                              icon: Icons.language,
                              trailing: Obx(
                                () => Text(
                                  controller.language.value,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              onTap: () => _showLanguageDialog(),
                            ),
                            _SettingsItem(
                              title: "Privacy Policy",
                              icon: Icons.privacy_tip_outlined,
                              onTap: () => _showPrivacyPolicy(),
                            ),
                            _SettingsItem(
                              title: "Terms of Service",
                              icon: Icons.description_outlined,
                              onTap: () => _showTermsOfService(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Danger Zone
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red[400],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Danger Zone",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[400],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _SettingsItem(
                          title: "Delete Account",
                          icon: Icons.delete_forever,
                          subtitle: "Permanently delete your account",
                          color: Colors.red,
                          onTap: () => _showDeleteAccountDialog(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 10),
        ],
      ),
      child: Center(
        child: Obx(
          () => Text(
            controller.getInitials(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<_SettingsItem> items,
  }) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: item,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Logout",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.logout();
      },
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(
      text: controller.adminName.value,
    );

    Get.defaultDialog(
      title: "Edit Profile",
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Full Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
              text: controller.adminEmail.value,
            ),
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
            enabled: false,
          ),
        ],
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (nameController.text.isNotEmpty) {
          controller.updateProfile(nameController.text);
        }
        Get.back();
      },
    );
  }

  void _showChangePasswordDialog() {
    final currentPassword = TextEditingController();
    final newPassword = TextEditingController();
    final confirmPassword = TextEditingController();

    Get.defaultDialog(
      title: "Change Password",
      content: Column(
        children: [
          TextField(
            controller: currentPassword,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Current Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: newPassword,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "New Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: confirmPassword,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Confirm New Password",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textConfirm: "Update",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.changePassword(
          currentPassword: currentPassword.text,
          newPassword: newPassword.text,
          confirmPassword: confirmPassword.text,
        );
        Get.back();
      },
    );
  }

  void _showLanguageDialog() {
    Get.defaultDialog(
      title: "Select Language",
      content: Column(
        children: [
          ListTile(
            title: const Text("English"),
            onTap: () {
              controller.changeLanguage("English");
              Get.back();
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Hindi"),
            onTap: () {
              controller.changeLanguage("Hindi");
              Get.back();
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Spanish"),
            onTap: () {
              controller.changeLanguage("Spanish");
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    Get.defaultDialog(
      title: "Privacy Policy",
      content: const SingleChildScrollView(
        child: Text(
          "Your privacy is important to us. This policy explains how we collect, use, and protect your personal information.",
        ),
      ),
      textConfirm: "Close",
      onConfirm: () => Get.back(),
    );
  }

  void _showTermsOfService() {
    Get.defaultDialog(
      title: "Terms of Service",
      content: const SingleChildScrollView(
        child: Text(
          "By using this application, you agree to these terms and conditions. Please read them carefully.",
        ),
      ),
      textConfirm: "Close",
      onConfirm: () => Get.back(),
    );
  }

  void _showDeleteAccountDialog() {
    Get.defaultDialog(
      title: "Delete Account",
      middleText:
          "This action cannot be undone. All your data will be permanently deleted. Are you sure?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteAccount();
      },
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.color,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? Colors.grey).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: color ?? Colors.grey[700]),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
