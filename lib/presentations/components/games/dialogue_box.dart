import 'package:flutter/material.dart';

class DialogueBox extends StatelessWidget {
  final String text;
  final Color color;

  const DialogueBox(this.text, this.color, {super.key});

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