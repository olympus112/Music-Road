import 'package:flutter/material.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/leveldata.dart';

class LevelStars extends StatelessWidget {
  final LevelDifficulty? difficulty;

  const LevelStars({Key? key, required this.difficulty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (difficulty == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          difficulty != LevelDifficulty.none ? Globals.fullStarIcon : Globals.emptyStarIcon,
          color: Globals.starColor,
        ),
        Icon(
          difficulty == LevelDifficulty.medium || difficulty == LevelDifficulty.hard ? Globals.fullStarIcon : Globals.emptyStarIcon,
          color: Globals.starColor,
        ),
        Icon(
          difficulty == LevelDifficulty.hard ? Globals.fullStarIcon : Globals.emptyStarIcon,
          color: Globals.starColor,
        ),
      ],
    );
  }
}
