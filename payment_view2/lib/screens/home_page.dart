// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../widgets/tab_bar_widget.dart';
import 'overview_tab.dart';
import 'expenses_tab.dart';
import 'subscriptions_tab.dart';
import 'categories_tab.dart';
import 'reports_tab.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activeTab = 'overview';
  String activeMonth = DateFormat('yyyy年MM月').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'マイ家計簿',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                helpText: '月を選択',
                fieldLabelText: '月と年を選択',
                // selectableDayPredicate: (day) => false, // これを削除
              );

              if (pickedDate != null) {
                setState(() {
                  activeMonth = DateFormat('yyyy年MM月').format(pickedDate);
                  // 必要に応じて他の状態を更新
                });
              }
            },
            icon: Icon(Icons.calendar_today, color: Colors.white, size: 20),
            label: Text(
              activeMonth,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          TabBarWidget(
            activeTab: activeTab,
            onTabSelected: (tab) {
              setState(() {
                activeTab = tab;
              });
            },
          ),
          Expanded(
            child: getTabContent(),
          ),
        ],
      ),
    );
  }

  Widget getTabContent() {
    switch (activeTab) {
      case 'overview':
        return OverviewTab();
      case 'expenses':
        return ExpensesTab();
      case 'subscriptions':
        return SubscriptionsTab();
      case 'categories':
        return CategoriesTab();
      case 'reports':
        return ReportsTab();
      default:
        return Center(child: Text('タブが見つかりません'));
    }
  }
}
