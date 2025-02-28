import 'package:flutter/material.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  static String routeName = 'Features';
  static String routePath = '/features';

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen>
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
          backgroundColor: Colors.green,
          title: const Text(
            'Features',
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
                  label: 'Performance Tracking',
                  icon: Icons.track_changes,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pushNamed(context, '/performance_tracking');
                  },
                ),

                _buildFeatureButton(
                  context,
                  label: 'Injury Management',
                  icon: Icons.personal_injury_outlined,
                  color: Colors.red,
                  onTap: () {
                    Navigator.pushNamed(context, '/injury_management');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
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
