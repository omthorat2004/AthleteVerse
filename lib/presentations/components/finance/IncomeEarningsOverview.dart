import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeEarningsOverview extends StatefulWidget {
  @override
  _IncomeEarningsOverviewState createState() => _IncomeEarningsOverviewState();
}

class _IncomeEarningsOverviewState extends State<IncomeEarningsOverview> {
  final currencyFormat = NumberFormat.currency(symbol: "₹");

  final List<Map<String, dynamic>> earnings = [
    {"source": "Sponsorship", "amount": 50000, "date": "2025-03-01"},
    {"source": "Endorsement", "amount": 30000, "date": "2025-02-15"},
    {"source": "Prize Money", "amount": 70000, "date": "2025-02-10"},
    {"source": "Salary", "amount": 60000, "date": "2025-01-30"},
  ];

  final List<Map<String, dynamic>> upcomingPayments = [
    {"source": "Training Fee", "amount": 15000, "date": "2025-03-10"},
    {"source": "Equipment Purchase", "amount": 20000, "date": "2025-03-15"},
  ];

  double getTotalEarnings() {
    return earnings.fold(0, (sum, item) => sum + item['amount']);
  }

  double getSponsorshipRevenue() {
    return earnings.where((e) => e['source'] == "Sponsorship").fold(0, (sum, item) => sum + item['amount']);
  }

  double getSponsorshipExpenses() {
    return 25000; // Example value
  }

  double getNetBalance() {
    return getTotalEarnings() - getSponsorshipExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFinanceCard("Total Income", getTotalEarnings()),
            buildFinanceCard("Sponsorship Revenue", getSponsorshipRevenue()),
            buildFinanceCard("Sponsorship Expenses", getSponsorshipExpenses()),
            buildFinanceCard("Net Balance", getNetBalance()),
            SizedBox(height: 20),
            Text("Upcoming Payments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: upcomingPayments.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.warning_amber_rounded, color: Colors.blueAccent),
                      title: Text(upcomingPayments[index]['source'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      subtitle: Text("Due on: ${upcomingPayments[index]['date']}", style: TextStyle(color: Colors.black54)),
                      trailing: Text(
                        currencyFormat.format(upcomingPayments[index]['amount']),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFinanceCard(String title, double amount) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 10),
            Text(
              currencyFormat.format(amount),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
