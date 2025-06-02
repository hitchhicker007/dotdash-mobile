import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quicktap_duel/screens/game_over_screen.dart';
import '../constants/game_constants.dart';
import '../models/circle_dot.dart';
import '../utils/random_utils.dart';
import '../widgets/circle_dot_widget.dart';
import '../widgets/score_timer_bar.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

final audioPlayer = AudioPlayer();

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<CircleDot> activeDots = [];
  int score = 0;
  late Timer gameTimer;
  late Timer spawnTimer;
  int secondsLeft = gameDurationSeconds;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      score = 0;
      activeDots.clear();
      secondsLeft = gameDurationSeconds;
      isRunning = true;
    });

    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsLeft--;
      });

      if (secondsLeft <= 0) {
        endGame();
      }
    });

    spawnTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (activeDots.length < maxDots) {
        final newDot = CircleDot(
          id: UniqueKey().toString(),

          position: generateNonOverlappingOffset(
            MediaQuery.of(context).size,
            activeDots,
          ),

          points: getRandomPoints(),
        );

        setState(() {
          activeDots.add(newDot);
        });

        double progress = 1 - (secondsLeft / gameDurationSeconds); // 0.0 → 1.0
        int lifetimeMs = (3000 - (2000 * progress)).clamp(1000, 3000).toInt();

        Future.delayed(Duration(milliseconds: lifetimeMs), () {
          if (mounted) {
            setState(() {
              activeDots.removeWhere((dot) => dot.id == newDot.id);
            });
          }
        });

      }
    });
  }

  void endGame() {
    gameTimer.cancel();
    spawnTimer.cancel();
    setState(() => isRunning = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          score: score,
        ),
      ),
    );
  }


  void onDotTapped(CircleDot dot) async {
    await audioPlayer.play(AssetSource('sounds/tap-sound.mp3'));
    if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(duration: 100);
    }

    setState(() {
      score += dot.points;
      activeDots.removeWhere((d) => d.id == dot.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                ScoreTimerBar(score: score, secondsLeft: secondsLeft),
                Expanded(
                  child: Stack(
                    children: activeDots.map((dot) {
                      return CircleDotWidget(
                        dot: dot,
                        onTap: () => onDotTapped(dot),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            if (!isRunning)
              Center(
                child: ElevatedButton(
                  onPressed: startGame,
                  child: Text("Start Game"),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (isRunning) {
      gameTimer.cancel();
      spawnTimer.cancel();
    }
    super.dispose();
  }
}
