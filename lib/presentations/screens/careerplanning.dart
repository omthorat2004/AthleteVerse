import 'package:flutter/material.dart';

class CareerPlanningScreen extends StatefulWidget {
  const CareerPlanningScreen({super.key});

  static String routeName = 'CareerPlanning';
  static String routePath = '/careerplanning';

  @override
  State<CareerPlanningScreen> createState() => _CareerPlanningScreenState();
}

class _CareerPlanningScreenState extends State<CareerPlanningScreen>
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
          backgroundColor: Colors.blue.shade800,
          title: const Text(
            'Career Planning',
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
            padding: const EdgeInsets.all(16.0),
            child: GridView(
              padding: const EdgeInsets.only(top: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              children: [
                _buildFeatureCard(
                  context,
                  label: 'Overview',
                  icon: Icons.info_outline,
                  onTap: () {
                    Navigator.pushNamed(context, '/careerplanning/overview');
                  },
                ),
                _buildFeatureCard(
                  context,
                  label: 'My Career Path',
                  icon: Icons.timeline,
                  onTap: () {
                    Navigator.pushNamed(context, '/careerplanning/path');
                  },
                ),
                _buildFeatureCard(
                  context,
                  label: 'Ranking and Qualification',
                  icon: Icons.leaderboard,
                  onTap: () {
                    Navigator.pushNamed(context, '/careerplanning/ranking');
                  },
                ),
                _buildFeatureCard(
                  context,
                  label: 'Upcoming Tournaments',
                  icon: Icons.event,
                  onTap: () {
                    Navigator.pushNamed(context, '/careerplanning/tournaments');
                  },
                ),
                _buildFeatureCard(
                  context,
                  label: 'Expert Advice',
                  icon: Icons.people_alt,
                  onTap: () {
                    Navigator.pushNamed(context, '/careerplanning/advice');
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

class _AnimatedFeatureCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _AnimatedFeatureCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<_AnimatedFeatureCard> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()
            ..scale(isHovered ? 1.03 : 1.0)
            ..scale(isPressed ? 0.97 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: Colors.blue.shade100,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFeatureCard(
  BuildContext context, {
  required String label,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return _AnimatedFeatureCard(label: label, icon: icon, onTap: onTap);
}