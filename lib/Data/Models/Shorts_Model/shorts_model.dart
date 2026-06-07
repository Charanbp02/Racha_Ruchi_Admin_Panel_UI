import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShortsModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String title;
  final String userId;
  final String userName;
  final String userAvatar;
  final int duration; // in seconds
  final int likes;
  final int comments;
  final int views;
  final ShortsStatus status;
  final DateTime createdAt;
  final String? rejectionReason;
  final List<dynamic> ingredients;
  final String description;
  final List<String> tags;
  final bool isActive;
  final String videoType;

  ShortsModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.duration,
    required this.likes,
    required this.comments,
    required this.views,
    required this.status,
    required this.createdAt,
    this.rejectionReason,
    this.ingredients = const [],
    this.description = '',
    this.tags = const [],
    this.isActive = true,
    this.videoType = 'shorts',
  });

  factory ShortsModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ShortsModel(
      id: id,
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      title: data['title'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'User',
      userAvatar: data['userImage'] ?? '',
      duration: data['durationInSeconds'] ?? 0,
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      views: data['views'] ?? 0,
      status: _getStatus(data['status'] ?? 'pending'),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      rejectionReason: data['adminNote'],
      ingredients: data['ingredients'] ?? [],
      description: data['description'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      isActive: data['isActive'] ?? true,
      videoType: data['videoType'] ?? 'shorts',
    );
  }

  static ShortsStatus _getStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return ShortsStatus.approved;
      case 'rejected':
        return ShortsStatus.rejected;
      default:
        return ShortsStatus.pending;
    }
  }

  ShortsModel copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? title,
    String? userId,
    String? userName,
    String? userAvatar,
    int? duration,
    int? likes,
    int? comments,
    int? views,
    ShortsStatus? status,
    DateTime? createdAt,
    String? rejectionReason,
    List<dynamic>? ingredients,
    String? description,
    List<String>? tags,
    bool? isActive,
    String? videoType,
  }) {
    return ShortsModel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      duration: duration ?? this.duration,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      views: views ?? this.views,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      ingredients: ingredients ?? this.ingredients,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      videoType: videoType ?? this.videoType,
    );
  }
}

enum ShortsStatus {
  pending,
  approved,
  rejected;

  String get displayName {
    switch (this) {
      case ShortsStatus.pending:
        return 'Pending';
      case ShortsStatus.approved:
        return 'Approved';
      case ShortsStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case ShortsStatus.pending:
        return Colors.orange;
      case ShortsStatus.approved:
        return Colors.green;
      case ShortsStatus.rejected:
        return Colors.red;
    }
  }
}
