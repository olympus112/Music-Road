import 'package:flutter/material.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/leveldata.dart';

class Level extends StatelessWidget {
  final LevelData data;

  const Level({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 4))],
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(data.song.cover),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LevelStars(difficulty: data.difficulty),
                LevelMedal(score: data.analytics.score, scores: data.scores),
              ],
            ),
          ),
          const Expanded(
            flex: 8,
            child: SizedBox(),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.song.title,
                  style: const TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                  ),
                ),
                Text(
                  data.song.artist,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.song.album,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      data.song.time,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LevelStars extends StatelessWidget {
  final LevelDifficulty difficulty;

  const LevelStars({Key? key, required this.difficulty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Globals.fullStarIcon,
          color: Globals.starColor,
        ),
        Icon(
          difficulty != LevelDifficulty.easy ? Globals.fullStarIcon : Globals.emptyStarIcon,
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

class LevelMedal extends StatelessWidget {
  final int score;
  final LevelScores scores;

  const LevelMedal({
    Key? key,
    required this.score,
    required this.scores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (score < scores.bronze)
      // ignore: curly_braces_in_flow_control_structures
      return const Icon(
        Globals.noMedalIcon,
        color: Globals.noMedalColor,
      );
    else if (score < scores.silver)
      return Image.asset(Globals.bronzeMedalPath);
    else if (score < scores.gold)
      return Image.asset(Globals.silverMedalPath);
    else
      return Image.asset(Globals.goldMedalPath);
  }
}
