import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/medal.dart';
import 'package:musicroad/stars.dart';
import 'package:musicroad/userdata.dart';
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
              background(),
              content(context),
              stars(),
              medal(),
              button(context),
              statistics(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget background() {
    return Positioned.fill(
      child: ParallaxImage.asset(
        AppData.levelData[info.index].song.cover,
        position: info.position,
      ),
    );
  }

  Widget button(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: Globals.borderRadius,
        onTap: () {
          if (Hive.box<UserLevelData>(Globals.levels).getAt(info.index)?.unlocked == false)
            View.of(context).onBuy();
          else
            View.of(context).onPlay(info.index);
        },
        child: ParallaxContainer(
          translationFactor: 50,
          position: info.position,
          child: ValueListenableBuilder(
            valueListenable: Hive.box<UserLevelData>(Globals.levels).listenable(),
            builder: (context, Box<UserLevelData> box, child) {
              bool locked = box.getAt(info.index)?.unlocked == false;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    locked ? Icons.lock : AppData.levelData[info.index].song.icon,
                    color: Colors.white70,
                    size: 100,
                  ),
                  if (locked) Coins(coins: AppData.levelData[info.index].song.price),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget stars() {
    return Positioned(
      left: Globals.levelContentPadding,
      top: Globals.levelContentPadding,
      child: ParallaxContainer(
        translationFactor: 200,
        position: info.position,
        child: LevelStars(
          difficulty: AppData.levelData[info.index].difficulty,
        ),
      ),
    );
  }

  Widget medal() {
    return Positioned(
      left: Globals.levelContentPadding,
      right: Globals.levelContentPadding,
      top: Globals.levelContentPadding,
      child: ParallaxContainer(
        translationFactor: 200,
        position: info.position,
        child: ValueListenableBuilder(
          valueListenable: Hive.box<UserLevelData>(Globals.levels).listenable(),
          builder: (context, Box<UserLevelData> box, child) {
            return LevelMedal(
              score: box.getAt(info.index)?.score,
              scores: AppData.levelData[info.index].scores,
            );
          },
        ),
      ),
    );
  }

  Widget statistics(BuildContext context) {
    if (AppData.levelData[info.index].scores == null) return const SizedBox.shrink();

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

  Widget content(BuildContext context) {
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
              AppData.levelData[info.index].song.title,
              style: TextStyle(
                fontSize: 45,
                color: AppData.levelData[info.index].colors.text,
              ),
            ),
          ),
          ParallaxContainer(
            position: info.position,
            translationFactor: 200,
            child: Text(
              AppData.levelData[info.index].song.artist,
              style: TextStyle(
                fontSize: 20,
                color: AppData.levelData[info.index].colors.text,
              ),
            ),
          ),
          Divider(
            color: AppData.levelData[info.index].colors.text,
          ),
          ParallaxContainer(
            translationFactor: 300,
            position: info.position,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppData.levelData[info.index].song.album,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppData.levelData[info.index].colors.text,
                  ),
                ),
                Text(
                  AppData.levelData[info.index].song.time,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppData.levelData[info.index].colors.text,
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
