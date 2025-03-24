import 'package:flutter/material.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Tracking'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                    label: 'Checklist',
                    icon: Icons.checklist,
                    onTap: () {
                      // Navigate to Checklist screen
                      Navigator.pushNamed(context, '/checklist');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    label: 'Graph',
                    icon: Icons.analytics,
                    onTap: () {
                      // Navigate to Graph screen
                      Navigator.pushNamed(context, '/graph');
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    label: 'Calorie Calculator',
                    icon: Icons.calculate,
                    onTap: () {
                      // Navigate to Calorie Calculator screen
                      Navigator.pushNamed(context, '/calorie');
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
    required VoidCallback onTap,
  }) {
    return _AnimatedFeatureButton(label: label, icon: icon, onTap: onTap);
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
              Icon(widget.icon, size: 50, color: Colors.blue), // Large Icon
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