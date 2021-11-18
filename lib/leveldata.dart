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

class LevelStatistics {
  bool unlocked;
  final int score;
  final int timesPlayed;
  final int timesLost;
  final int timesWon;
  final int secondsPlayed;

  LevelStatistics.locked({
    this.unlocked = false,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesLost = 0,
    this.timesWon = 0,
    this.secondsPlayed = 0,
  });

  LevelStatistics.unlocked({
    this.unlocked = true,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesLost = 0,
    this.timesWon = 0,
    this.secondsPlayed = 0,
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
    this.icon = Icons.play_arrow,
  });
}

class LevelColors {
  final Color text;
  final Color accent;

  const LevelColors({
    required this.text,
    required this.accent,
  });
}

class LevelData {
  final SongData song;
  final LevelScores? scores;
  final LevelDifficulty? difficulty;
  final LevelStatistics? statistics;
  final LevelColors colors;

  LevelData({
    required this.song,
    required this.scores,
    required this.difficulty,
    required this.statistics,
    required this.colors,
  });
}
