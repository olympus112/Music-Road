import 'package:flutter/material.dart';

enum LevelDifficulty {
  none,
  easy,
  medium,
  hard,
}

class LevelScores {
  final double bronze;
  final double silver;
  final double gold;

  const LevelScores({
    this.bronze = 0.5,
    this.silver = 0.7,
    this.gold = 1.0,
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
  final LevelScores? percentages;
  final LevelDifficulty? difficulty;
  final LevelColors colors;

  const LevelData({
    required this.song,
    required this.percentages,
    required this.difficulty,
    required this.colors,
  });
}
