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
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2, 
              ),
              children: [
                _buildFeatureButton(
                  context,
                  label: 'Rent In / Rent Out',
                  icon: Icons.house,
                  onTap: () {
                    Navigator.pushNamed(context, '/finance/rentpage');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Financial Dashboard',
                  icon: Icons.dashboard,
                  onTap: () {
                    Navigator.pushNamed(context, '/finance/dashboard');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Trip Cost Estimation',
                  icon: Icons.calculate,
                  onTap: () {
                    Navigator.pushNamed(context, '/finance/travelcost');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Government Scheme',
                  icon: Icons.account_balance,
                  onTap: () {
                    Navigator.pushNamed(context, '/finance/scheme');
                  },
                ),
                _buildFeatureButton(
                  context,
                  label: 'Alerts for Overspending',
                  icon: Icons.warning,
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

class _AnimatedFeatureButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _AnimatedFeatureButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_AnimatedFeatureButton> createState() => _AnimatedFeatureButtonState();
}

class _AnimatedFeatureButtonState extends State<_AnimatedFeatureButton> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true), // Hover effect
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true), // Click effect
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()
            ..scale(isHovered ? 1.05 : 1.0) // Slightly enlarge on hover
            ..scale(isPressed ? 0.95 : 1.0), // Shrink slightly when clicked
          decoration: BoxDecoration(
            color: isHovered ? Colors.blue.shade50 : Colors.white, // Background change on hover
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue, width: 2),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.blue.shade200,
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 50, color: Colors.blue), // Larger Icon
              const SizedBox(height: 10),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
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
  required VoidCallback onTap,
}) {
  return _AnimatedFeatureButton(label: label, icon: icon, onTap: onTap);
}
