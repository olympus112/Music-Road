import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserLevelData extends HiveObject {
  @HiveField(0, defaultValue: false)
  bool unlocked;

  @HiveField(1, defaultValue: 0.0)
  double progress;

  @HiveField(2, defaultValue: 0)
  int score;

  @HiveField(3, defaultValue: 0)
  int timesPlayed;

  @HiveField(4, defaultValue: 0)
  int timesLost;

  @HiveField(5, defaultValue: 0)
  int timesWon;

  @HiveField(6, defaultValue: 0)
  int secondsPlayed;

  @HiveField(7, defaultValue: 0)
  int totalCoins;

  UserLevelData({
    required this.unlocked,
    required this.progress,
    required this.score,
    required this.timesPlayed,
    required this.timesLost,
    required this.timesWon,
    required this.secondsPlayed,
    required this.totalCoins,
  });

  UserLevelData.locked({
    this.unlocked = false,
    this.progress = 0.0,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesLost = 0,
    this.timesWon = 0,
    this.secondsPlayed = 0,
    this.totalCoins = 0,
  });

  UserLevelData.unlocked({
    this.unlocked = true,
    this.progress = 0.0,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesLost = 0,
    this.timesWon = 0,
    this.secondsPlayed = 0,
    this.totalCoins = 0,
  });
}

class UserData {
  static const String coins = 'coins';
  static const String lastPlayed = 'lastPlayed';

  static const String id = 'id';
  static const String game = 'game';
}

class UserSettingsData {
  static const String levelVolume = 'levelVolume';
  static const String showTutorial = 'showTutorial';
  static const String tapControls = 'tapControls';
  static const String debug = 'debug';
}
