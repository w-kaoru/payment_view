// lib/widgets/subscription_list_tile.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';

class SubscriptionListTile extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  SubscriptionListTile({
    required this.subscription,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'ja_JP', symbol: '¥');
    return ListTile(
      title: Text(subscription.name),
      subtitle: Text('引落日: ${subscription.date}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currencyFormatter.format(subscription.amount),
            style: TextStyle(
              color: Colors.blue,
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
