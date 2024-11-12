// lib/widgets/category_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final double amount;

  CategoryItem({required this.category, required this.amount});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'ja_JP', symbol: '¥');
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: category.bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                category.icon,
                color: category.color,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(category.name, style: TextStyle(fontSize: 16)),
            ],
          ),
          Text(
            currencyFormatter.format(amount),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
