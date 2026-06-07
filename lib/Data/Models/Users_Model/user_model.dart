import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String role;
  final String status; // 'active', 'blocked', 'pending'
  final DateTime createdAt;
  final DateTime lastLogin;
  final DateTime? blockedAt;
  final String? blockedReason;
  final Map<String, dynamic> profile;
  final List<String> permissions;
  final int orderCount;
  final double totalSpent;
  final int reviewCount;
  final int reportCount;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.lastLogin,
    this.blockedAt,
    this.blockedReason,
    required this.profile,
    required this.permissions,
    required this.orderCount,
    required this.totalSpent,
    required this.reviewCount,
    required this.reportCount,
  });

  // Create from Firestore
  factory UserModel.fromFirestore(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      avatar: data['avatar'] ?? '',
      role: data['role'] ?? 'user',
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      blockedAt: (data['blockedAt'] as Timestamp?)?.toDate(),
      blockedReason: data['blockedReason'],
      profile: Map<String, dynamic>.from(data['profile'] ?? {}),
      permissions: List<String>.from(data['permissions'] ?? []),
      orderCount: data['orderCount'] ?? 0,
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      reportCount: data['reportCount'] ?? 0,
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'role': role,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'blockedAt': blockedAt != null ? Timestamp.fromDate(blockedAt!) : null,
      'blockedReason': blockedReason,
      'profile': profile,
      'permissions': permissions,
      'orderCount': orderCount,
      'totalSpent': totalSpent,
      'reviewCount': reviewCount,
      'reportCount': reportCount,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? lastLogin,
    DateTime? blockedAt,
    String? blockedReason,
    Map<String, dynamic>? profile,
    List<String>? permissions,
    int? orderCount,
    double? totalSpent,
    int? reviewCount,
    int? reportCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      blockedAt: blockedAt ?? this.blockedAt,
      blockedReason: blockedReason ?? this.blockedReason,
      profile: profile ?? this.profile,
      permissions: permissions ?? this.permissions,
      orderCount: orderCount ?? this.orderCount,
      totalSpent: totalSpent ?? this.totalSpent,
      reviewCount: reviewCount ?? this.reviewCount,
      reportCount: reportCount ?? this.reportCount,
    );
  }
}

class UserRole {
  final String id;
  final String name;
  final String description;
  final int userCount;
  final List<String> permissions;
  final bool isDefault;
  final DateTime createdAt;

  UserRole({
    required this.id,
    required this.name,
    required this.description,
    required this.userCount,
    required this.permissions,
    required this.isDefault,
    required this.createdAt,
  });

  factory UserRole.fromFirestore(String id, Map<String, dynamic> data) {
    return UserRole(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      userCount: data['userCount'] ?? 0,
      permissions: List<String>.from(data['permissions'] ?? []),
      isDefault: data['isDefault'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'userCount': userCount,
      'permissions': permissions,
      'isDefault': isDefault,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserRole copyWith({
    String? id,
    String? name,
    String? description,
    int? userCount,
    List<String>? permissions,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return UserRole(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userCount: userCount ?? this.userCount,
      permissions: permissions ?? this.permissions,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Permission {
  final String id;
  final String name;
  final String category;
  final String description;
  final bool isEnabled;

  Permission({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.isEnabled,
  });

  factory Permission.fromFirestore(String id, Map<String, dynamic> data) {
    return Permission(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      isEnabled: data['isEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'isEnabled': isEnabled,
    };
  }

  Permission copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    bool? isEnabled,
  }) {
    return Permission(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class UserReport {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String reporterId;
  final String reporterName;
  final String reason;
  final String description;
  final String status; // 'pending', 'reviewed', 'resolved'
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolution;

  UserReport({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.reporterId,
    required this.reporterName,
    required this.reason,
    required this.description,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.resolution,
  });

  factory UserReport.fromFirestore(String id, Map<String, dynamic> data) {
    return UserReport(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      reporterId: data['reporterId'] ?? '',
      reporterName: data['reporterName'] ?? '',
      reason: data['reason'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
      resolution: data['resolution'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'reason': reason,
      'description': description,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'resolution': resolution,
    };
  }
}
