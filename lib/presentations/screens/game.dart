import 'package:flutter/material.dart';
import '../components/games/module_card.dart';
import '../models/game_module.dart';
import 'decesion_game_screen.dart';

class ModuleSelectionScreen extends StatelessWidget {
  final List<GameModule> modules = [
    GameModule(
      name: "Contract Clarity",
      description:
          "Help Priya navigate tricky contract clauses and make the right decisions.",
      points: 0,
    ),
    GameModule(
      name: "Doping Awareness",
      description: "Learn how to handle doping allegations responsibly.",
      points: 0,
    ),
  ];

   ModuleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Game Modules", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select a Module to Play:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  return ModuleCard(
                    module: modules[index],
                    onStart: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => GameScreen(
                                moduleName: modules[index].name,
                                totalPoints: modules[index].points,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
