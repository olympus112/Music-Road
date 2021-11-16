import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class Statistics extends StatelessWidget {
  final TransformInfo info;

  const Statistics({
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
        borderRadius: BorderRadius.circular(25),
        color: Colors.black,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            fit: StackFit.expand,
            children: [
              background(context, data),
              filter(context, data),
              content(context, data),
            ],
          ),
        ),
      ),
    );
  }

  Widget background(BuildContext context, AppDataState data) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
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
            size: 100,
            color: Colors.white70,
          ),
        if (!data.analytics.unlocked)
          const Icon(
            Icons.lock,
            size: 100,
            color: Colors.white70,
          ),
      ],
    );
  }

  Widget filter(BuildContext context, AppDataState data) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xbb000000),
      ),
    );
  }

  Widget content(BuildContext context, AppDataState data) {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: ParallaxContainer(
          position: info.position,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('General', style: TextStyle(color: data.colors.text, fontSize: 25)),
                Divider(color: data.colors.text),
                Statistic(statistic: 'Score', value: data.analytics.score.toString()),
                Statistic(statistic: 'Minutes played', value: data.analytics.minutesPlayed.toString()),
                Statistic(statistic: 'Times played', value: data.analytics.timesPlayed.toString()),
                Statistic(statistic: 'Times won', value: data.analytics.timesWon.toString()),
                Statistic(statistic: 'Times lost', value: data.analytics.timesLost.toString()),
                const SizedBox(height: 24),
                Text('Song', style: TextStyle(color: data.colors.text, fontSize: 25)),
                Divider(color: data.colors.text),
                Statistic(statistic: 'Title', value: data.song.title),
                Statistic(statistic: 'Artist', value: data.song.artist),
                Statistic(statistic: 'Album', value: data.song.album),
                Statistic(statistic: 'Released', value: data.song.released),
                Statistic(statistic: 'Duration', value: data.song.time),
              ],
            ),
          ),
        ),
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
