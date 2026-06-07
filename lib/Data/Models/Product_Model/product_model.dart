import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double discount;
  final List<String> images; // First image is main, up to 5 images total
  final String category;
  final String subCategory;
  final String brand;
  final double rating;
  final int reviews;
  final bool isInStock;
  final int stock;
  final String sku;
  final bool isFeatured;
  final List<String> weightVariants; // Weight variants instead of sizes/colors
  final Map<String, dynamic> specifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.rating,
    required this.reviews,
    required this.isInStock,
    required this.stock,
    required this.sku,
    required this.isFeatured,
    required this.weightVariants,
    required this.specifications,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper getters for images
  String get mainImage => images.isNotEmpty ? images.first : '';
  List<String> get additionalImages =>
      images.length > 1 ? images.sublist(1) : [];
  int get imageCount => images.length;
  bool get hasMultipleImages => images.length > 1;
  bool get isImageLimitReached => images.length >= 5;

  // Helper getters for weight variants
  bool get hasWeightVariants => weightVariants.isNotEmpty;
  String get weightVariantsDisplay => weightVariants.join(', ');

  // Helper getters for stock status
  bool get isLowStock => stock <= 5 && stock > 0;
  bool get isOutOfStock => stock == 0;
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  Color get stockStatusColor {
    if (isOutOfStock) return Colors.red;
    if (isLowStock) return Colors.orange;
    return Colors.green;
  }

  // Helper for discount
  bool get hasDiscount => discount > 0;
  double get discountPercentage => hasDiscount ? discount : 0;
  double get savingsAmount => originalPrice - price;
  String get formattedDiscount => '${discount.toStringAsFixed(0)}% OFF';

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    // Ensure images is always a List<String>
    List<String> images = [];
    if (map['images'] != null) {
      if (map['images'] is List) {
        images = List<String>.from(map['images'].map((img) => img.toString()));
      } else if (map['images'] is String) {
        images = [map['images']];
      }
    }

    // Get weight variants from specifications or direct field
    List<String> weightVariants = [];
    if (map['weightVariants'] != null) {
      weightVariants = List<String>.from(map['weightVariants']);
    } else if (map['specifications'] != null &&
        map['specifications']['weightVariants'] != null) {
      weightVariants = List<String>.from(
        map['specifications']['weightVariants'],
      );
    }

    print(
      'Loading product ${map['name']} with ${images.length} images',
    ); // Debug log
    print('Weight variants: $weightVariants'); // Debug log

    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      originalPrice: (map['originalPrice'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      images: images,
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      brand: map['brand'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviews: map['reviews'] ?? 0,
      isInStock: map['isInStock'] ?? true,
      stock: map['stock'] ?? 0,
      sku: map['sku'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
      weightVariants: weightVariants,
      specifications: Map<String, dynamic>.from(map['specifications'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discount': discount,
      'images': images,
      'category': category,
      'subCategory': subCategory,
      'brand': brand,
      'rating': rating,
      'reviews': reviews,
      'isInStock': isInStock,
      'stock': stock,
      'sku': sku,
      'isFeatured': isFeatured,
      'weightVariants': weightVariants, // Store weight variants directly
      'specifications': {
        ...specifications,
        'weightVariants':
            weightVariants, // Also store in specifications for backward compatibility
      },
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create a copy of the product with updated fields
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    double? discount,
    List<String>? images,
    String? category,
    String? subCategory,
    String? brand,
    double? rating,
    int? reviews,
    bool? isInStock,
    int? stock,
    String? sku,
    bool? isFeatured,
    List<String>? weightVariants,
    Map<String, dynamic>? specifications,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
      images: images ?? this.images,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      isInStock: isInStock ?? this.isInStock,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
      isFeatured: isFeatured ?? this.isFeatured,
      weightVariants: weightVariants ?? this.weightVariants,
      specifications: specifications ?? this.specifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Create an empty product model
  static ProductModel empty() {
    return ProductModel(
      id: '',
      name: '',
      description: '',
      price: 0,
      originalPrice: 0,
      discount: 0,
      images: [],
      category: '',
      subCategory: '',
      brand: '',
      rating: 0,
      reviews: 0,
      isInStock: true,
      stock: 0,
      sku: '',
      isFeatured: false,
      weightVariants: [],
      specifications: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Check if product is valid
  bool get isValid {
    return name.isNotEmpty &&
        description.isNotEmpty &&
        price > 0 &&
        originalPrice > 0 &&
        category.isNotEmpty &&
        brand.isNotEmpty &&
        images.isNotEmpty;
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, images: ${images.length}, weightVariants: $weightVariants)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
