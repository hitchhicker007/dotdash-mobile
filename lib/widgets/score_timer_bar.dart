import 'package:flutter/material.dart';

class ScoreTimerBar extends StatelessWidget {
  final int score;
  final int secondsLeft;

  const ScoreTimerBar({required this.score, required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Score: $score', style: TextStyle(fontSize: 20)),
          Text('Time: $secondsLeft', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
