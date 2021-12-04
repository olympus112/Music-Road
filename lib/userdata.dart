import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserLevelData extends HiveObject {
  @HiveField(0, defaultValue: false)
  bool unlocked;

  @HiveField(1, defaultValue: 0)
  int score;

  @HiveField(2, defaultValue: 0)
  int timesPlayed;

  @HiveField(3, defaultValue: 0)
  int timesLost;

  @HiveField(4, defaultValue: 0)
  int timesWon;

  @HiveField(5, defaultValue: 0)
  int secondsPlayed;

  UserLevelData({
    required this.unlocked,
    required this.score,
    required this.timesPlayed,
    required this.timesLost,
    required this.timesWon,
    required this.secondsPlayed,
  });

  UserLevelData.locked({
    this.unlocked = false,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesLost = 0,
    this.timesWon = 0,
    this.secondsPlayed = 0,
  });

  UserLevelData.unlocked({
    this.unlocked = true,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesLost = 0,
    this.timesWon = 0,
    this.secondsPlayed = 0,
  });
}

class UserData {
  static const String coins = 'coins';
  static const String lastPlayed = 'lastPlayed';
}

class UserSettingsData {
  static const String levelVolume = 'levelVolume';
  static const String showTutorial = 'showTutorial';
  static const String tapControls = 'tapControls';
}
