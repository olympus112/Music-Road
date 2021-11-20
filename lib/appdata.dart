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
  int coins = 550;
  int currentIndex = 1;
  double levelVolume = 1.0;
  double fxVolume = 1.0;
  bool showTutorial = true;

  final List<LevelData> levels = [
    LevelData(
      song: const SongData(
        title: 'Random',
        artist: '',
        album: '',
        released: '',
        time: '--:--',
        price: 200,
        cover: 'images/random.jpg',
        icon: Icons.shuffle,
      ),
      difficulty: null,
      scores: null,
      statistics: null,
      colors: const LevelColors(
        text: Colors.white,
        accent: Color(0xff2b2a3b),
      ),
    ),
    LevelData(
      song: const SongData(
        title: 'Slave to the Rhythm',
        artist: 'Michael Jackson',
        album: 'Xscape',
        released: '1985',
        time: '3:57',
        cover: 'images/sttr.jpg',
        price: 300,
      ),
      difficulty: LevelDifficulty.easy,
      scores: const LevelScores(),
      statistics: LevelStatistics.unlocked(score: 200),
      colors: const LevelColors(
        text: Colors.white,
        accent: Color(0xffb6c1c3),
      ),
    ),
    LevelData(
      song: const SongData(
        title: 'Dive',
        artist: 'Ed Sheeran',
        album: 'Divide',
        released: '2017',
        time: '3:59',
        cover: 'images/dive.jpg',
        price: 400,
      ),
      difficulty: LevelDifficulty.medium,
      scores: const LevelScores(),
      statistics: LevelStatistics.locked(score: 300),
      colors: const LevelColors(
        text: Colors.white,
        accent: Color(0xff83c1e1),
      ),
    ),
    LevelData(
      song: const SongData(
        title: 'Numb',
        artist: 'Dotan',
        album: 'Numb',
        released: '2020',
        time: '3:45',
        cover: 'images/numb.jpg',
        price: 150,
      ),
      difficulty: LevelDifficulty.hard,
      scores: const LevelScores(),
      statistics: LevelStatistics.locked(),
      colors: const LevelColors(
        text: Colors.white,
        accent: Color(0xff910b11),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  LevelData get currentLevel => levels[currentIndex];
  SongData get song => currentLevel.song;
  LevelStatistics? get statistics => currentLevel.statistics;
  LevelScores? get scores => currentLevel.scores;
  LevelColors get colors => currentLevel.colors;
  LevelDifficulty? get difficulty => currentLevel.difficulty;
}
