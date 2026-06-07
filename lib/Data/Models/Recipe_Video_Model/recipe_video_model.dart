// models/recipe_video_model.dart
class RecipeVideoModel {
  final String id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final int views;
  final int likes;
  final String category;
  final DateTime createdAt;
  bool isFeatured;

  RecipeVideoModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.views = 0,
    this.likes = 0,
    required this.category,
    required this.createdAt,
    this.isFeatured = false,
  });

  factory RecipeVideoModel.fromJson(Map<String, dynamic> json) {
    return RecipeVideoModel(
      id: json['id'],
      title: json['title'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'views': views,
      'likes': likes,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'isFeatured': isFeatured,
    };
  }

  RecipeVideoModel copyWith({
    String? id,
    String? title,
    String? videoUrl,
    String? thumbnailUrl,
    int? views,
    int? likes,
    String? category,
    DateTime? createdAt,
    bool? isFeatured,
  }) {
    return RecipeVideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
