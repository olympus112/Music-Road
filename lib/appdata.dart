import 'dart:math';

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
        price: 0,
        cover: 'images/random.jpg',
        icon: Icons.shuffle,
      ),
      difficulty: null,
      percentages: null,
      colors: LevelColors(
        text: Colors.white,
        accent: Color(0xff2b2a3b),
      ),
    ),
    LevelData(
      song: SongData(
        title: 'Epic Trailer',
        artist: 'Scott Holmes Music',
        album: 'Cinematic Music',
        released: '2020',
        time: '1:58',
        cover: 'images/sttr.jpg',
        price: 0,
      ),
      difficulty: LevelDifficulty.easy,
      percentages: LevelScores(),
      colors: LevelColors(
        text: Colors.white,
        accent: Color(0xff9C93A7),
      ),
    ),
    LevelData(
      song: SongData(
        title: 'A million questions',
        artist: 'Ryan Exley',
        album: 'Ragequit',
        released: '2015',
        time: '3:25',
        cover: 'images/lives.jpg',
        price: 125,
      ),
      difficulty: LevelDifficulty.medium,
      percentages: LevelScores(),
      colors: LevelColors(
        text: Colors.white,
        accent: Color(0xffde7c10),
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
        price: 300,
      ),
      difficulty: LevelDifficulty.medium,
      percentages: LevelScores(),
      colors: LevelColors(
        text: Colors.white,
        accent: Color(0xff117d9e),
      ),
    ),
    LevelData(
      song: SongData(
        title: 'Sparkling Tides',
        artist: 'Wisp X',
        album: 'Level Up',
        released: '2015',
        time: '2:52',
        cover: 'images/numb.jpg',
        price: 500,
      ),
      difficulty: LevelDifficulty.hard,
      percentages: LevelScores(),
      colors: LevelColors(
        text: Colors.white,
        accent: Color(0xffca5b61),
      ),
    ),
  ];

  static List<UserLevelData> defaultUserLevelData = [
    UserLevelData.unlocked(),
    UserLevelData.unlocked(),
    UserLevelData.locked(),
    UserLevelData.locked(),
    UserLevelData.locked(),
  ];

  static Map<String, dynamic> defaultUserSettingsData = {
    UserSettingsData.levelVolume: true,
    UserSettingsData.showTutorial: true,
    UserSettingsData.debug: false,
  };

  static Map<String, dynamic> defaultUserData = {
    UserData.coins: 0,
    UserData.lastPlayed: 0,
  };

  static void init() {
    final levels = Hive.box<UserLevelData>(Globals.levels);
    if (levels.isEmpty) levels.addAll(AppData.defaultUserLevelData);

    final settings = Hive.box(Globals.settings);
    for (final entry in defaultUserSettingsData.entries) {
      if (!settings.containsKey(entry.key)) {
        settings.put(entry.key, entry.value);
      } else if (settings.get(entry.key).runtimeType != entry.value.runtimeType) {
        settings.put(entry.key, entry.value);
      }
    }

    final user = Hive.box(Globals.user);
    for (final entry in defaultUserData.entries) {
      if (!user.containsKey(entry.key)) {
        user.put(entry.key, entry.value);
      } else if (user.get(entry.key).runtimeType != entry.value.runtimeType) {
        user.put(entry.key, entry.value);
      }
    }

    if (!settings.containsKey(UserSettingsData.tapControls)) {
      settings.put(UserSettingsData.tapControls, Random(DateTime.now().millisecondsSinceEpoch).nextBool());
    }
  }
}
