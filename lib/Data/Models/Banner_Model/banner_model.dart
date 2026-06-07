import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final int order;
  final bool isActive;
  final String type; // 'home', 'promo', 'category', 'offer'
  final String? link;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.order,
    required this.isActive,
    required this.type,
    this.link,
    required this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromFirestore(String id, Map<String, dynamic> data) {
    return BannerModel(
      id: id,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      type: data['type'] ?? 'home',
      link: data['link'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'order': order,
      'isActive': isActive,
      'type': type,
      'link': link,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  BannerModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? description,
    int? order,
    bool? isActive,
    String? type,
    String? link,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
