import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/view.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'globals.dart';

class Statistics extends StatelessWidget {
  final TransformInfo info;

  const Statistics({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Material(
        elevation: 4,
        borderRadius: Globals.borderRadius,
        color: Colors.black,
        child: ClipRRect(
          borderRadius: Globals.borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              background(context),
              filter(context),
              content(context),
              close(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget background(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ParallaxImage.asset(
          AppData.levelData[info.index].song.cover,
          position: info.position,
        ),
        ValueListenableBuilder(
          valueListenable: Hive.box<UserLevelData>(Globals.levels).listenable(),
          builder: (context, Box<UserLevelData> box, child) {
            return Icon(
              box.getAt(info.index)?.unlocked == false ? Icons.lock : AppData.levelData[info.index].song.icon,
              color: Colors.white70,
              size: 100,
            );
          },
        ),
      ],
    );
  }

  Widget filter(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xbb000000),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: ParallaxContainer(
          position: info.position,
          child: SingleChildScrollView(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<UserLevelData>(Globals.levels).listenable(),
              builder: (context, Box<UserLevelData> box, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('General', style: TextStyle(color: AppData.levelData[info.index].colors.text, fontSize: 25)),
                    Divider(color: AppData.levelData[info.index].colors.text),
                    Statistic(statistic: 'Score', value: box.getAt(info.index)?.score.toString() ?? '-'),
                    Statistic(statistic: 'Minutes played', value: box.getAt(info.index)?.secondsPlayed.toString() ?? '-'),
                    Statistic(statistic: 'Times played', value: box.getAt(info.index)?.timesPlayed.toString() ?? '-'),
                    Statistic(statistic: 'Times won', value: box.getAt(info.index)?.timesWon.toString() ?? '-'),
                    Statistic(statistic: 'Times lost', value: box.getAt(info.index)?.timesLost.toString() ?? '-'),
                    const SizedBox(height: 24),
                    Text('Song', style: TextStyle(color: AppData.levelData[info.index].colors.text, fontSize: 25)),
                    Divider(color: AppData.levelData[info.index].colors.text),
                    Statistic(statistic: 'Title', value: AppData.levelData[info.index].song.title),
                    Statistic(statistic: 'Artist', value: AppData.levelData[info.index].song.artist),
                    Statistic(statistic: 'Album', value: AppData.levelData[info.index].song.album),
                    Statistic(statistic: 'Released', value: AppData.levelData[info.index].song.released),
                    Statistic(statistic: 'Duration', value: AppData.levelData[info.index].song.time),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget close(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: Globals.borderRadius,
        onTap: () => View.of(context).flipControllers[info.index].toggleCard(),
      ),
    );
  }
}

class Statistic extends StatelessWidget {
  final String statistic;
  final String value;

  const Statistic({Key? key, required this.statistic, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.circle,
                color: Colors.white,
                size: 6,
              ),
              const SizedBox(width: 8),
              Text(
                statistic,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const Divider(),
          Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
