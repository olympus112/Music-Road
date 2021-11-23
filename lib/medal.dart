import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/leveldata.dart';

class LevelMedal extends StatefulWidget {
  final int? score;
  final LevelScores? scores;
  final double? size;
  final EdgeInsets padding;
  final bool highscore;

  const LevelMedal({
    Key? key,
    required this.score,
    required this.scores,
    this.size,
    this.padding = EdgeInsets.zero,
    this.highscore = false,
  }) : super(key: key);

  @override
  State<LevelMedal> createState() => LevelMedalState();
}

class LevelMedalState extends State<LevelMedal> with TickerProviderStateMixin {
  late ConfettiController confettiController;
  late AnimationController highscoreController;
  late Animation<double> highscoreOpacity;
  late Animation<double> highscoreScale;

  @override
  void initState() {
    super.initState();
    highscoreController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    highscoreOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: highscoreController, curve: Curves.decelerate));
    highscoreScale = Tween<double>(begin: 10, end: 1).animate(CurvedAnimation(parent: highscoreController, curve: Curves.bounceOut));
    confettiController = ConfettiController()..play();
  }

  @override
  void dispose() {
    highscoreController.dispose();
    confettiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.score == null || widget.scores == null) return const SizedBox.shrink();

    Widget icon = widget.score! < widget.scores!.bronze
        ? Icon(
            Globals.noMedalIcon,
            color: Globals.noMedalColor,
            size: widget.size ?? Globals.medalSize,
          )
        : Image.asset(
            widget.score! < widget.scores!.silver
                ? Globals.bronzeMedalPath
                : widget.score! < widget.scores!.gold
                    ? Globals.silverMedalPath
                    : Globals.goldMedalPath,
            filterQuality: FilterQuality.medium,
            height: widget.size ?? Globals.medalSize,
          );

    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.highscore)
          ConfettiWidget(
            confettiController: ConfettiController()..play(),
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            emissionFrequency: 0.05,
          ),
        Padding(
          padding: widget.padding,
          child: icon,
        ),
        if (widget.highscore)
          Transform.translate(
            offset: const Offset(0, Globals.medalSize + 12),
            child: FadeTransition(
              opacity: highscoreOpacity,
              child: ScaleTransition(
                scale: highscoreScale,
                child: const Text(
                  'Highscore!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
