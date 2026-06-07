// lib/App/Modules/Admin_Videos/view/admin_videos_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Video_Model/Video_model.dart';
import 'package:racha_ruchi_admin_panel/Modules/Videos/controller/admin_video_controller.dart';

class AdminVideosView extends StatelessWidget {
  const AdminVideosView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminVideosController controller = Get.put(AdminVideosController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Video Moderation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.refreshVideos(),
            icon: const Icon(Iconsax.refresh, color: Color(0xFF1A1A1A)),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(controller),
          _buildVisibilityFilter(controller),
          _buildStatsRow(controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF4757)),
                );
              }

              if (controller.filteredVideos.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredVideos.length,
                itemBuilder: (context, index) {
                  final video = controller.filteredVideos[index];
                  return _buildVideoCard(video, controller);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AdminVideosController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => controller.updateSearch(value),
        decoration: InputDecoration(
          hintText: 'Search by title, user name or email...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          icon: Icon(Iconsax.search_normal, color: Colors.grey.shade500),
        ),
      ),
    );
  }

  Widget _buildVisibilityFilter(AdminVideosController controller) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.visibilityFilters.length,
        itemBuilder: (context, index) {
          final visibility = controller.visibilityFilters[index];
          final isSelected =
              controller.selectedVisibilityFilter.value == visibility;
          String displayName =
              visibility == 'all'
                  ? 'All'
                  : StringExtension(visibility).capitalizeFirst!;

          return GestureDetector(
            onTap: () => controller.updateVisibilityFilter(visibility),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF4757) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFFFF4757)
                          : Colors.grey.shade200,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: const Color(
                              0xFFFF4757,
                            ).withValues(alpha: 0.2),
                            blurRadius: 8,
                          ),
                        ]
                        : null,
              ),
              child: Text(
                displayName,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(AdminVideosController controller) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'Visible',
              controller.getVisibleCount(),
              Colors.green,
              Iconsax.eye,
            ),
            Container(width: 1, height: 30, color: Colors.grey.shade200),
            _buildStatItem(
              'Hidden',
              controller.getHiddenCount(),
              Colors.orange,
              Iconsax.eye_slash,
            ),
            Container(width: 1, height: 30, color: Colors.grey.shade200),
            _buildStatItem(
              'Deleted',
              controller.getDeletedCount(),
              Colors.red,
              Iconsax.trash,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildVideoCard(
    AdminVideoModel video,
    AdminVideosController controller,
  ) {
    print("======== VIDEO ========");
    print("Title: ${video.title}");
    print("Thumbnail: ${video.thumbnailUrl}");
    print("VideoUrl: ${video.videoUrl}");
    return GestureDetector(
      onTap: () => controller.showVideoDetails(video),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with visibility indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        video.thumbnailUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          debugPrint("Loading image...");
                          return child;
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print("ERROR = $error");
                          print("STACK = $stackTrace");

                          return Container(
                            height: 180,
                            color: Colors.red,
                            child: const Center(
                              child: Text("Thumbnail Failed"),
                            ),
                          );
                        },
                      ),
                      if (video.visibility != VideoVisibility.visible)
                        Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.black.withValues(alpha: 0.7),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  video.visibility == VideoVisibility.hidden
                                      ? Iconsax.eye_slash
                                      : Iconsax.trash,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  video.visibility.displayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: video.visibility.color,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          video.visibility.icon,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          video.visibility.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.duration,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Text(
                      video.userName.isNotEmpty
                          ? video.userName[0].toUpperCase()
                          : "U",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Video info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          video.userName,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Iconsax.eye,
                              size: 12,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${video.views} views',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Iconsax.heart,
                              size: 12,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${video.likes}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Quick action buttons
                  Obx(() {
                    if (controller.isActionInProgress.value) {
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return PopupMenuButton<String>(
                      icon: const Icon(Iconsax.more, color: Colors.grey),
                      onSelected: (value) {
                        switch (value) {
                          case 'hide':
                            controller.hideVideo(video);
                            break;
                          case 'delete':
                            controller.deleteVideo(video);
                            break;
                          case 'restore':
                            controller.restoreVideo(video);
                            break;
                        }
                      },
                      itemBuilder:
                          (context) => [
                            if (video.visibility == VideoVisibility.visible)
                              const PopupMenuItem(
                                value: 'hide',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.visibility_off,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Hide'),
                                  ],
                                ),
                              ),
                            if (video.visibility == VideoVisibility.hidden)
                              const PopupMenuItem(
                                value: 'restore',
                                child: Row(
                                  children: [
                                    Icon(Icons.restore, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Restore'),
                                  ],
                                ),
                              ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_forever, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete Permanently'),
                                ],
                              ),
                            ),
                          ],
                    );
                  }),
                ],
              ),
            ),
            if (video.adminNote != null)
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.note, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        video.adminNote!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.video_play, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No videos found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing the filter or search query',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String? get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
