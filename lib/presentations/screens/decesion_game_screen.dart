import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../components/games/character_widget.dart';
import '../components/games/decision_popup.dart';
import 'decesion_start_screen.dart';

class GameScreen extends StatefulWidget {
  final String moduleName;
  final int totalPoints;

  const GameScreen({
    required this.moduleName,
    required this.totalPoints,
    super.key,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late RiveAnimationController _priyaController;
  late RiveAnimationController _vikramController;
  int _dialogueIndex = 0;
  String currentDialogue = "";
  bool isPriyaSpeaking = false;
  int totalPoints = 0;
  bool showNext = false;
  bool isGameStarted = false;

  List<Map<String, dynamic>> dialogueScript = [];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    if (widget.moduleName == "Contract Clarity") {
      dialogueScript = [
        {"text": "Vikram: Understand everything in the contract?", "isPriya": false, "animation": "talking"},
        {"text": "Priya: I'm confused about the exclusivity clause...", "isPriya": true, "animation": "thinking"},
        {"text": "Vikram: If your ranking drops, sponsors can terminate with 3 years exclusivity.", "isPriya": false, "animation": "talking"},
        {"pause": true},
      ];
    } else {
      dialogueScript = [
        {"text": "Vikram: Urgent - your drug test came back positive.", "isPriya": false, "animation": "talking"},
        {"text": "Priya: That's impossible! I'm completely clean!", "isPriya": true, "animation": "shocked"},
        {"text": "Vikram: Traces of stanozolol were found. Any new supplements?", "isPriya": false, "animation": "talking"},
        {"text": "Priya: Just the protein powder from that new sponsor...", "isPriya": true, "animation": "thinking"},
        {"pause": true},
      ];
    }
    resetGame();
  }

  void resetGame() {
    setState(() {
      _priyaController = SimpleAnimation('idle');
      _vikramController = SimpleAnimation('idle');
      _dialogueIndex = 0;
      currentDialogue = "";
      isPriyaSpeaking = false;
      totalPoints = widget.totalPoints;
      showNext = false;
      isGameStarted = false;
    });
  }

  void startGame() {
    setState(() {
      isGameStarted = true;
    });
    showNextDialogue();
  }

  void showNextDialogue() {
    if (_dialogueIndex < dialogueScript.length) {
      if (dialogueScript[_dialogueIndex].containsKey("pause")) {
        showDecisionPopup();
        return;
      }

      setState(() {
        currentDialogue = dialogueScript[_dialogueIndex]["text"];
        isPriyaSpeaking = dialogueScript[_dialogueIndex]["isPriya"];
        if (isPriyaSpeaking) {
          _priyaController = SimpleAnimation(dialogueScript[_dialogueIndex]["animation"]);
          _vikramController.isActive = false;
        } else {
          _vikramController = SimpleAnimation(dialogueScript[_dialogueIndex]["animation"]);
          _priyaController.isActive = false;
        }
        _dialogueIndex++;
      });
    } else {
      _showGameEnd();
    }
  }

  void showDecisionPopup() {
    final options = widget.moduleName == "Contract Clarity"
        ? ["Sign immediately", "Consult a sports lawyer"]
        : ["Publicly deny", "Request B-sample test"];

    DecisionPopup.show(
      context: context,
      title: "What should Priya do?",
      options: options,
      onDecision: (choice) => handleDecision(choice == options[1], context),
    );
  }

  void handleDecision(bool isCorrectChoice, BuildContext context) {
    int decisionTime = DateTime.now().millisecondsSinceEpoch;
    int speedPoints = decisionTime < 5000 ? 5 : 0;
    int pointsEarned = isCorrectChoice ? 15 : 5;

    setState(() {
      totalPoints += pointsEarned + (isCorrectChoice ? speedPoints : 0);
      _priyaController = SimpleAnimation(isCorrectChoice ? 'happy' : 'sad');
    });

    Navigator.pop(context);
    showResultPopup(isCorrectChoice, pointsEarned, speedPoints);
  }

  void showResultPopup(bool isCorrect, int basePoints, int speedPoints) {
    final resultMessage = widget.moduleName == "Contract Clarity"
        ? isCorrect
            ? "✅ Smart! Legal review prevents future problems."
            : "❌ Risky! Blind signing can trap you in bad contracts."
        : isCorrect
            ? "✅ Correct! Following procedure maintains integrity."
            : "❌ Dangerous! Public denials without evidence backfire.";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? "Good Decision!" : "Needs Improvement"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(resultMessage),
              const SizedBox(height: 10),
              Text("Base Points: +$basePoints", style: const TextStyle(color: Colors.blue)),
              if (isCorrect && speedPoints > 0)
                Text("Speed Bonus: +$speedPoints", style: const TextStyle(color: Colors.orange)),
              const SizedBox(height: 10),
              Text("Total: ${basePoints + (isCorrect ? speedPoints : 0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isCorrect) {
                  showNextDialogue();
                } else {
                  resetGame();
                }
              },
              child: Text(isCorrect ? "Continue" : "Try Again"),
            ),
          ],
        );
      },
    );
  }

  void _showGameEnd() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Module Complete!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("You've successfully completed the scenario."),
              const SizedBox(height: 20),
              Text("Total Points Earned: $totalPoints",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Finish"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.moduleName),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("$totalPoints pts",
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
      body: isGameStarted
          ? Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CharacterWidget(
                        characterName: "Priya",
                        animationFile: "priya.riv",
                        controller: _priyaController,
                        isSpeaking: isPriyaSpeaking,
                        dialogue: currentDialogue,
                        bubbleColor: Colors.pink[300]!,
                      ),
                      CharacterWidget(
                        characterName: "Vikram",
                        animationFile: "vikram.riv",
                        controller: _vikramController,
                        isSpeaking: !isPriyaSpeaking,
                        dialogue: currentDialogue,
                        bubbleColor: Colors.blue[300]!,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: showNextDialogue,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text("Continue"),
                  ),
                ),
              ],
            )
          : StartScreen(
              moduleName: widget.moduleName,
              totalPoints: totalPoints,
              onStartPressed: startGame,
            ),
    );
  }
}