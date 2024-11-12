// lib/screens/overview_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../widgets/summary_item.dart';
import '../widgets/expense_list_tile.dart';
import 'package:intl/intl.dart';

class OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'ja_JP', symbol: '¥');
    return Column(
      children: [
        // 今月の概要カード
        Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('今月の概要', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('2024年4月の収支状況', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SummaryItem(label: '総収入', amount: budgetProvider.totalIncome, color: Colors.green),
                    SummaryItem(label: '総支出', amount: budgetProvider.totalExpenses, color: Colors.red),
                    SummaryItem(label: '残高', amount: budgetProvider.balance, color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
        // 最近の支出カード
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('最近の支出', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('直近の支出履歴', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 16),
                Column(
                  children: budgetProvider.expenses.take(3).map((expense) {
                    return ExpenseListTile(
                      expense: expense,
                      onEdit: () {
                        // 編集処理を追加
                      },
                      onDelete: () {
                        // 削除処理を追加
                      },
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
