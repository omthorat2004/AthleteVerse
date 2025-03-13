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

  double getTotalEarnings() {
    return earnings.fold(0, (sum, item) => sum + item['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Income & Earnings Overview"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Earnings",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      currencyFormat.format(getTotalEarnings()),
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Earnings Breakdown",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: earnings.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.monetization_on, color: Colors.green),
                      title: Text(earnings[index]['source'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      subtitle: Text("Received on: ${earnings[index]['date']}", style: TextStyle(color: Colors.grey)),
                      trailing: Text(
                        currencyFormat.format(earnings[index]['amount']),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
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
}
