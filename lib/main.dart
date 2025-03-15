import 'package:flutter/material.dart';
import 'package:myapp/presentations/screens/anonymousreporting.dart';
import 'package:myapp/presentations/screens/rentpage.dart';
import 'presentations/screens/finance.dart' show FinanceScreen;
import 'presentations/screens/home.dart';
import 'presentations/screens/features.dart';
import 'presentations/screens/performancetracking.dart';
import 'presentations/screens/checklist.dart';
import 'presentations/screens/graph.dart';
import 'presentations/screens/game.dart';
import 'presentations/screens/financedashboard.dart';

void main() {
  runApp(AthleteManagementApp());
}

class AthleteManagementApp extends StatelessWidget {
  const AthleteManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athlete Management',
      theme: ThemeData(primarySwatch: Colors.blue),

      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/home': (context) => HomePage(),
        '/features': (context) => FeaturesScreen(),
        '/performance_tracking': (context) => PerformanceScreen(),
        '/checklist': (context) => ChecklistScreen(),
        '/graph': (context) => AthleteProgressScreen(),
        '/game': (context) => GameScreen(),
        '/finance': (context) => FinanceScreen(),
        '/anonymousreporting': (context) => AnonymousReportScreen(),
        '/finance/rentpage': (context) => SportsKitPage(),
        '/finance/dashboard': (context) => FinanceDashboard(),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the HomePage using its named route
            Navigator.pushNamed(context, '/home');
          },
          child: Text('Go to Athlete Management Home'),
        ),
      ),
    );
  }
}
