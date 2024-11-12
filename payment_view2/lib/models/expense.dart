// lib/models/expense.dart
import 'package:flutter/material.dart';

class Expense {
  final int? id;
  final DateTime date;
  final String name;
  final double amount;
  final String category;

  Expense({
    this.id,
    required this.date,
    required this.name,
    required this.amount,
    required this.category,
  });

  // データベースへの保存用に変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'name': name,
      'amount': amount,
      'category': category,
    };
  }

  // データベースからの読み込み用
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      date: DateTime.parse(map['date']),
      name: map['name'],
      amount: map['amount'],
      category: map['category'],
    );
  }
}
