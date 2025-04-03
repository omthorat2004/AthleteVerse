import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomeOverviewPage extends StatelessWidget {
  final List<IncomeSource> incomeSources = [
    IncomeSource(
      name: 'Team Salary', 
      amount: 75000, 
      date: DateTime(2023, 6, 1), 
      recurring: true,
      category: 'Salary',
      paymentMethod: 'Bank Transfer'
    ),
    IncomeSource(
      name: 'Match Fees', 
      amount: 25000, 
      date: DateTime(2023, 6, 10), 
      recurring: false,
      category: 'Performance',
      paymentMethod: 'Bank Transfer'
    ),
    IncomeSource(
      name: 'Tournament Prize', 
      amount: 50000, 
      date: DateTime(2023, 6, 15), 
      recurring: false,
      category: 'Prize Money',
      paymentMethod: 'Cheque'
    ),
    IncomeSource(
      name: 'Sponsorship Payment', 
      amount: 100000, 
      date: DateTime(2023, 6, 5), 
      recurring: true,
      category: 'Sponsorship',
      paymentMethod: 'Bank Transfer'
    ),
    IncomeSource(
      name: 'Appearance Fees', 
      amount: 20000, 
      date: DateTime(2023, 6, 20), 
      recurring: false,
      category: 'Appearance',
      paymentMethod: 'Cash'
    ),
  ];

 IncomeOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalIncome = incomeSources.fold<double>(0, (sum, source) => sum + source.amount);
 final int currentMonth = DateTime.now().month;
final double monthlyAverage = totalIncome / currentMonth;

    final recurringIncome = incomeSources
        .where((source) => source.recurring)
        .fold<double>(0, (sum, source) => sum + source.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSummaryCards(totalIncome, monthlyAverage, recurringIncome),
          const SizedBox(height: 20),
          _buildIncomeChart(),
          const SizedBox(height: 20),
          _buildIncomeSourcesTable(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_money_rounded, color: Colors.white),
          const SizedBox(width: 12),
          Text(
            'Income Overview - ${DateFormat('MMMM y').format(DateTime.now())}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(double total, double monthlyAvg, double recurring) {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard(
          title: 'Total Income',
          value: total,
          icon: Icons.account_balance_wallet_rounded,
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard(
          title: 'Monthly Avg',
          value: monthlyAvg,
          icon: Icons.calendar_today_rounded,
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard(
          title: 'Recurring',
          value: recurring,
          icon: Icons.autorenew_rounded,
        )),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: Colors.blue[800]),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(value),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: SfCircularChart(
                palette: const [
                  Color(0xFF1E88E5),
                  Color(0xFF42A5F5),
                  Color(0xFF64B5F6),
                  Color(0xFF90CAF9),
                  Color(0xFFBBDEFB),
                ],
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                  textStyle: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 12,
                  ),
                ),
                series: <CircularSeries>[
                  PieSeries<IncomeSource, String>(
                    dataSource: incomeSources,
                    xValueMapper: (IncomeSource data, _) => data.name,
                    yValueMapper: (IncomeSource data, _) => data.amount,
                    dataLabelMapper: (IncomeSource data, _) => 
                      NumberFormat.compactCurrency(symbol: '₹').format(data.amount),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                      textStyle: TextStyle(fontSize: 10),
                    ),
                    enableTooltip: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeSourcesTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Income',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                headingRowColor: WidgetStateProperty.resolveWith<Color>(
                  (states) => Colors.blue[50]!,
                ),
                columns: [
                  DataColumn(
                    label: Text('Source', style: _headerTextStyle()),
                  ),
                  DataColumn(
                    label: Text('Amount', style: _headerTextStyle()),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Date', style: _headerTextStyle()),
                  ),
                  DataColumn(
                    label: Text('Category', style: _headerTextStyle()),
                  ),
                  DataColumn(
                    label: Text('Method', style: _headerTextStyle()),
                  ),
                  DataColumn(
                    label: Text('Type', style: _headerTextStyle()),
                  ),
                ],
                rows: incomeSources.map((source) {
                  return DataRow(
                    cells: [
                      DataCell(Text(source.name, style: _cellTextStyle())),
                      DataCell(Text(
                        NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(source.amount),
                        style: _cellTextStyle(),
                      )),
                      DataCell(Text(
                        DateFormat('dd MMM').format(source.date),
                        style: _cellTextStyle(),
                      )),
                      DataCell(Text(source.category, style: _cellTextStyle())),
                      DataCell(Text(source.paymentMethod, style: _cellTextStyle())),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: source.recurring ? Colors.blue[50] : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: source.recurring ? Colors.blue : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            source.recurring ? 'Recurring' : 'One-time',
                            style: TextStyle(
                              fontSize: 12,
                              color: source.recurring ? Colors.blue[800] : Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _headerTextStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.blue[800],
    );
  }

  TextStyle _cellTextStyle() {
    return const TextStyle(
      fontSize: 13,
    );
  }
}

class IncomeSource {
  final String name;
  final double amount;
  final DateTime date;
  final bool recurring;
  final String category;
  final String paymentMethod;

  IncomeSource({
    required this.name,
    required this.amount,
    required this.date,
    required this.recurring,
    required this.category,
    required this.paymentMethod,
  });
}