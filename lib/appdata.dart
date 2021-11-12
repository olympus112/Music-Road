import 'package:flutter/material.dart';
import 'package:musicroad/leveldata.dart';

class AppData extends StatefulWidget {
  final Widget Function(BuildContext) builder;

  const AppData({Key? key, required this.builder}) : super(key: key);

  @override
  State<AppData> createState() => AppDataState();

  static AppDataState of(BuildContext context) {
    final state = context.findAncestorStateOfType<AppDataState>();
    assert(state != null);

    return state!;
  }
}

class AppDataState extends State<AppData> {
  final int coins = 0;
  final List<LevelData> levels = [
    LevelData(
      song: const SongData(
        title: 'Slave to the Rhythm',
        artist: 'Michael Jackson',
        album: 'Xscape',
        time: '3:57',
        cover: 'http://media.oscarmini.com/wp-content/uploads/2014/08/05044727/michaeljackson_coverart.jpg',
      ),
      difficulty: LevelDifficulty.easy,
      scores: const LevelScores(),
      analytics: LevelAnalytics.unlocked(score: 200),
    ),
    LevelData(
      song: const SongData(
        title: 'Dive',
        artist: 'Ed Sheeran',
        album: 'Divide',
        time: '3:59',
        cover: 'https://media.s-bol.com/mADWWJA14ZO/550x550.jpg',
      ),
      difficulty: LevelDifficulty.medium,
      scores: const LevelScores(),
      analytics: LevelAnalytics.locked(score: 300),
    ),
    LevelData(
      song: const SongData(
        title: 'Numb',
        artist: 'Dotan',
        album: 'Numb',
        time: '3:45',
        cover: 'https://m.media-amazon.com/images/M/MV5BNzMzZGI3ZTAtNjBlNy00NWE0LWEwY2MtZTBhODQ5MjQ1OTEwXkEyXkFqcGdeQXVyNjU1OTg4OTM@._V1_.jpg',
      ),
      difficulty: LevelDifficulty.hard,
      scores: const LevelScores(),
      analytics: LevelAnalytics.locked(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
