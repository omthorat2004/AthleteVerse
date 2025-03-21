import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/presentations/screens/anonymousreporting.dart';
import 'package:myapp/presentations/screens/splash.dart';
import 'package:myapp/presentations/screens/comentarygame.dart';
import 'package:myapp/presentations/screens/financescheme.dart';
import 'package:myapp/presentations/screens/gamezone.dart';
import 'package:myapp/presentations/screens/rentpage.dart';
import 'package:myapp/presentations/screens/travelcostpage.dart';
import 'presentations/screens/finance.dart' show FinanceScreen;
import 'presentations/screens/home.dart';
import 'presentations/screens/features.dart';
import 'presentations/screens/performancetracking.dart';
import 'presentations/screens/checklist.dart'; 
import 'presentations/screens/graph.dart';
import 'presentations/screens/game.dart';
import 'presentations/screens/financedashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(AthleteManagementApp());
}

class AthleteManagementApp extends StatelessWidget {
  const AthleteManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athlete Management',
      initialRoute: '/',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) => LandingPage(),
        '/home': (context) => HomePage(),
        '/features': (context) => FeaturesScreen(),
        '/performance_tracking': (context) => PerformanceScreen(),
        '/checklist': (context) => ChecklistScreen(),
        '/graph': (context) => AthleteProgressScreen(),
        '/game': (context) => GameZonePage(),
        '/game/decesion':(context)=>GameScreen(),
        '/game/commentary':(context)=>CommentaryGameApp(),
        '/finance': (context) => FinanceScreen(),
        '/anonymousreporting': (context) => AnonymousReportScreen(),
        '/finance/rentpage': (context) => SportsKitPage(),
        '/finance/dashboard': (context) => FinanceDashboard(),
        '/finance/travelcost':(context)=>TravelCostPage(),
        '/finance/scheme':(context)=>AthleteSchemesPage(),
      },
    );

  }
}


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedUserType;
  String _verificationId = '';

  void _login() {
   if (_formKey.currentState!.validate()) {
     FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ).then((userCredential) {
        if (_selectedUserType == "Athlete") {
        Navigator.pushReplacementNamed(context, '/splash');
      } else {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Currently, this user type is not supported'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).catchError((error) {
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect Password or Email'),
            backgroundColor: Colors.red,
          ),
        );
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to AthleteVerse', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body:Container(
        color: Colors.white,
        child:  Padding(
        padding: EdgeInsets.all(20.0),
          child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),

                  // User Type Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select User Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white
                    ),
                    value: _selectedUserType,
                    items: ['Athlete', 'Coach', 'Organization','Sponsors','Admin']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),

                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserType = value;
                      });
                    
                    },
                    validator: (value) => value == null ? 'Please select a user type' : null,
                  ),
                  SizedBox(height: 20),

            SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: _login,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 15),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      textStyle: TextStyle(fontSize: 18),
    ),
    child: Text('Login'),
  ),
),
                ],
              ),
            ),
          ),
        ),
      ),
      )
    );
  }
}
