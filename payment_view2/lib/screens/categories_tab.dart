// lib/screens/categories_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../widgets/category_item.dart';

class CategoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);
    return Column(
      children: [
        // カテゴリ別支出
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('カテゴリ別支出',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('支出のカテゴリ別内訳', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 16),
                Column(
                  children: budgetProvider.categories.map((category) {
                    double amount =
                        budgetProvider.getTotalByCategory(category.name);
                    return CategoryItem(
                      category: category,
                      amount: amount,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
