import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late RiveAnimationController _priyaController;
  late RiveAnimationController _vikramController;
  int _dialogueIndex = 0;
  String currentDialogue = "";
  bool isPriyaSpeaking = false;

  final List<Map<String, dynamic>> dialogueScript = [
    {"text": "Vikram: Understand everything?", "isPriya": false, "animation": "talking"},
    {"text": "Priya: Confused by clauses. Exclusive rights, performance terms...", "isPriya": true, "animation": "thinking"},
    {"text": "Vikram: Tricky. Imagine: ranking drops, sponsorship ends, exclusive rights for 3 years.", "isPriya": false, "animation": "talking"},
    {"pause": true}, // Decision Point
  ];

  @override
  void initState() {
    super.initState();
    _priyaController = SimpleAnimation('idle');
    _vikramController = SimpleAnimation('idle');
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
        } else {
          _vikramController = SimpleAnimation(dialogueScript[_dialogueIndex]["animation"]);
        }
        _dialogueIndex++;
      });
    }
  }

  void showDecisionPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental closing
      builder: (context) => AlertDialog(
        title: Text("What should Priya do?", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => handleDecision("A"),
              child: Text("A: Sign now."),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => handleDecision("B"),
              child: Text("B: Get legal advice."),
            ),
          ],
        ),
      ),
    );
  }

  void handleDecision(String decision) {
    Navigator.pop(context); // Close the popup

    setState(() {
      if (decision == "A") {
        currentDialogue = "Vikram (Voiceover): Didn't understand terms.";
        _priyaController = SimpleAnimation('sad');
      } else {
        currentDialogue = "Vikram (Voiceover): Smart move, protected yourself.";
        _priyaController = SimpleAnimation('happy');
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        currentDialogue = "Vikram: Don't rush deals, understand them.";
        isPriyaSpeaking = false;
        _vikramController = SimpleAnimation('talking');
      });

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          currentDialogue = "Priya: Got it, legal advice first.";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CharacterWidget(
                  characterName: "Priya",
                  animationFile: "assets/priya.riv",
                  controller: _priyaController,
                  isSpeaking: isPriyaSpeaking,
                  dialogue: currentDialogue,
                  bubbleColor: Colors.pinkAccent,
                ),
                CharacterWidget(
                  characterName: "Vikram",
                  animationFile: "assets/vikram.riv",
                  controller: _vikramController,
                  isSpeaking: !isPriyaSpeaking,
                  dialogue: currentDialogue,
                  bubbleColor: Colors.blueAccent,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: showNextDialogue,
            child: Text("Next", style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CharacterWidget extends StatelessWidget {
  final String characterName;
  final String animationFile;
  final RiveAnimationController controller;
  final bool isSpeaking;
  final String dialogue;
  final Color bubbleColor;

  CharacterWidget({
    required this.characterName,
    required this.animationFile,
    required this.controller,
    required this.isSpeaking,
    required this.dialogue,
    required this.bubbleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                animationFile,
                controllers: [controller],
              ),
            ),
            if (isSpeaking)
              Positioned(
                top: -10,
                left: 10,
                right: 10,
                child: DialogueBox(dialogue, bubbleColor),
              ),
          ],
        ),
        SizedBox(height: 10),
        Text(characterName, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class DialogueBox extends StatelessWidget {
  final String text;
  final Color color;

  DialogueBox(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        constraints: BoxConstraints(maxWidth: 200),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1)],
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
