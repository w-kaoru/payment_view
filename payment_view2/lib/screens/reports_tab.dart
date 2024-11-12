// lib/screens/reports_tab.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import 'package:intl/intl.dart';

class ReportsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'ja_JP', symbol: '¥');

    // 月ごとの収入と支出のサンプルデータ
    final Map<int, double> incomeData = {
      1: budgetProvider.totalIncome,
      2: budgetProvider.totalIncome + 50000,
      3: budgetProvider.totalIncome + 100000,
      4: budgetProvider.totalIncome + 150000,
      5: budgetProvider.totalIncome + 200000,
    };

    final Map<int, double> expenseData = {
      1: budgetProvider.totalExpenses,
      2: budgetProvider.totalExpenses + 30000,
      3: budgetProvider.totalExpenses + 60000,
      4: budgetProvider.totalExpenses + 90000,
      5: budgetProvider.totalExpenses + 120000,
    };

    List<FlSpot> incomeSpots = incomeData.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    List<FlSpot> expenseSpots = expenseData.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

    return Column(
      children: [
        // 月次レポート
        Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('月次レポート', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('支出と収入の推移', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 16),
                Container(
                  height: 300,
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 1:
                                  return Text('1月');
                                case 2:
                                  return Text('2月');
                                case 3:
                                  return Text('3月');
                                case 4:
                                  return Text('4月');
                                case 5:
                                  return Text('5月');
                                default:
                                  return Text('');
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: incomeSpots,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.green,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: expenseSpots,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.red,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // ボタン
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // CSVエクスポート処理を追加
                        },
                        child: Text('CSVエクスポート'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 詳細レポート表示処理を追加
                        },
                        child: Text('詳細レポートを表示'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
