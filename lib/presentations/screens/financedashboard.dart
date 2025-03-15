import 'package:flutter/material.dart';
import '../components/finance/IncomeEarningsOverview.dart';

class FinanceDashboard extends StatefulWidget {
  @override
  _FinanceDashboardState createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    IncomeEarningsOverview(),
    Center(child: Text('Sponsorship & Endorsements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    Center(child: Text('Expense Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    Center(child: Text('Budget Planning & Savings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Finance Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    _buildTabButton('Overview', 0),
                    _buildTabButton('Sponsorship & Endorsements', 1),
                    _buildTabButton('Expense Management', 2),
                    _buildTabButton('Budget Planning & Savings', 3),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add spacing between buttons
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: _selectedIndex == index ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blueAccent, width: 1.5),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _selectedIndex == index ? Colors.white : Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
