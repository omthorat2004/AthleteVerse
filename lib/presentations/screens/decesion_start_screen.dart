import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback onStartPressed;
  final int totalPoints;
  final String moduleName;

  const StartScreen({super.key, 
    required this.onStartPressed,
    required this.totalPoints,
    required this.moduleName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Module: $moduleName",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 20),
          Text(
            "About the Game:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              moduleName == "Contract Clarity"
                  ? "In this game, you will help Priya navigate through tricky contract clauses and make the right decisions to protect her career."
                  : "Learn how to handle doping allegations professionally while protecting your career.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Total Points: $totalPoints",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: onStartPressed,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Start Game", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}