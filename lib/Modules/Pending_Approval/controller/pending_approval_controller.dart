import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingApprovalController extends GetxController {
  // Reactive list of pending videos
  var pendingVideos = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPendingVideos();
  }

  void loadPendingVideos() {
    pendingVideos.value = [
      {
        "title": "Chicken Dum Biryani Recipe",
        "chef": "Chef Ahmad",
        "time": "2 mins ago",
        "duration": "12:40",
        "thumbnail":
            "https://images.unsplash.com/photo-1563379091339-03246963d96c",
      },
      {
        "title": "Authentic Masala Dosa",
        "chef": "Chef Priya",
        "time": "10 mins ago",
        "duration": "08:22",
        "thumbnail":
            "https://images.unsplash.com/photo-1630383249896-424e482df921",
      },
      {
        "title": "Spicy Chicken Curry",
        "chef": "Chef Ravi",
        "time": "30 mins ago",
        "duration": "15:18",
        "thumbnail":
            "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d",
      },
      {
        "title": "Paneer Butter Masala",
        "chef": "Chef Sneha",
        "time": "1 hour ago",
        "duration": "09:50",
        "thumbnail":
            "https://images.unsplash.com/photo-1631452180519-c014fe946bc7",
      },
    ];
  }

  void approveVideo(Map<String, dynamic> video) {
    pendingVideos.remove(video);
    Get.snackbar(
      "Approved",
      "${video['title']} approved successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 12,
    );
  }

  void rejectVideo(Map<String, dynamic> video) {
    pendingVideos.remove(video);
    Get.snackbar(
      "Rejected",
      "${video['title']} rejected",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 12,
    );
  }

  void approveAll() {
    if (pendingVideos.isNotEmpty) {
      int count = pendingVideos.length;
      pendingVideos.clear();
      Get.snackbar(
        "Success",
        "$count videos approved successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  int get pendingCount => pendingVideos.length;
}
