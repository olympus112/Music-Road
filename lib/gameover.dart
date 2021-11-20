import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/coins.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/medal.dart';
import 'package:musicroad/progress.dart';
import 'package:musicroad/widgets.dart';

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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        content(context, data),
        Widgets.settings(context, data, () => Widgets.showSettings(context, data)),
        Widgets.coins(context, data),
      ],
    );
  }

  Widget content(BuildContext context, AppDataState data) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Globals.levelSideMargin,
        right: Globals.levelSideMargin,
        top: Globals.levelSideMargin * 2,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: card(context, data),
          ),
          Expanded(
            flex: 3,
            child: buttons(context, data),
          ),
        ],
      ),
    );
  }

  Widget card(BuildContext context, AppDataState data) {
    return Material(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: data.levels[index].colors.accent),
        borderRadius: Globals.borderRadius,
      ),
      child: ClipRRect(
        borderRadius: Globals.borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Widgets.blurredBackground(data.levels[index].song.cover),
            cardContent(context, data),
          ],
        ),
      ),
    );
  }

  Widget buttons(BuildContext context, AppDataState data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Widgets.button(context, data, Icons.menu, data.levels[index].colors.accent, () => Navigator.pop(context)),
        Widgets.button(context, data, Icons.replay, data.levels[index].colors.accent, () {}),
      ],
    );
  }

  Widget cardContent(BuildContext context, AppDataState data) {
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
              padding: const EdgeInsets.all(16),
              highscore: score > data.levels[index].statistics!.score,
            ),
            const SizedBox(height: 16),
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
