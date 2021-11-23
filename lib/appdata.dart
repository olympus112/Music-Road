import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/leveldata.dart';
import 'package:musicroad/userdata.dart';

import 'globals.dart';

class AppData {
  static const List<LevelData> levelData = [
    LevelData(
      song: SongData(
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
      colors: LevelColors(
        text: Colors.white,
        accent: Color(0xff2b2a3b),
      ),
    ),
    LevelData(
      song: SongData(
        title: 'Sparkling Tides',
        artist: 'Wisp X',
        album: '97 - Level Up',
        released: '2015',
        time: '2:52',
        cover: 'images/numb.jpg',
        price: 150,
      ),
      difficulty: LevelDifficulty.hard,
      scores: LevelScores(),
      colors: LevelColors(
        text: Colors.white,
        accent: Color(0xffca5b61),
      ),
    ),
    LevelData(
      song: SongData(
        title: 'Epic Trailer',
        artist: 'Scott Holmes Music',
        album: 'Cinematic Background Music',
        released: '2020',
        time: '1:58',
        cover: 'images/sttr.jpg',
        price: 300,
      ),
      difficulty: LevelDifficulty.easy,
      scores: LevelScores(),
      colors: LevelColors(
        text: Colors.white,
        accent: Color(0xff9C93A7),
      ),
    ),
    LevelData(
      song: SongData(
        title: 'Throwback',
        artist: 'Electro-Light',
        album: 'Throwback',
        released: '2016',
        time: '3:35',
        cover: 'images/dive.jpg',
        price: 400,
      ),
      difficulty: LevelDifficulty.medium,
      scores: LevelScores(),
      colors: LevelColors(
        text: Colors.white,
        accent: Color(0xff64588a),
      ),
    ),
  ];

  static List<UserLevelData> defaultUserLevelData = [
    UserLevelData.unlocked(),
    UserLevelData.unlocked(),
    UserLevelData.locked(),
    UserLevelData.locked(),
  ];

  static Map<String, dynamic> defaultUserSettingsData = {
    UserSettingsData.levelVolume: 1.0,
    UserSettingsData.fxVolume: 1.0,
    UserSettingsData.showTutorial: true,
  };

  static Map<String, dynamic> defaultUserData = {
    UserData.coins: 550,
  };

  static void init() {
    final levels = Hive.box<UserLevelData>(Globals.levels);
    if (levels.isEmpty) levels.addAll(AppData.defaultUserLevelData);

    final settings = Hive.box(Globals.settings);
    if (settings.isEmpty) settings.putAll(AppData.defaultUserSettingsData);

    final user = Hive.box(Globals.user);
    if (user.isEmpty) user.putAll(AppData.defaultUserData);
  }
}
