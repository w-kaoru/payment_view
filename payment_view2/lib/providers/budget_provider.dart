// lib/providers/budget_provider.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/subscription.dart';
import '../models/category.dart';
import '../services/data_service.dart';

class BudgetProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  List<Expense> _expenses = [];
  List<Subscription> _subscriptions = [];
  List<Category> _categories = [
    Category(
      name: '投資',
      icon: Icons.trending_up,
      color: Colors.blue,
      bgColor: Colors.blue.shade50,
    ),
    Category(
      name: '消費',
      icon: Icons.shopping_cart,
      color: Colors.green,
      bgColor: Colors.green.shade50,
    ),
    Category(
      name: '浪費',
      icon: Icons.coffee,
      color: Colors.red,
      bgColor: Colors.red.shade50,
    ),
    Category(
      name: '生活費',
      icon: Icons.home,
      color: Colors.purple,
      bgColor: Colors.purple.shade50,
    ),
  ];

  List<Expense> get expenses => _expenses;
  List<Subscription> get subscriptions => _subscriptions;
  List<Category> get categories => _categories;

  BudgetProvider() {
    _loadExpenses();
    _loadSubscriptions();
  }

  Future<void> _loadExpenses() async {
    _expenses = await _dataService.getExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _dataService.insertExpense(expense);
    _expenses = await _dataService.getExpenses();
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await _dataService.updateExpense(expense);
    _expenses = await _dataService.getExpenses();
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    await _dataService.deleteExpense(id);
    _expenses = await _dataService.getExpenses();
    notifyListeners();
  }

  Future<void> _loadSubscriptions() async {
    _subscriptions = await _dataService.getSubscriptions();
    notifyListeners();
  }

  Future<void> addSubscription(Subscription subscription) async {
    await _dataService.insertSubscription(subscription);
    _subscriptions = await _dataService.getSubscriptions();
    notifyListeners();
  }

  Future<void> updateSubscription(Subscription subscription) async {
    await _dataService.updateSubscription(subscription);
    _subscriptions = await _dataService.getSubscriptions();
    notifyListeners();
  }

  Future<void> deleteSubscription(int id) async {
    await _dataService.deleteSubscription(id);
    _subscriptions = await _dataService.getSubscriptions();
    notifyListeners();
  }

  // カテゴリに基づいた支出の合計
  double getTotalByCategory(String category) {
    return _expenses
        .where((expense) => expense.category == category)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // 総収入、総支出、残高の計算（サンプル値を使用）
  double get totalIncome => 350000;
  double get totalExpenses => _expenses.fold(0.0, (sum, item) => sum + item.amount);
  double get balance => totalIncome - totalExpenses;
}
