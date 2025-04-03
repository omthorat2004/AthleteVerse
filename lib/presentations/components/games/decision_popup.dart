import 'package:flutter/material.dart';

class DecisionPopup {
  static void show({
    required BuildContext context,
    required String title,
    required List<String> options,
    required Function(String) onDecision,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...options.map((option) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => onDecision(option),
                  child: Text(option),
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}