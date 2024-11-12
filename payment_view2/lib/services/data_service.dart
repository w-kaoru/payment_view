// lib/services/data_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';
import '../models/subscription.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // データベースの初期化
    _database = await _initDB('budget.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2, // バージョンを2に増やす
      onCreate: _createDB,
      onUpgrade: _upgradeDB, // onUpgradeを追加
    );
  }

  Future _createDB(Database db, int version) async {
    // Expenseテーブル
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    // Subscriptionテーブル
    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        cycle TEXT NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE subscriptions ADD COLUMN category TEXT NOT NULL DEFAULT '消費'
      ''');
    }
  }

  // Expense CRUD操作
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final result = await db.query('expenses', orderBy: 'date DESC');
    return result.map((map) => Expense.fromMap(map)).toList();
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Subscription CRUD操作
  Future<int> insertSubscription(Subscription subscription) async {
    final db = await database;
    return await db.insert('subscriptions', subscription.toMap());
  }

  Future<List<Subscription>> getSubscriptions() async {
    final db = await database;
    final result = await db.query('subscriptions', orderBy: 'name ASC');
    return result.map((map) => Subscription.fromMap(map)).toList();
  }

  Future<int> updateSubscription(Subscription subscription) async {
    final db = await database;
    return await db.update(
      'subscriptions',
      subscription.toMap(),
      where: 'id = ?',
      whereArgs: [subscription.id],
    );
  }

  Future<int> deleteSubscription(int id) async {
    final db = await database;
    return await db.delete(
      'subscriptions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
