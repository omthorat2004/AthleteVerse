import 'package:flutter/material.dart';

class InjuryScreen extends StatefulWidget {
  const InjuryScreen({super.key});

  static String routeName = 'Injury';
  static String routePath = '/injury';

  @override
  State<InjuryScreen> createState() => _InjuryScreenState();
}

class _InjuryScreenState extends State<InjuryScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text(
            'Injury Management',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView(
              padding: const EdgeInsets.only(top: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 2,
                childAspectRatio: 6,
              ),
              children: [
                _buildFeatureButton(
                  context,
                  label: 'Risk Prediction',
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pushNamed(context, '/risk_prediction');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Return to Play',
                  icon: Icons.sports_soccer,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pushNamed(context, '/return_to_play');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Injury Insights',
                  icon: Icons.insights,
                  color: Colors.red,
                  onTap: () {
                    Navigator.pushNamed(context, '/injury_insights');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Wearable Data',
                  icon: Icons.fitness_center,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(context, '/wearable_data');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Rehab Exercises',
                  icon: Icons.sports_kabaddi,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pushNamed(context, '/injury/rehab_exercises');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Medical Records',
                  icon: Icons.medical_information,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pushNamed(context, '/injury/medical_records');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Recovery Progress',
                  icon: Icons.timeline,
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.pushNamed(context, '/injury/recovery_progress');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 23, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}