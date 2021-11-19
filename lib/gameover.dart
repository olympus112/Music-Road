import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/coins.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/level.dart';
import 'package:musicroad/leveldata.dart';
import 'package:musicroad/settings.dart';

class GameOverDialog extends StatelessWidget {
  late final int index;

  final AppDataState data;
  final String level;
  final String title;
  final int score;
  final int coins;
  final double percentage;

  GameOverDialog({
    Key? key,
    required this.data,
    required this.level,
    required this.title,
    required this.score,
    required this.coins,
    required this.percentage,
  }) : super(key: key) {
    index = data.levels.indexWhere((element) => element.song.title == level);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Globals.levelSideMargin, right: Globals.levelSideMargin, top: Globals.levelSideMargin),
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: card(context, data),
          ),
          Expanded(
            flex: 2,
            child: buttons(context, data),
          ),
        ],
      ),
    );
  }

  Widget card(BuildContext context, AppDataState data) {
    return Material(
      elevation: 4,
      color: Colors.black26,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: data.levels[index].colors.accent),
        borderRadius: Globals.borderRadius,
      ),
      child: ClipRRect(
        borderRadius: Globals.borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            background(context, data),
            content(context, data),
          ],
        ),
      ),
    );
  }

  Widget buttons(BuildContext context, AppDataState data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        button(context, data, Icons.settings, () {
          showDialog(
            context: context,
            barrierColor: Colors.black87,
            builder: (context) {
              return SettingsDialog(data: data);
            },
          );
        }),
        button(context, data, Icons.menu, () {
          Navigator.pop(context);
        }),
        button(context, data, Icons.replay, () {}),
      ],
    );
  }

  Widget button(BuildContext context, AppDataState data, IconData icon, VoidCallback onPressed) {
    return SizedBox.square(
      dimension: 60,
      child: RawMaterialButton(
        shape: CircleBorder(
          side: BorderSide(color: data.levels[index].colors.accent),
        ),
        child: Icon(
          icon,
          color: Colors.white70,
          size: 35,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget background(BuildContext context, AppDataState data) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(data.levels[index].song.cover),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget medal(BuildContext context, AppDataState data) {
    return Positioned(
      left: Globals.levelContentPadding,
      right: Globals.levelContentPadding,
      top: Globals.levelContentPadding,
      child: LevelMedal(
        score: data.levels[index].statistics?.score,
        scores: data.levels[index].scores,
      ),
    );
  }

  Widget content(BuildContext context, AppDataState data) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(Globals.levelContentPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 40,
                color: data.levels[index].colors.text,
              ),
            ),
            Divider(
              color: data.colors.text,
              thickness: 1,
            ),
            LevelMedal(
              size: 80,
              score: score,
              scores: data.levels[index].scores,
              padding: const EdgeInsets.all(32),
            ),
            Text(
              '${(percentage * 100).round()}%',
              style: TextStyle(
                fontSize: 45,
                color: data.levels[index].colors.text,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Score: $score',
              style: TextStyle(
                fontSize: 45,
                color: data.levels[index].colors.text,
              ),
            ),
            Coins(
              coins: coins,
              padding: const EdgeInsets.all(32),
            ),
            LevelProgress(
              score: score,
              scores: data.levels[index].scores!,
              color: data.levels[index].colors.accent,
            ),
          ],
        ),
      ),
    );
  }
}

class LevelProgress extends StatelessWidget {
  final int score;
  final LevelScores scores;
  final Color color;

  const LevelProgress({
    Key? key,
    required this.score,
    required this.scores,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = (score / scores.gold).clamp(0.0, 1.0);
    const paddingFraction = 0.5;
    return Padding(
      padding: const EdgeInsets.only(left: Globals.medalSize / 2 * paddingFraction, right: Globals.medalSize * paddingFraction),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bronzeOffset = constraints.maxWidth * scores.bronze / scores.gold - Globals.medalSize / 2;
          final silverOffset = constraints.maxWidth * scores.silver / scores.gold - Globals.medalSize / 2;
          final goldOffset = constraints.maxWidth - Globals.medalSize / 2;
          const yOffset = -Globals.medalSize * 0.20;
          return Stack(
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, 15),
                painter: LevelProgressPainter(
                  progress: progress,
                  outline: Colors.white70,
                  active: color,
                  inactive: color.withOpacity(0.3),
                ),
              ),
              Transform.translate(
                offset: Offset(bronzeOffset, yOffset),
                child: Image.asset(
                  Globals.bronzeMedalPath,
                  width: Globals.medalSize,
                  height: Globals.medalSize,
                ),
              ),
              Transform.translate(
                offset: Offset(silverOffset, yOffset),
                child: Image.asset(
                  Globals.silverMedalPath,
                  width: Globals.medalSize,
                  height: Globals.medalSize,
                ),
              ),
              Transform.translate(
                offset: Offset(goldOffset, yOffset),
                child: Image.asset(
                  Globals.goldMedalPath,
                  width: Globals.medalSize,
                  height: Globals.medalSize,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LevelProgressPainter extends CustomPainter {
  final double progress;
  final Color outline;
  final Color active;
  final Color inactive;

  const LevelProgressPainter({
    required this.progress,
    required this.outline,
    required this.active,
    required this.inactive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RRect outerRect = RRect.fromRectXY(Offset.zero & size, 25, 25);

    canvas.saveLayer(outerRect.outerRect, Paint());
    canvas.clipRRect(outerRect);

    final RRect innerRect = outerRect.deflate(1);
    final RRect progressRect = RRect.fromLTRBXY(innerRect.left, innerRect.top, innerRect.right * progress, innerRect.bottom, 25, 25);
    canvas.drawRRect(innerRect, Paint()..color = inactive);
    canvas.drawRRect(progressRect, Paint()..color = active);
    canvas.drawDRRect(outerRect, innerRect, Paint()..color = outline);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
