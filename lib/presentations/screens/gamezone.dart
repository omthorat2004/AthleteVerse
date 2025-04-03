import 'package:flutter/material.dart';

class GameZonePage extends StatefulWidget {
  const GameZonePage({super.key});

  @override
  State<GameZonePage> createState() => _GameZonePageState();
}

class _GameZonePageState extends State<GameZonePage> {
  
  final List<bool> _isHovered = [false, false, false];

  final List<GameItem> _games = [
    GameItem(
      icon: Icons.mic,
      title: 'COMMENTARY CHALLENGE',
      description: 'Test your sports knowledge!',
      route: '/game/commentary',
    ),
    GameItem(
      icon: Icons.rule,
      title: 'IN',
      description: 'Make split-second calls!',
      route: '/game/decesion',
    ),
    GameItem(
      icon: Icons.search,
      title: 'FIND IT OUT',
      description: 'Hidden object adventure!',
      route: '/find_out_game',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'ARCADE',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0527),
              Color(0xFF1A0933),
              Colors.black,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'CHOOSE YOUR GAME',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // Game cards using implicit animations
              Expanded(
                child: ListView.builder(
                  itemCount: _games.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _GameCard(
                        game: _games[index],
                        isHovered: _isHovered[index],
                        onHover: (hovering) {
                          setState(() {
                            _isHovered[index] = hovering;
                          });
                        },
                        onTap: () => _navigateToGame(context, _games[index].route),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGame(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}

class _GameCard extends StatelessWidget {
  final GameItem game;
  final bool isHovered;
  final Function(bool) onHover;
  final VoidCallback onTap;

  const _GameCard({
    required this.game,
    required this.isHovered,
    required this.onHover,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()
            ..scale(isHovered ? 1.03 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue.shade800.withOpacity(0.7),
            boxShadow: [
              BoxShadow(
                color: isHovered 
                  ? Colors.yellow.withOpacity(0.3)
                  : Colors.black.withOpacity(0.5),
                blurRadius: isHovered ? 10 : 5,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: isHovered ? Colors.yellow : Colors.blue.shade400,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.yellow,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    game.icon,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        game.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isHovered ? Colors.yellow : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.yellow,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'PLAY',
                    style: TextStyle(
                      color: isHovered ? Colors.black : Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameItem {
  final IconData icon;
  final String title;
  final String description;
  final String route;

  const GameItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
  });
}