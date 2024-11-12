// lib/widgets/expense_list_tile.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ExpenseListTile({
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'ja_JP', symbol: '¥');
    return ListTile(
      title: Text(expense.name),
      subtitle: Text(DateFormat('MM/dd').format(expense.date)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currencyFormatter.format(expense.amount),
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
