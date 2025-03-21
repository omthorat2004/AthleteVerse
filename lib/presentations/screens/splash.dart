import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  

  final List<IconData> _icons = [
    Icons.bar_chart, 
    Icons.account_balance_wallet, 
    Icons.work_outline, 
    Icons.healing, 
  ];
  
  int _currentIconIndex = 0;
  Timer? _iconTimer;

  @override
  void initState() {
    super.initState();

   
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    _iconTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _currentIconIndex = (_currentIconIndex + 1) % _icons.length;
      });
    });


    Timer(Duration(seconds: 3), () {
      _iconTimer?.cancel();
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Icon(
                _icons[_currentIconIndex], 
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  'AthleteVerse',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    shadows: [
                      Shadow(
                        color: Colors.blueAccent,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
