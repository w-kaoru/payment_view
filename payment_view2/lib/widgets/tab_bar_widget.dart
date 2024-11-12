// lib/widgets/tab_bar_widget.dart
import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabSelected;

  TabBarWidget({required this.activeTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'label': '概要', 'value': 'overview'},
      {'label': '支出', 'value': 'expenses'},
      {'label': 'サブスク', 'value': 'subscriptions'},
      {'label': 'カテゴリ', 'value': 'categories'},
      {'label': 'レポート', 'value': 'reports'},
    ];

    return Container(
      color: Colors.grey.shade200,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isLargeScreen = constraints.maxWidth >= 1024;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tabs.map((tab) {
              if (!isLargeScreen && (tab['value'] == 'categories' || tab['value'] == 'reports')) {
                return SizedBox.shrink();
              }
              return Expanded(
                child: TextButton(
                  onPressed: () => onTabSelected(tab['value']!),
                  style: TextButton.styleFrom(
                    backgroundColor: activeTab == tab['value'] ? Colors.white : Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    tab['label']!,
                    style: TextStyle(
                      color: activeTab == tab['value'] ? Colors.blue : Colors.black,
                      fontWeight: activeTab == tab['value'] ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
