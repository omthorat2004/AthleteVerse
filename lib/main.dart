import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/presentations/screens/anonymousreporting.dart';
import 'package:myapp/presentations/screens/caloriecount.dart';
import 'package:myapp/presentations/screens/medical_access.dart';
import 'package:myapp/presentations/screens/organizations/organizationhome.dart';
import 'package:myapp/presentations/screens/organizations/scouringdashboard.dart';
import 'package:myapp/presentations/screens/rehab_exercises.dart';
import 'package:myapp/presentations/screens/rehab_progress.dart';
import 'package:myapp/presentations/screens/riskprediction.dart';
import 'package:myapp/presentations/screens/splash.dart';
import 'package:myapp/presentations/screens/financescheme.dart';
import 'package:myapp/presentations/screens/gamezone.dart';
import 'package:myapp/presentations/screens/rentpage.dart';
import 'package:myapp/presentations/screens/travelcostpage.dart';
import 'package:myapp/presentations/screens/wearable_data.dart';
import 'package:myapp/presentations/screens/webinar_page.dart';
import 'package:myapp/presentations/screens/yoyotest.dart';
import 'presentations/screens/careerpath.dart';
import 'presentations/screens/careerplaningoverview.dart';
import 'presentations/screens/careerplanning.dart';
import 'presentations/screens/finance.dart' show FinanceScreen;
import 'presentations/screens/game.dart';
import 'presentations/screens/home.dart';
import 'presentations/screens/features.dart';
import 'presentations/screens/mentorship.dart';
import 'presentations/screens/performancetracking.dart';
import 'presentations/screens/checklist.dart';
import 'presentations/screens/graph.dart';
import 'presentations/screens/financedashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentations/screens/injury.dart';
import 'presentations/screens/rankingqualifications.dart';
import 'presentations/screens/upcomingscreen.dart';
import 'presentations/screens/videoinsight.dart';

// Add this right after your imports
AthleteProfile getDefaultAthlete() {
  return AthleteProfile(
    name: "Aman Singh",
    photoUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5",
    sport: "Football",
    position: "Forward",
    lastAssessment: "2024-11-15",
    riskScore: 68,
    highRiskAreas: [
      BodyAreaRisk(
        area: "Right Hamstring",
        risk: 72,
        details: "2.5x higher load than left side in last 3 sessions",
        xPosition: 100,
        yPosition: 180,
      ),
      BodyAreaRisk(
        area: "Left Ankle",
        risk: 45,
        details: "Reduced dorsiflexion from previous injury",
        xPosition: 60,
        yPosition: 220,
      ),
    ],
    fatigueLevel: 78,
    muscleImbalance: 22,
    movementQuality: 6.5,
    workloadRatio: 1.4,
    topInjuryRisks: [
      InjuryRisk(
        type: "Hamstring Strain",
        risk: 72,
        description: "High sprint volume with imbalance detected",
      ),
      InjuryRisk(
        type: "Ankle Sprain",
        risk: 45,
        description: "Previous injury + reduced mobility",
      ),
    ],
    riskHistory: [
      RiskData(date: "Sep", value: 42),
      RiskData(date: "Oct", value: 55),
      RiskData(date: "Nov", value: 68),
    ],
    trainingModifications: [
      "Reduce sprint volume by 20% this week",
      "Add 2 yoga sessions for mobility",
    ],
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
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
        '/calorie': (context) => CalorieTrackerScreen(),
        '/wearable_data': (context) => WearableDataPage(),
        '/graph': (context) => AthleteProgressScreen(),
        '/game': (context) => GameZonePage(),
        '/game/decesion': (context) => ModuleSelectionScreen(),
        '/finance': (context) => FinanceScreen(),
        '/anonymousreporting': (context) => AnonymousReportScreen(),
        '/finance/rentpage': (context) => SportsKitPage(),
        '/finance/dashboard': (context) => FinanceDashboard(),
        '/finance/travelcost': (context) => TravelCostPage(),
        '/finance/scheme': (context) => AthleteSchemesPage(),
        '/injury': (context) => InjuryScreen(),
        '/injury/rehab_exercises': (context) => RehabExercisesScreen(),
        '/injury/medical_records': (context) => MedicalRecordsAccessScreen(),
        '/injury/recovery_progress': (context) => RehabProgressPage(),
        '/organization': (context) => SportOrganizationHomePage(),
        '/organization/scouting': (context) => ScoutingDashboard(),
        '/injury/risk_prediction': (context) => InjuryRiskPredictionPage(athlete: getDefaultAthlete()),
        '/webinars': (context) => WebinarsPage(),
        '/video_insight': (context) => AthleteExerciseInsightsPage(),
        '/careerplanning': (context) => CareerPlanningScreen(),
        '/careerplanning/overview': (context) => CareerOverviewScreen(),
        '/careerplanning/path': (context) => MyCareerPathScreen(),
        '/careerplanning/ranking': (context) => RankingQualificationScreen(),
        '/careerplanning/tournaments': (context) => UpcomingTournamentsScreen(),
        '/careerplanning/advice': (context) => ExpertAdviceScreen(),
        '/yoyo_test': (context) => YoYoTestScreen(cameras: [],)
      },
    );
  }

  static Widget _buildWebNotSupported() {
    return Scaffold(
      appBar: AppBar(title: Text('Yo-Yo Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 64, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Yo-Yo Test not available on web',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Please use the mobile app for this feature',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
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
  final String _verificationId = '';

  void _login() {
    if (_formKey.currentState!.validate()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          )
          .then((userCredential) {
            if (_selectedUserType == "Athlete") {
              Navigator.pushReplacementNamed(context, '/splash');
            } else if (_selectedUserType == 'Organization') {
              Navigator.pushReplacementNamed(context, '/organization');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Currently, this user type is not supported'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          })
          .catchError((error) {
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
        title: Text(
          'Login to AthleteVerse',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
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
                        if (!RegExp(
                          r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
                        ).hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

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

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select User Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _selectedUserType,
                      items: ['Athlete', 'Coach', 'Organization', 'Sponsors', 'Admin']
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
      ),
    );
  }
}