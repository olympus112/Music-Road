import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/gameover.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/medal.dart';
import 'package:musicroad/pauze.dart';
import 'package:musicroad/stars.dart';
import 'package:musicroad/view.dart';
import 'package:transformer_page_view/parallax.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'coins.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: Globals.levelSideMargin),
      child: Material(
        elevation: 4,
        color: Colors.black26,
        borderRadius: Globals.borderRadius,
        child: ClipRRect(
          borderRadius: Globals.borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              background(context, data),
              content(context, data),
              stars(context, data),
              medal(context, data),
              button(context, data),
              statistics(context, data),
            ],
          ),
        ),
      ),
    );
  }

  Widget background(BuildContext context, AppDataState data) {
    return Positioned.fill(
      child: ParallaxImage.asset(
        data.levels[info.index].song.cover,
        position: info.position,
      ),
    );
  }

  Widget button(BuildContext context, AppDataState data) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: Globals.borderRadius,
        onLongPress: () {
          showDialog(
            barrierDismissible: false,
            barrierColor: Colors.black87,
            context: context,
            builder: (context) {
              return GameOverDialog(
                data: data,
                level: data.levels[data.currentIndex].song.title,
                title: 'Game Over',
                score: 150,
                percentage: 0.7,
                coins: 200,
              );
            },
          );
        },
        onDoubleTap: () {
          showDialog(
            barrierDismissible: false,
            barrierColor: Colors.black87,
            context: context,
            builder: (context) {
              return GameOverDialog(
                data: data,
                level: data.levels[data.currentIndex].song.title,
                title: 'Level completed!',
                score: 300,
                percentage: 1,
                coins: 300,
              );
            },
          );
        },
        onTapCancel: () {
          showDialog(
            barrierDismissible: false,
            barrierColor: Colors.black87,
            context: context,
            builder: (context) {
              return PauzeDialog(
                data: data,
                level: data.levels[data.currentIndex].song.title,
                percentage: 0.5,
                score: 220,
              );
            },
          );
        },
        onTap: () {
          if (data.statistics?.unlocked == false)
            View.of(context).onBuy(data);
          else
            View.of(context).onPlay(data);
        },
        child: ParallaxContainer(
          translationFactor: 50,
          position: info.position,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                data.statistics?.unlocked == false ? Icons.lock : data.levels[info.index].song.icon,
                color: Colors.white70,
                size: 100,
              ),
              if (data.statistics?.unlocked == false) Coins(coins: data.levels[info.index].song.price),
            ],
          ),
        ),
      ),
    );
  }

  Widget stars(BuildContext context, AppDataState data) {
    return Positioned(
      left: Globals.levelContentPadding,
      top: Globals.levelContentPadding,
      child: ParallaxContainer(
        translationFactor: 200,
        position: info.position,
        child: LevelStars(
          difficulty: data.difficulty,
        ),
      ),
    );
  }

  Widget medal(BuildContext context, AppDataState data) {
    return Positioned(
      left: Globals.levelContentPadding,
      right: Globals.levelContentPadding,
      top: Globals.levelContentPadding,
      child: ParallaxContainer(
        translationFactor: 200,
        position: info.position,
        child: LevelMedal(
          score: data.levels[info.index].statistics?.score,
          scores: data.levels[info.index].scores,
        ),
      ),
    );
  }

  Widget statistics(BuildContext context, AppDataState data) {
    if (data.levels[info.index].statistics == null) return const SizedBox.shrink();

    return Positioned(
      right: Globals.levelContentPadding,
      top: Globals.levelContentPadding,
      child: ParallaxContainer(
        translationFactor: 200,
        position: info.position,
        child: SizedBox.square(
          dimension: Globals.infoSize,
          child: RawMaterialButton(
            elevation: 1,
            shape: const CircleBorder(),
            child: const Icon(
              Globals.infoIcon,
              color: Globals.infoColor,
            ),
            onPressed: () => View.of(context).flipControllers[info.index].toggleCard(),
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context, AppDataState data) {
    return Positioned(
      left: Globals.levelContentPadding,
      right: Globals.levelContentPadding,
      bottom: Globals.levelContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ParallaxContainer(
            position: info.position,
            translationFactor: 100,
            child: Text(
              data.levels[info.index].song.title,
              style: TextStyle(
                fontSize: 45,
                color: data.colors.text,
              ),
            ),
          ),
          ParallaxContainer(
            position: info.position,
            translationFactor: 200,
            child: Text(
              data.levels[info.index].song.artist,
              style: TextStyle(
                fontSize: 20,
                color: data.levels[info.index].colors.text,
              ),
            ),
          ),
          Divider(
            color: data.levels[info.index].colors.text,
          ),
          ParallaxContainer(
            translationFactor: 300,
            position: info.position,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.levels[info.index].song.album,
                  style: TextStyle(
                    fontSize: 18,
                    color: data.levels[info.index].colors.text,
                  ),
                ),
                Text(
                  data.levels[info.index].song.time,
                  style: TextStyle(
                    fontSize: 18,
                    color: data.levels[info.index].colors.text,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
