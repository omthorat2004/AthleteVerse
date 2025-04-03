import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dialogue_box.dart';

class CharacterWidget extends StatelessWidget {
  final String characterName;
  final String animationFile;
  final RiveAnimationController controller;
  final bool isSpeaking;
  final String dialogue;
  final Color bubbleColor;

  const CharacterWidget({super.key, 
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
            SizedBox(
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
        Text(
          characterName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
