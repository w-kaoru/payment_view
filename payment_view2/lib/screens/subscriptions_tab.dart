// lib/screens/subscriptions_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../models/subscription.dart';
import '../widgets/subscription_list_tile.dart';
import 'package:intl/intl.dart';

class SubscriptionsTab extends StatefulWidget {
  @override
  _SubscriptionsTabState createState() => _SubscriptionsTabState();
}

class _SubscriptionsTabState extends State<SubscriptionsTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  String? _selectedCycle; // 新しく追加

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _deleteSubscription(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('削除確認'),
        content: Text('本当にこのサブスクリプションを削除しますか？'),
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
      await Provider.of<BudgetProvider>(context, listen: false)
          .deleteSubscription(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('サブスクリプションが削除されました')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final subscription = Subscription(
          date: DateFormat('yyyy-MM-dd').format(DateTime.parse(_dateController.text)),
          name: _nameController.text,
          amount: double.parse(_amountController.text),
          cycle: _selectedCycle!, // 必須パラメータ
          category: _selectedCategory!, // 追加
        );
        await Provider.of<BudgetProvider>(context, listen: false)
            .addSubscription(subscription);
        // フォームをクリア
        _formKey.currentState!.reset();
        _dateController.clear();
        _nameController.clear();
        _amountController.clear();
        setState(() {
          _selectedCategory = null;
          _selectedCycle = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('サブスクリプションが追加されました')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('サブスクリプションの追加に失敗しました')),
        );
      }
    }
  }

  void _editSubscription(Subscription subscription) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController editDateController =
            TextEditingController(text: subscription.date);
        final TextEditingController editNameController =
            TextEditingController(text: subscription.name);
        final TextEditingController editAmountController =
            TextEditingController(text: subscription.amount.toString());
        String? editSelectedCategory = subscription.category;
        String? editSelectedCycle = subscription.cycle; // 追加

        return AlertDialog(
          title: Text('サブスクリプションの編集'),
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
                        initialDate: DateTime.parse(subscription.date),
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
                      hintText: '例：Netflixサブスクリプション',
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
                      hintText: '月額料金',
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
                  SizedBox(height: 16),
                  // 周期
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: '周期',
                      border: OutlineInputBorder(),
                    ),
                    value: editSelectedCycle,
                    items: ['毎月', '毎年', '毎週', 'その他'].map((cycle) {
                      return DropdownMenuItem<String>(
                        value: cycle,
                        child: Text(cycle),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        editSelectedCycle = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '周期を選択してください';
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
                    final updatedSubscription = Subscription(
                      id: subscription.id,
                      date: editDateController.text,
                      name: editNameController.text,
                      amount: double.parse(editAmountController.text),
                      cycle: editSelectedCycle!,
                      category: editSelectedCategory!, // 追加
                    );
                    await Provider.of<BudgetProvider>(context, listen: false)
                        .updateSubscription(updatedSubscription);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('サブスクリプションが更新されました')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('サブスクリプションの更新に失敗しました')),
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
        // サブスクリプションの登録フォーム
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
                  Text('サブスクリプションの登録',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('新しいサブスクリプションを追加してください',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 16),
                  // 引き落とし日
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: '引き落とし日',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '引き落とし日を選択してください';
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
                      hintText: '例：Netflixサブスクリプション',
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
                      hintText: '月額料金',
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
                  SizedBox(height: 16),
                  // 周期
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: '周期',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCycle,
                    items: ['毎月', '毎年', '毎週', 'その他'].map((cycle) {
                      return DropdownMenuItem<String>(
                        value: cycle,
                        child: Text(cycle),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCycle = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '周期を選択してください';
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
                            _selectedCycle = null;
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
        // サブスクリプションの一覧
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('サブスクリプション一覧',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  budgetProvider.subscriptions.isEmpty
                      ? Center(child: Text('サブスクリプションがありません'))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: budgetProvider.subscriptions.length,
                            itemBuilder: (context, index) {
                              final subscription = budgetProvider.subscriptions[index];
                              return SubscriptionListTile(
                                subscription: subscription,
                                onEdit: () => _editSubscription(subscription),
                                onDelete: () => _deleteSubscription(subscription.id!),
                              );
                            },
                          ),
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
