import 'package:flutter/material.dart';

// ==================== MENU MODEL ====================
class SubMenuModel {
  final String name;
  final String route;
  final IconData? icon;

  SubMenuModel({required this.name, required this.route, this.icon});
}

class MenuModel {
  final String name;
  final IconData icon;
  final String route;
  final List<SubMenuModel> subMenus;

  MenuModel({
    required this.name,
    required this.icon,
    required this.route,
    this.subMenus = const [],
  });
}
