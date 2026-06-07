import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Video_Model/Video_model.dart';

class AdminVideosController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var allVideos = <AdminVideoModel>[].obs;
  var filteredVideos = <AdminVideoModel>[].obs;
  var isLoading = true.obs;
  var isActionInProgress = false.obs;
  var isAdmin = false.obs;

  var selectedVisibilityFilter = 'all'.obs;
  var searchQuery = ''.obs;

  final List<String> visibilityFilters = [
    'all',
    'visible',
    'hidden',
    'deleted',
  ];

  @override
  void onInit() {
    super.onInit();
    checkAdminStatusAndFetchVideos();
  }

  Future<void> checkAdminStatusAndFetchVideos() async {
    isLoading.value = true;

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('No authenticated user found');
        Get.snackbar(
          'Authentication Error',
          'Please login to access videos',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      // Check if user is admin
      final adminDoc =
          await _firestore.collection('admins').doc(currentUser.uid).get();

      isAdmin.value = adminDoc.exists && (adminDoc.data()?['isAdmin'] == true);

      if (!isAdmin.value) {
        print('User is not an admin: ${currentUser.email}');
        Get.snackbar(
          'Access Denied',
          'You do not have admin privileges',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        isLoading.value = false;
        return;
      }

      print('Admin verified: ${currentUser.email}');
      await fetchVideos();
    } catch (e) {
      print('Error checking admin status: $e');
      Get.snackbar(
        'Error',
        'Failed to verify admin status: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
    }
  }

  Future<void> fetchVideos() async {
    isLoading.value = true;
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Not authenticated');
      }

      if (!isAdmin.value) {
        throw Exception('Admin access required');
      }

      print('Fetching all videos for admin: ${currentUser.email}');

      // As an admin, you can see all videos regardless of visibility
      // The security rule allows read if isAdmin() is true
      QuerySnapshot snapshot =
          await _firestore
              .collection('recipe_videos')
              .orderBy('createdAt', descending: true)
              .get();

      print('Fetched ${snapshot.docs.length} videos');

      allVideos.value =
          snapshot.docs
              .map((doc) => AdminVideoModel.fromFirestore(doc))
              .toList();

      filterVideos();
    } catch (e) {
      print('Error fetching videos: $e');

      String errorMessage = '';
      if (e.toString().contains('permission-denied')) {
        errorMessage =
            'Permission denied. Make sure you are logged in as an admin.';
      } else {
        errorMessage = 'Failed to load videos: ${e.toString()}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterVideos() {
    var filtered = List<AdminVideoModel>.from(allVideos);

    // Apply visibility filter
    if (selectedVisibilityFilter.value != 'all') {
      filtered =
          filtered.where((video) {
            return video.getVisibilityString() ==
                selectedVisibilityFilter.value;
          }).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered.where((video) {
            return video.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                video.userName.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                video.userEmail.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                );
          }).toList();
    }

    filteredVideos.value = filtered;
  }

  void updateVisibilityFilter(String visibility) {
    selectedVisibilityFilter.value = visibility;
    filterVideos();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    filterVideos();
  }

  Future<void> hideVideo(AdminVideoModel video, {String? reason}) async {
    if (!isAdmin.value) {
      Get.snackbar('Access Denied', 'Admin access required');
      return;
    }

    bool confirm = await _showConfirmationDialog(
      title: 'Hide Video',
      message:
          'Are you sure you want to hide this video?\n\n'
          'Title: ${video.title}\n'
          'Uploader: ${video.userName}\n\n'
          'Hidden videos will not be visible to users.',
    );

    if (!confirm) return;

    await _updateVideoVisibility(
      video: video,
      newVisibility: VideoVisibility.hidden,
      note: reason ?? 'Video hidden by admin',
    );
  }

  Future<void> deleteVideo(AdminVideoModel video, {String? reason}) async {
    if (!isAdmin.value) {
      Get.snackbar('Access Denied', 'Admin access required');
      return;
    }

    bool confirm = await _showConfirmationDialog(
      title: 'Delete Video',
      message:
          'Are you sure you want to permanently delete this video?\n\n'
          'Title: ${video.title}\n'
          'Uploader: ${video.userName}\n\n'
          '⚠️ This action cannot be undone!',
      isDestructive: true,
    );

    if (!confirm) return;

    await _updateVideoVisibility(
      video: video,
      newVisibility: VideoVisibility.deleted,
      note: reason ?? 'Video permanently deleted by admin',
    );

    // Optionally delete the video file from storage
    await _deleteVideoFromStorage(video.videoUrl);
    await _deleteThumbnailFromStorage(video.thumbnailUrl);
  }

  Future<void> restoreVideo(AdminVideoModel video) async {
    if (!isAdmin.value) {
      Get.snackbar('Access Denied', 'Admin access required');
      return;
    }

    bool confirm = await _showConfirmationDialog(
      title: 'Restore Video',
      message:
          'Are you sure you want to restore this video?\n\n'
          'Title: ${video.title}\n'
          'Uploader: ${video.userName}\n\n'
          'The video will become visible to users again.',
    );

    if (!confirm) return;

    await _updateVideoVisibility(
      video: video,
      newVisibility: VideoVisibility.visible,
      note: 'Video restored by admin',
    );
  }

  Future<void> _updateVideoVisibility({
    required AdminVideoModel video,
    required VideoVisibility newVisibility,
    required String note,
  }) async {
    isActionInProgress.value = true;

    try {
      final adminUser = _auth.currentUser;
      if (adminUser == null) {
        throw Exception('Admin not authenticated');
      }

      if (!isAdmin.value) {
        throw Exception('Admin access required');
      }

      print(
        'Updating video ${video.id} visibility to ${newVisibility.displayName}',
      );

      // Admin update - security rule allows update if isAdmin() is true
      await _firestore.collection('recipe_videos').doc(video.id).update({
        'visibility': newVisibility.toString().split('.').last,
        'isActive': newVisibility == VideoVisibility.visible,
        'adminNote': note,
        'moderatedAt': FieldValue.serverTimestamp(),
        'moderatedBy': adminUser.email,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local list
      final index = allVideos.indexWhere((v) => v.id == video.id);
      if (index != -1) {
        allVideos[index].visibility = newVisibility;
        allVideos[index].adminNote = note;
        allVideos[index].moderatedAt = DateTime.now();
        allVideos[index].moderatedBy = adminUser.email;
        allVideos[index].isActive = newVisibility == VideoVisibility.visible;
        allVideos.refresh();
      }

      filterVideos();

      Get.snackbar(
        'Success',
        'Video ${newVisibility.displayName.toLowerCase()} successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error updating video visibility: $e');
      Get.snackbar(
        'Error',
        'Failed to update video: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isActionInProgress.value = false;
    }
  }

  Future<void> _deleteVideoFromStorage(String videoUrl) async {
    try {
      if (videoUrl.isEmpty) return;
      final storageRef = _storage.refFromURL(videoUrl);
      await storageRef.delete();
      print('Video deleted from storage');
    } catch (e) {
      print('Error deleting video from storage: $e');
    }
  }

  Future<void> _deleteThumbnailFromStorage(String thumbnailUrl) async {
    try {
      if (thumbnailUrl.isEmpty) return;
      final storageRef = _storage.refFromURL(thumbnailUrl);
      await storageRef.delete();
      print('Thumbnail deleted from storage');
    } catch (e) {
      print('Error deleting thumbnail from storage: $e');
    }
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String message,
    bool isDestructive = false,
  }) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: Text(title),
            content: Text(message),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDestructive ? Colors.red : Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(isDestructive ? 'Delete' : 'Hide'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> showVideoDetails(AdminVideoModel video) async {
    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: video.visibility.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      video.visibility.icon,
                      color: video.visibility.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: video.visibility.color.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            video.visibility.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: video.visibility.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Uploader', video.userName, Icons.person),
                      _buildDetailRow('Email', video.userEmail, Icons.email),
                      _buildDetailRow(
                        'Category',
                        video.category,
                        Icons.category,
                      ),
                      _buildDetailRow('Duration', video.duration, Icons.timer),
                      _buildDetailRow(
                        'Video Type',
                        video.videoType,
                        Icons.video_library,
                      ),
                      _buildDetailRow(
                        'Stats',
                        '${video.views} views • ${video.likes} likes • ${video.comments} comments',
                        Icons.bar_chart,
                      ),
                      const SizedBox(height: 12),
                      if (video.adminNote != null) ...[
                        const Divider(),
                        const Text(
                          'Admin Note:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(video.adminNote!),
                        ),
                      ],
                      const SizedBox(height: 12),
                      const Divider(),
                      const Text(
                        'Ingredients:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...video.ingredients.map(
                        (ing) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• ${ing['name']}: ${ing['quantity']}'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(video.description),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildActionButtons(video),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AdminVideoModel video) {
    return Obx(() {
      if (isActionInProgress.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (video.visibility == VideoVisibility.visible)
            _buildActionButton(
              'Hide Video',
              Icons.visibility_off,
              Colors.orange,
              () => _showHideDialog(video),
            ),
          if (video.visibility == VideoVisibility.hidden)
            _buildActionButton(
              'Restore Video',
              Icons.restore,
              Colors.green,
              () => restoreVideo(video),
            ),
          _buildActionButton(
            'Delete Permanently',
            Icons.delete_forever,
            Colors.red,
            () => _showDeleteDialog(video),
            isDestructive: true,
          ),
        ],
      );
    });
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Future<void> _showHideDialog(AdminVideoModel video) async {
    TextEditingController reasonController = TextEditingController();
    await Get.dialog(
      AlertDialog(
        title: const Text('Hide Video'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for hiding (optional):'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter hiding reason...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              hideVideo(video, reason: reasonController.text.trim());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Hide'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(AdminVideoModel video) async {
    TextEditingController reasonController = TextEditingController();
    await Get.dialog(
      AlertDialog(
        title: const Text('Permanently Delete Video'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '⚠️ This action cannot be undone!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Please provide a reason for deletion:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter deletion reason...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteVideo(video, reason: reasonController.text.trim());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  Future<void> refreshVideos() async {
    await fetchVideos();
  }

  int getVisibleCount() {
    return allVideos
        .where((v) => v.visibility == VideoVisibility.visible)
        .length;
  }

  int getHiddenCount() {
    return allVideos
        .where((v) => v.visibility == VideoVisibility.hidden)
        .length;
  }

  int getDeletedCount() {
    return allVideos
        .where((v) => v.visibility == VideoVisibility.deleted)
        .length;
  }
}
