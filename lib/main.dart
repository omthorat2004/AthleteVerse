import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/presentations/screens/example/multilingualspport.dart';
import 'package:myapp/presentations/screens/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/user_provider.dart';
import 'firebase_options.dart';


import 'presentations/screens/home.dart';
import 'presentations/screens/profileathlete.dart';
import 'presentations/screens/splash.dart';
import 'presentations/screens/features.dart';
import 'presentations/screens/performancetracking.dart';
import 'presentations/screens/checklist.dart';
import 'presentations/screens/wearable_data.dart';
import 'presentations/screens/graph.dart';
import 'presentations/screens/gamezone.dart';
import 'presentations/screens/game.dart';
import 'presentations/screens/finance.dart' show FinanceScreen;
import 'presentations/screens/anonymousreporting.dart';
import 'presentations/screens/financedashboard.dart';
import 'presentations/screens/financescheme.dart';
import 'presentations/screens/rentpage.dart';
import 'presentations/screens/travelcostpage.dart';
import 'presentations/screens/injury.dart';
import 'presentations/screens/rehab_exercises.dart';
import 'presentations/screens/medical_access.dart';
import 'presentations/screens/rehab_progress.dart';
import 'presentations/screens/organizations/organizationhome.dart';
import 'presentations/screens/organizations/scouringdashboard.dart';
import 'presentations/screens/riskprediction.dart';
import 'presentations/screens/webinar_page.dart';
import 'presentations/screens/videoinsight.dart';
import 'presentations/screens/careerplanning.dart';
import 'presentations/screens/careerplaningoverview.dart';
import 'presentations/screens/careerpath.dart';
import 'presentations/screens/rankingqualifications.dart';
import 'presentations/screens/upcomingscreen.dart';
import 'presentations/screens/yoyotest.dart';
import 'presentations/screens/mentorship.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()..initUser(),
          lazy: false,
        ),
      ],
      child: const AthleteManagementApp(),
    ),
  );
}

class AthleteManagementApp extends StatelessWidget {
  const AthleteManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athlete Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => AthleteProfilePage(),
        '/features': (context) => const FeaturesScreen(),
        '/performance_tracking': (context) => const PerformanceScreen(),
        '/checklist': (context) => const ChecklistScreen(),
        '/calorie': (context) => const CalorieTrackerScreen(),
        '/wearable_data': (context) => const WearableDataPage(),
        '/graph': (context) => const AthleteProgressScreen(),
        '/game': (context) => const GameZonePage(),
        '/game/decision': (context) => ModuleSelectionScreen(),
        '/finance': (context) => const FinanceScreen(),
        '/anonymousreporting': (context) => const AnonymousReportScreen(),
        '/finance/rentpage': (context) => const SportsKitPage(),
        '/finance/dashboard': (context) => const FinanceDashboard(),
        '/finance/travelcost': (context) => const TravelCostPage(),
        '/finance/scheme': (context) => const AthleteSchemesPage(),
        '/injury': (context) => const InjuryScreen(),
        '/injury/rehab_exercises': (context) => const RehabExercisesScreen(),
        '/injury/medical_records':
            (context) => const MedicalRecordsAccessScreen(),
        '/injury/recovery_progress': (context) => const RehabProgressPage(),
        '/organization': (context) => const SportOrganizationHomePage(),
        '/organization/scouting': (context) => const ScoutingDashboard(),
        '/injury/risk_prediction':
            (context) => InjuryRiskPredictionPage(athlete: getDefaultAthlete()),
        '/webinars': (context) => const WebinarsPage(),
        '/video_insight': (context) => const AthleteExerciseInsightsPage(),
        '/careerplanning': (context) => const CareerPlanningScreen(),
        '/careerplanning/overview': (context) => const CareerOverviewScreen(),
        '/careerplanning/path': (context) => const MyCareerPathScreen(),
        '/careerplanning/ranking':
            (context) => const RankingQualificationScreen(),
        '/careerplanning/tournaments':
            (context) => const UpcomingTournamentsScreen(),
        '/careerplanning/advice': (context) => const ExpertAdviceScreen(),
        '/yoyo_test': (context) => YoYoTestScreen(cameras: []),
      },
      onUnknownRoute:
          (settings) => MaterialPageRoute(
            builder:
                (context) => Scaffold(
                  appBar: AppBar(title: const Text('Page Not Found')),
                  body: const Center(child: Text('404 - Page not found')),
                ),
          ),
    );
  }

  static AthleteProfile getDefaultAthlete() {
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

  static Widget _buildWebNotSupported() {
    return Scaffold(
      appBar: AppBar(title: const Text('Yo-Yo Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off, size: 64, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'Yo-Yo Test not available on web',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please use the mobile app for this feature',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
