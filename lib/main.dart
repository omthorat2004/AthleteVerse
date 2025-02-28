import 'package:flutter/material.dart';
import 'presentations/screens/home.dart';
import 'presentations/screens/features.dart';
void main() {
  runApp(AthleteManagementApp());
}

class AthleteManagementApp extends StatelessWidget {
  const AthleteManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athlete Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define the initial route and the named routes for navigation
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/home': (context) => HomePage(),
        '/features':(context)=>FeaturesScreen()
      },
    );
  }
}


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
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
