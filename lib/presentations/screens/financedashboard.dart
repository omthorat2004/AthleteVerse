import 'package:flutter/material.dart';
import 'expense_section_page.dart';
import 'sponsorship_page.dart';
import 'income_overview_page.dart'; 

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
        title: const Text('Athlete Finance Management'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
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
           AthleteExpensesPage()
              
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: _tabs[index]['title'],
                selected: _selectedTabIndex == index,
                onSelected: () {
                  setState(() => _selectedTabIndex = index);
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
  final bool selected;
  final VoidCallback onSelected;

  const ChoiceChip({
    super.key,
    required this.label,
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
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.blue[800],
          ),
        ),
      ),
    );
  }
}