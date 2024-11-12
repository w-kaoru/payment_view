// lib/models/category.dart
import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;
  final Color bgColor;

  Category({
    required this.name,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}
