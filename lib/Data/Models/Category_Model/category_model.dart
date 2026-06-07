import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final bool isActive;
  final DateTime createdAt;
  final List<SubCategoryModel> subCategories;
  final String? imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.createdAt,
    required this.subCategories,
    this.imageUrl,
  });

  // Create from Firestore
  factory CategoryModel.fromFirestore(String id, Map<String, dynamic> data) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '🍽️',
      color: data['color'] ?? '#7c3aed',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      subCategories:
          (data['subCategories'] as List?)
              ?.map((e) => SubCategoryModel.fromFirestore(e))
              .toList() ??
          [],
      imageUrl: data['imageUrl'],
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'subCategories': subCategories.map((e) => e.toFirestore()).toList(),
      'imageUrl': imageUrl,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    bool? isActive,
    DateTime? createdAt,
    List<SubCategoryModel>? subCategories,
    String? imageUrl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      subCategories: subCategories ?? this.subCategories,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final String? imageUrl;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    this.imageUrl,
  });

  factory SubCategoryModel.fromFirestore(Map<String, dynamic> data) {
    return SubCategoryModel(
      id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrl': imageUrl,
    };
  }

  SubCategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    String? imageUrl,
  }) {
    return SubCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
