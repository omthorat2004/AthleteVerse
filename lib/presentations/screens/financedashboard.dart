import 'package:flutter/material.dart';
import '../components/finance/IncomeEarningsOverview.dart';

class Financedashboard extends StatefulWidget {
  @override
  _FinanceDashboardState createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<Financedashboard> {
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
      body: IncomeEarningsOverview(),
    );
  }
}
