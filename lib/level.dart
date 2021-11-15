import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/leveldata.dart';
import 'package:musicroad/utils.dart';
import 'package:transformer_page_view/parallax.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class Level extends StatelessWidget {
  final TransformInfo info;

  const Level({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = AppData.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Material(
        elevation: 4,
        color: Colors.black26,
        borderRadius: BorderRadius.circular(25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            fit: StackFit.expand,
            children: [
              background(context, data),
              filter(context, data),
              content(context, data),
              tapToShow(context, data),
            ],
          ),
        ),
      ),
    );
  }

  Widget tapToShow(BuildContext context, AppDataState data) {
    return Positioned(
      bottom: 5,
      width: Utils.width(context) - 100,
      child: Text(
        data.currentIndex != 0 ? 'Tap to show\nstatistics' : '',
        textAlign: TextAlign.center,
        style: TextStyle(color: data.colors.text.withOpacity(0.6)),
      ),
    );
  }

  Widget background(BuildContext context, AppDataState data) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          data.levels[info.index].song.cover,
          fit: BoxFit.cover,
          alignment: FractionalOffset(
            0.5 + info.position,
            0.5,
          ),
        ),
        if (data.song.icon != null)
          Icon(
            data.song.icon,
            color: Colors.white70,
            size: 100,
          ),
        if (!data.analytics.unlocked)
          const Icon(
            Icons.lock,
            color: Colors.white70,
            size: 100,
          ),
      ],
    );
  }

  Widget filter(BuildContext context, AppDataState data) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0x00ffffff),
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            Color(0xFF000000),
            Color(0x00ffffff),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context, AppDataState data) {
    return Positioned(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ParallaxContainer(
            position: info.position,
            translationFactor: 300,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LevelStars(difficulty: data.levels[info.index].difficulty),
                  LevelMedal(
                    score: data.levels[info.index].analytics.score,
                    scores: data.levels[info.index].scores,
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ParallaxContainer(
                  position: info.position,
                  translationFactor: 100,
                  child: Text(
                    data.levels[info.index].song.title,
                    style: const TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                    ),
                  ),
                ),
                ParallaxContainer(
                  position: info.position,
                  translationFactor: 200,
                  child: Text(
                    data.levels[info.index].song.artist,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                ParallaxContainer(
                  translationFactor: 300,
                  position: info.position,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.levels[info.index].song.album,
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        data.levels[info.index].song.time,
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
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
      return const Icon(
        Globals.noMedalIcon,
        color: Globals.noMedalColor,
        size: 40,
      );
    else
      return Image.asset(
        score < scores.silver
            ? Globals.bronzeMedalPath
            : score < scores.gold
                ? Globals.silverMedalPath
                : Globals.goldMedalPath,
        filterQuality: FilterQuality.medium,
        height: 40,
      );
  }
}
