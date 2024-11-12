// lib/models/subscription.dart
class Subscription {
  final int? id;
  final String name;
  final double amount;
  final String cycle;
  final String date;
  final String category; // 追加

  Subscription({
    this.id,
    required this.name,
    required this.amount,
    required this.cycle,
    required this.date,
    required this.category, // 追加
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'cycle': cycle,
      'date': date,
      'category': category, // 追加
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      cycle: map['cycle'],
      date: map['date'],
      category: map['category'], // 追加
    );
  }
}
