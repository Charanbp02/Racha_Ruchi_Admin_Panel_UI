// lib/App/Models/Admin_Video_Model/admin_video_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminVideoModel {
  String id;
  String title;
  String description;
  String thumbnailUrl;
  String videoUrl;
  String userId;
  String userName;
  String userEmail;
  String userImage;
  List<Map<String, dynamic>> ingredients;
  String category;
  String categoryId;
  List<String> tags;
  String duration;
  int durationInSeconds;
  String videoType;
  int likes;
  int views;
  int comments;
  int shares;
  double rating;
  bool isActive;
  bool isPopular;
  VideoVisibility visibility; // 'visible', 'hidden', 'deleted'
  String? adminNote;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? moderatedAt;
  String? moderatedBy;

  AdminVideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.ingredients,
    required this.category,
    required this.categoryId,
    required this.tags,
    required this.duration,
    required this.durationInSeconds,
    required this.videoType,
    this.likes = 0,
    this.views = 0,
    this.comments = 0,
    this.shares = 0,
    this.rating = 0.0,
    this.isActive = true,
    this.isPopular = false,
    this.visibility = VideoVisibility.visible,
    this.adminNote,
    required this.createdAt,
    this.updatedAt,
    this.moderatedAt,
    this.moderatedBy,
  });

  factory AdminVideoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AdminVideoModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'User',
      userEmail: data['userEmail'] ?? '',
      userImage: data['userImage'] ?? '',
      ingredients: List<Map<String, dynamic>>.from(data['ingredients'] ?? []),
      category: data['category'] ?? '',
      categoryId: data['categoryId'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      duration: data['duration'] ?? '0:00',
      durationInSeconds: data['durationInSeconds'] ?? 0,
      videoType: data['videoType'] ?? 'long',
      likes: data['likes'] ?? 0,
      views: data['views'] ?? 0,
      comments: data['comments'] ?? 0,
      shares: data['shares'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      isActive: data['isActive'] ?? true,
      isPopular: data['isPopular'] ?? false,
      visibility: _getVisibilityFromString(data['visibility'] ?? 'visible'),
      adminNote: data['adminNote'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      moderatedAt: (data['moderatedAt'] as Timestamp?)?.toDate(),
      moderatedBy: data['moderatedBy'],
    );
  }

  static VideoVisibility _getVisibilityFromString(String visibility) {
    switch (visibility.toLowerCase()) {
      case 'hidden':
        return VideoVisibility.hidden;
      case 'deleted':
        return VideoVisibility.deleted;
      default:
        return VideoVisibility.visible;
    }
  }

  String getVisibilityString() {
    switch (visibility) {
      case VideoVisibility.visible:
        return 'visible';
      case VideoVisibility.hidden:
        return 'hidden';
      case VideoVisibility.deleted:
        return 'deleted';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userImage': userImage,
      'ingredients': ingredients,
      'category': category,
      'categoryId': categoryId,
      'tags': tags,
      'duration': duration,
      'durationInSeconds': durationInSeconds,
      'videoType': videoType,
      'likes': likes,
      'views': views,
      'comments': comments,
      'shares': shares,
      'rating': rating,
      'isActive': visibility == VideoVisibility.visible,
      'isPopular': isPopular,
      'visibility': getVisibilityString(),
      'adminNote': adminNote,
      'updatedAt': FieldValue.serverTimestamp(),
      'moderatedAt':
          moderatedAt != null ? Timestamp.fromDate(moderatedAt!) : null,
      'moderatedBy': moderatedBy,
    };
  }
}

enum VideoVisibility {
  visible,
  hidden,
  deleted;

  String get displayName {
    switch (this) {
      case VideoVisibility.visible:
        return 'Visible';
      case VideoVisibility.hidden:
        return 'Hidden';
      case VideoVisibility.deleted:
        return 'Deleted';
    }
  }

  Color get color {
    switch (this) {
      case VideoVisibility.visible:
        return Colors.green;
      case VideoVisibility.hidden:
        return Colors.orange;
      case VideoVisibility.deleted:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case VideoVisibility.visible:
        return Icons.visibility;
      case VideoVisibility.hidden:
        return Icons.visibility_off;
      case VideoVisibility.deleted:
        return Icons.delete;
    }
  }
}
