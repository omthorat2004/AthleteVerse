
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  static String routeName = 'Performance';
  static String routePath = '/performance';

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen>
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
            'Performance',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
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
                  label: 'CheckList',
                  icon: Icons.check_box,  
                  color: Colors.green,
                  onTap: (){
                    Navigator.pushNamed(context, '/checklist');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Graph',
                  icon: Icons.check_box,  
                  color: Colors.blueAccent,
                  onTap: (){
                    Navigator.pushNamed(context, '/graph');
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
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
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    ),
  );
}
