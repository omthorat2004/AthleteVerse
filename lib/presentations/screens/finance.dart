import 'package:flutter/material.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  static String routeName = 'Finance';
  static String routePath = '/finance';

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen>
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
            'Finance',
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
                  label: 'Rent In / Rent Out',
                  icon: Icons.house,
                  color: Colors.blueAccent,
                  onTap: () {
                    Navigator.pushNamed(context, '/rent');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Financial Dashboard',
                  icon: Icons.dashboard,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pushNamed(context, '/financial_dashboard');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Trip Cost Estimation',
                  icon: Icons.calculate,
                  color: Colors.deepPurple,
                  onTap: () {
                    Navigator.pushNamed(context, '/trip_cost');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Government Scheme',
                  icon: Icons.account_balance,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pushNamed(context, '/govt_scheme');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Alerts for Overspending',
                  icon: Icons.warning,
                  color: Colors.red,
                  onTap: () {
                    Navigator.pushNamed(context, '/overspending_alerts');
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
