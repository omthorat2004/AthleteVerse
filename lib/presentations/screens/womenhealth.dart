import 'package:flutter/material.dart';

class WomensHealthHub extends StatefulWidget {
  const WomensHealthHub({super.key});

  @override
  State<WomensHealthHub> createState() => _WomensHealthHubState();
}

class _WomensHealthHubState extends State<WomensHealthHub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Women\'s Health Hub'),
        backgroundColor: Colors.pinkAccent, // Changed to feminine color
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
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
                    label: 'Cycle Tracker',
                    icon: Icons.calendar_today,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pushNamed(context, '/cycle_tracker');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    label: 'Hormone Insights',
                    icon: Icons.insights,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(context, '/hormone_insights');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    label: 'Injury Prevention',
                    icon: Icons.health_and_safety,
                    color: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(context, '/injury_prevention');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    label: 'Nutrition Guide',
                  icon: Icons.eco,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pushNamed(context, '/nutrition_guide');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    label: 'Pregnancy Support',
                    icon: Icons.family_restroom,
                    color: Colors.red,
                    onTap: () {
                      Navigator.pushNamed(context, '/pregnancy_support');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    label: 'Mental Wellness',
                    icon: Icons.psychology,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.pushNamed(context, '/mental_wellness');
                    },
                  ),
                ],
              ),
            ),
          ],
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
    return _AnimatedFeatureButton(
      label: label,
      icon: icon,
      color: color,
      onTap: onTap,
    );
  }
}

class _AnimatedFeatureButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedFeatureButton({
    required this.label,
    required this.icon,
    required this.color,
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
            ..scale(isHovered ? 1.05 : 1.0)
            ..scale(isPressed ? 0.95 : 1.0),
          decoration: BoxDecoration(
            color: isHovered ? widget.color.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.color, width: 2),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
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
              Icon(widget.icon, size: 50, color: widget.color),
              const SizedBox(height: 10),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}