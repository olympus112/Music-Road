import 'package:flutter/material.dart';

enum LevelDifficulty {
  none,
  easy,
  medium,
  hard,
}

class LevelScores {
  final int bronze;
  final int silver;
  final int gold;

  const LevelScores({
    this.bronze = 100,
    this.silver = 200,
    this.gold = 300,
  });
}

class LevelAnalytics {
  bool unlocked;
  final int score;
  final int timesPlayed;
  final int timesLost;
  final int timesWon;
  final int minutesPlayed;

  LevelAnalytics.locked({
    this.unlocked = false,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesLost = 0,
    this.timesWon = 0,
    this.minutesPlayed = 0,
  });

  LevelAnalytics.unlocked({
    this.unlocked = true,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesLost = 0,
    this.timesWon = 0,
    this.minutesPlayed = 0,
  });
}

class SongData {
  final String title;
  final String artist;
  final String album;
  final String released;
  final String time;
  final String cover;
  final int price;
  final IconData? icon;

  const SongData({
    required this.title,
    required this.artist,
    required this.album,
    required this.released,
    required this.time,
    required this.cover,
    required this.price,
    this.icon,
  });
}

class LevelColors {
  final Color text;
  final Color play;

  const LevelColors({
    required this.text,
    required this.play,
  });
}

class LevelData {
  final SongData song;
  final LevelScores scores;
  final LevelDifficulty difficulty;
  final LevelAnalytics analytics;
  final LevelColors colors;

  LevelData({
    required this.song,
    required this.scores,
    required this.difficulty,
    required this.analytics,
    required this.colors,
  });
}
