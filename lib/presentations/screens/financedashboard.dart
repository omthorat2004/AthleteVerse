import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  int _selectedTabIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _tabs = [
    {'title': 'Income Overview', 'icon': Icons.bar_chart_rounded},
    {'title': 'Sponsorships', 'icon': Icons.verified_user_rounded},
    {'title': 'Expenses', 'icon': Icons.receipt_long_rounded},
    {'title': 'Savings Plan', 'icon': Icons.savings_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Athlete Finance Management',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                IncomeOverviewPage(),
                SponsorshipsPage(),
                // ExpensesPage(),
                // SavingsPlanPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: _tabs[index]['title'],
                icon: _tabs[index]['icon'],
                selected: _selectedTabIndex == index,
                onSelected: () {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                  _pageController.jumpToPage(index);
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ChoiceChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onSelected;

  const ChoiceChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.blue[800] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.blue[800]! : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : Colors.blue[800],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncomeOverviewPage extends StatelessWidget {
  // Realistic income sources for a mid-level athlete (monthly amounts)
  final List<IncomeSource> incomeSources = [
    IncomeSource('Team Salary', 75000, DateTime(2023, 6, 1), true),
    IncomeSource('Match Fees', 25000, DateTime(2023, 6, 10), false),
    IncomeSource('Tournament Prize', 50000, DateTime(2023, 6, 15), false),
    IncomeSource('Training Stipend', 15000, DateTime(2023, 6, 1), true),
    IncomeSource('Appearance Fees', 20000, DateTime(2023, 6, 20), false),
  ];

  IncomeOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalIncome = incomeSources.fold<double>(0, (sum, source) => sum + source.amount);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Income Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildIncomeSummaryCard(totalIncome),
          const SizedBox(height: 24),
          Text(
            'Income Sources',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 12),
          ...incomeSources.map((source) => _buildIncomeSourceCard(source)).toList(),
        ],
      ),
    );
  }

  Widget _buildIncomeSummaryCard(double total) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[800]!, Colors.blue[600]!],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.attach_money_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "Total Expected Income",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(total)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current Month: ${DateFormat('MMMM y').format(DateTime.now())}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeSourceCard(IncomeSource source) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    source.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: source.recurring ? Colors.green[50] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    source.recurring ? 'Recurring' : 'One-time',
                    style: TextStyle(
                      color: source.recurring ? Colors.green[800] : Colors.blue[800],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  DateFormat('d MMM y').format(source.date),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  '${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(source.amount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IncomeSource {
  final String name;
  final double amount;
  final DateTime date;
  final bool recurring;

  IncomeSource(this.name, this.amount, this.date, this.recurring);
}

class SponsorshipsPage extends StatelessWidget {
  // Realistic sponsorships for a mid-level athlete (annual amounts)
  final List<Sponsorship> sponsorships = [
    Sponsorship(
      'Local Sports Brand', 
      120000, 
      DateTime(2023, 1, 1), 
      DateTime(2023, 12, 31),
      'Apparel Sponsor',
      ['Free equipment', 'Discount codes for fans']
    ),
    Sponsorship(
      'Energy Drink Company', 
      80000, 
      DateTime(2023, 3, 1), 
      DateTime(2023, 11, 30),
      'Nutrition Sponsor',
      ['Product supply', 'Social media features']
    ),
    Sponsorship(
      'Regional Bank', 
      60000, 
      DateTime(2023, 2, 1), 
      DateTime(2024, 1, 31),
      'Financial Sponsor',
      ['Branch appearances', 'Community events']
    ),
  ];

  SponsorshipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Sponsorships',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          ...sponsorships.map((sponsor) => _buildSponsorshipCard(sponsor)).toList(),
          const SizedBox(height: 24),
          _buildSponsorshipSummary(),
        ],
      ),
    );
  }

  Widget _buildSponsorshipCard(Sponsorship sponsor) {
    final progress = _calculateProgress(sponsor);
    final monthsRemaining = sponsor.endDate.difference(DateTime.now()).inDays ~/ 30;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      sponsor.brand[0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sponsor.brand,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sponsor.type,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${DateFormat('MMM y').format(sponsor.startDate)} - ${DateFormat('MMM y').format(sponsor.endDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(sponsor.value)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$monthsRemaining months left',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.75 ? Colors.red[400]! : 
                  progress > 0.5 ? Colors.orange[400]! : Colors.blue[800]!,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% complete',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Until ${DateFormat('d MMM y').format(sponsor.endDate)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Benefits:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 4),
            Column(
              children: sponsor.benefits.map((benefit) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      benefit,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateProgress(Sponsorship sponsor) {
    final totalDays = sponsor.endDate.difference(sponsor.startDate).inDays;
    final daysPassed = DateTime.now().difference(sponsor.startDate).inDays;
    return daysPassed / totalDays;
  }

  Widget _buildSponsorshipSummary() {
    final totalValue = sponsorships.fold<double>(0, (sum, sponsor) => sum + sponsor.value);
    final averageValue = totalValue / sponsorships.length;
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.people_alt_rounded, color: Colors.blue[800]),
                const SizedBox(width: 8),
                Text(
                  "Sponsorship Summary",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryMetric(
                  'Total Value', 
                  '${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(totalValue)}'
                ),
                _buildSummaryMetric(
                  'Avg. Annual', 
                  '${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(averageValue)}'
                ),
                _buildSummaryMetric(
                  'Active Deals', 
                  sponsorships.length.toString()
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class Sponsorship {
  final String brand;
  final double value;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final List<String> benefits;

  Sponsorship(
    this.brand, 
    this.value, 
    this.startDate, 
    this.endDate,
    this.type,
    this.benefits,
  );
}