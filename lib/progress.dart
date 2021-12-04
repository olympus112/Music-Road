import 'package:flutter/material.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/leveldata.dart';

class LevelProgress extends StatelessWidget {
  final double score;
  final LevelScores scores;
  final Color color;
  final EdgeInsets padding;

  const LevelProgress({
    Key? key,
    required this.score,
    required this.scores,
    required this.color,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Globals.medalSize,
      child: Padding(
        padding: padding.copyWith(right: Globals.medalSize / 2 + padding.right),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bronzeOffset = constraints.maxWidth * scores.bronze / scores.gold - Globals.medalSize / 2;
            final silverOffset = constraints.maxWidth * scores.silver / scores.gold - Globals.medalSize / 2;
            final goldOffset = constraints.maxWidth - Globals.medalSize / 2;
            const yOffset = Globals.medalSize * 0.20;
            return Stack(
              children: [
                Transform.translate(
                  offset: const Offset(0, yOffset),
                  child: CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight / 3),
                    painter: LevelProgressPainter(
                      progress: score,
                      outline: Colors.white70,
                      active: color,
                      inactive: color.withOpacity(0.3),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(bronzeOffset, 0),
                  child: Image.asset(
                    Globals.bronzeMedalPath,
                    width: Globals.medalSize,
                    height: Globals.medalSize,
                  ),
                ),
                Transform.translate(
                  offset: Offset(silverOffset, 0),
                  child: Image.asset(
                    Globals.silverMedalPath,
                    width: Globals.medalSize,
                    height: Globals.medalSize,
                  ),
                ),
                Transform.translate(
                  offset: Offset(goldOffset, 0),
                  child: Image.asset(
                    Globals.goldMedalPath,
                    width: Globals.medalSize,
                    height: Globals.medalSize,
                  ),
                ),
                Transform.translate(
                  offset: Offset(constraints.maxWidth * score - 15, -yOffset * 2),
                  child: Text(
                    '${(score * 100).round()}%',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            );
          },
        ),
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
