import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/progress.dart';
import 'package:musicroad/widgets.dart';

class PauzeDialog extends StatelessWidget {
  final int index;

  final String level;
  final double percentage;
  final int score;
  final VoidCallback onResume;
  final VoidCallback onMenu;
  final VoidCallback onReplay;

  const PauzeDialog({
    Key? key,
    required this.index,
    required this.level,
    required this.percentage,
    required this.score,
    required this.onReplay,
    required this.onResume,
    required this.onMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        content(context),
        Widgets.settings(context, index),
        Widgets.coins(),
      ],
    );
  }

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Globals.levelSideMargin,
        right: Globals.levelSideMargin,
        top: Globals.levelSideMargin * 2,
      ),
      child: Column(
        children: [
          Expanded(flex: 8, child: card()),
          Expanded(flex: 3, child: buttons(context)),
        ],
      ),
    );
  }

  Widget card() {
    return Material(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppData.levelData[index].colors.accent),
        borderRadius: Globals.borderRadius,
      ),
      child: ClipRRect(
        borderRadius: Globals.borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Widgets.blurredBackground(index),
            cardContent(),
          ],
        ),
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Widgets.button(Icons.replay, AppData.levelData[index].colors.accent, onReplay),
        Widgets.button(Icons.menu, AppData.levelData[index].colors.accent, onMenu),
        Widgets.button(Icons.play_arrow, AppData.levelData[index].colors.accent, onResume),
      ],
    );
  }

  Widget cardContent() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(Globals.levelContentPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Pauze',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: AppData.levelData[index].colors.text,
              ),
            ),
            Divider(
              color: AppData.levelData[index].colors.text,
              thickness: 1,
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Score: $score',
                  style: TextStyle(
                    fontSize: 45,
                    color: AppData.levelData[index].colors.text,
                  ),
                ),
              ),
            ),
            LevelProgress(
              score: score,
              scores: AppData.levelData[index].scores!,
              color: AppData.levelData[index].colors.accent,
            ),
          ],
        ),
      ),
    );
  }
}
