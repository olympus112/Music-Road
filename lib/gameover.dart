import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/coins.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/medal.dart';
import 'package:musicroad/progress.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/widgets.dart';

class GameOverDialog extends StatelessWidget {
  final int index;
  final String title;
  final int score;
  final int coins;
  final double percentage;
  final VoidCallback onMenu;
  final VoidCallback onReplay;

  const GameOverDialog({
    Key? key,
    required this.index,
    required this.title,
    required this.score,
    required this.coins,
    required this.percentage,
    required this.onMenu,
    required this.onReplay,
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
        Widgets.button(Icons.menu, AppData.levelData[index].colors.accent, onMenu),
        Widgets.button(Icons.replay, AppData.levelData[index].colors.accent, onReplay),
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
              title,
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
            ValueListenableBuilder(
              valueListenable: Hive.box<UserLevelData>(Globals.levels).listenable(),
              builder: (context, Box<UserLevelData> box, child) {
                return LevelMedal(
                  size: 80,
                  score: score,
                  scores: AppData.levelData[index].percentages,
                  padding: const EdgeInsets.all(16),
                  highscore: score > (box.getAt(index)?.score ?? double.infinity),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Score: $score',
              style: TextStyle(
                fontSize: 45,
                color: AppData.levelData[index].colors.text,
              ),
            ),
            Coins(
              coins: coins,
              padding: const EdgeInsets.all(16),
            ),
            LevelProgress(
              score: percentage,
              scores: AppData.levelData[index].percentages!,
              color: AppData.levelData[index].colors.accent,
            ),
          ],
        ),
      ),
    );
  }
}
