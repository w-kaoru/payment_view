// lib/screens/expenses_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../models/expense.dart';
import '../widgets/expense_list_tile.dart';
import 'package:intl/intl.dart';

class ExpensesTab extends StatefulWidget {
  @override
  _ExpensesTabState createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _deleteExpense(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('削除確認'),
        content: Text('本当にこの支出を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Provider.of<BudgetProvider>(context, listen: false).deleteExpense(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('支出が削除されました')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final expense = Expense(
          date: DateTime.parse(_dateController.text),
          name: _nameController.text,
          amount: double.parse(_amountController.text),
          category: _selectedCategory!,
        );
        await Provider.of<BudgetProvider>(context, listen: false).addExpense(expense);
        // フォームをクリア
        _formKey.currentState!.reset();
        _dateController.clear();
        _nameController.clear();
        _amountController.clear();
        setState(() {
          _selectedCategory = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('支出が追加されました')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('支出の追加に失敗しました')),
        );
      }
    }
  }

  void _editExpense(Expense expense) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController editDateController =
            TextEditingController(text: DateFormat('yyyy-MM-dd').format(expense.date));
        final TextEditingController editNameController =
            TextEditingController(text: expense.name);
        final TextEditingController editAmountController =
            TextEditingController(text: expense.amount.toString());
        String? editSelectedCategory = expense.category;

        return AlertDialog(
          title: Text('支出の編集'),
          content: SingleChildScrollView(
            child: Form(
              key: GlobalKey<FormState>(), // 新しいキーを使用
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 日付
                  TextFormField(
                    controller: editDateController,
                    decoration: InputDecoration(
                      labelText: '日付',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '日付を選択してください';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: expense.date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        editDateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  // 項目名
                  TextFormField(
                    controller: editNameController,
                    decoration: InputDecoration(
                      labelText: '項目名',
                      hintText: '例：スーパーでの買い物',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '項目名を入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // 金額
                  TextFormField(
                    controller: editAmountController,
                    decoration: InputDecoration(
                      labelText: '金額',
                      hintText: '5000',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '金額を入力してください';
                      }
                      if (double.tryParse(value) == null) {
                        return '有効な金額を入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // カテゴリ
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'カテゴリ',
                      border: OutlineInputBorder(),
                    ),
                    value: editSelectedCategory,
                    items: Provider.of<BudgetProvider>(context, listen: false)
                        .categories
                        .map((category) {
                      return DropdownMenuItem<String>(
                        value: category.name,
                        child: Row(
                          children: [
                            Icon(category.icon, color: category.color, size: 20),
                            SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        editSelectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'カテゴリを選択してください';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                final form = Form.of(context);
                if (form != null && form.validate()) {
                  try {
                    final updatedExpense = Expense(
                      id: expense.id,
                      date: DateTime.parse(editDateController.text),
                      name: editNameController.text,
                      amount: double.parse(editAmountController.text),
                      category: editSelectedCategory!,
                    );
                    await Provider.of<BudgetProvider>(context, listen: false)
                        .updateExpense(updatedExpense);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('支出が更新されました')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('支出の更新に失敗しました')),
                    );
                  }
                }
              },
              child: Text('保存'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);
    return Column(
      children: [
        // 支出の登録フォーム
        Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('支出の登録',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('新しい支出を追加してください',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 16),
                  // 日付
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: '日付',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '日付を選択してください';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  // 項目名
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '項目名',
                      hintText: '例：スーパーでの買い物',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '項目名を入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // 金額
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: '金額',
                      hintText: '5000',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '金額を入力してください';
                      }
                      if (double.tryParse(value) == null) {
                        return '有効な金額を入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // カテゴリ
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'カテゴリ',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCategory,
                    items: budgetProvider.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.name,
                        child: Row(
                          children: [
                            Icon(category.icon, color: category.color, size: 20),
                            SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'カテゴリを選択してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  // ボタン
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                          _dateController.clear();
                          _nameController.clear();
                          _amountController.clear();
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                        child: Text('キャンセル'),
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('登録する'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // 支出の一覧
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('支出一覧',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  budgetProvider.expenses.isEmpty
                      ? Expanded(child: Center(child: Text('支出がありません')))
                      : ListView.builder(
                          itemCount: budgetProvider.expenses.length,
                          itemBuilder: (context, index) {
                            final expense = budgetProvider.expenses[index];
                            return ExpenseListTile(
                              expense: expense,
                              onEdit: () => _editExpense(expense),
                              onDelete: () => _deleteExpense(expense.id!),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
