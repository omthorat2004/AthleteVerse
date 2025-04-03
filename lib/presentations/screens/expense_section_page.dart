import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AthleteExpensesPage extends StatelessWidget {
  const AthleteExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildExpenseAlerts(),
            const SizedBox(height: 24),
            _buildExpenseTrends(),
            const SizedBox(height: 24),
            _buildImprovementTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Athlete Expense Tracker',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A73E8),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: const Text(
            'March 2024',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF5F6368),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return const Row(
      children: [
        Expanded(child: _StatCard(
          title: 'Training Expenses',
          value: '₹42,870',
          change: '+12% from last month',
          isPositive: false,
        )),
        SizedBox(width: 16),
        Expanded(child: _StatCard(
          title: 'AI Predicted',
          value: '₹48,500',
          change: 'Expected next month',
          isPositive: null,
        )),
        SizedBox(width: 16),
        Expanded(child: _StatCard(
          title: 'Savings Potential',
          value: '₹12,000',
          change: '23% of total',
          isPositive: true,
        )),
      ],
    );
  }

  Widget _buildExpenseAlerts() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Expense Alerts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A73E8),
            ),
          ),
          const SizedBox(height: 12),
          _buildAlertItem(
            'High supplement costs',
            'Your sports nutrition expenses are 45% higher than average athletes',
            Icons.warning_amber,
            Colors.orange,
          ),
          const Divider(height: 24),
          _buildAlertItem(
            'Duplicate memberships',
            '3 gym memberships detected. Potential savings: ₹24,000/yr',
            Icons.autorenew,
            Colors.blue,
          ),
          const Divider(height: 24),
          _buildAlertItem(
            'Equipment overspending',
            'Based on trends, you may exceed your gear budget by ₹5,630',
            Icons.trending_up,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String message, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseTrends() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Training Expense Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A73E8),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(months[value.toInt()]),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('₹${value.toInt()}0k');
                      },
                      reservedSize: 40,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: 3,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3.2),
                      FlSpot(1, 3.8),
                      FlSpot(2, 4.3),
                      FlSpot(3, 4.8),
                    ],
                    isCurved: true,
                    color: const Color(0xFF1A73E8),
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3.4),
                      FlSpot(1, 3.7),
                      FlSpot(2, 4.5),
                      FlSpot(3, 4.8),
                    ],
                    isCurved: true,
                    color: const Color(0xFF34A853),
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ChartLegend(color: Color(0xFF1A73E8), text: 'Actual'),
              SizedBox(width: 20),
              _ChartLegend(color: Color(0xFF34A853), text: 'Predicted'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'AI Analysis: Your coaching fees are trending upward (18% monthly increase). '
            'Consider group training sessions to reduce costs.',
            style: TextStyle(
              color: Color(0xFF5F6368),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Athlete Budget Optimization',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A73E8),
            ),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            'Sports Nutrition',
            'Buying supplements in bulk could save ~₹12,000 annually on your protein intake.',
          ),
          const Divider(height: 24),
          _buildTipItem(
            'Training Facilities',
            'Government sports hostels offer facilities at 60% lower cost than private gyms.',
          ),
          const Divider(height: 24),
          _buildTipItem(
            'Equipment Sharing',
            'Partner with 2 other athletes to share equipment costs. Potential savings: ₹18,500/year.',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.lightbulb_outline, color: Color(0xFF1A73E8), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool? isPositive;

  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    Color? changeColor;
    if (isPositive != null) {
      changeColor = isPositive! ? Colors.green : Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A73E8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            change,
            style: TextStyle(
              color: changeColor ?? Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String text;

  const _ChartLegend({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF5F6368),
          ),
        ),
      ],
    );
  }
}