// lib/widgets/summary_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  SummaryItem({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'ja_JP', symbol: '¥');
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text(
          currencyFormatter.format(amount),
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
