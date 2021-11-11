enum LevelDifficulty {
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
  final bool unlocked;
  final int score;
  final int timesPlayed;
  final int timesFailed;
  final int timesWon;
  final int minutesPlayed;

  LevelAnalytics.locked({
    this.unlocked = false,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesFailed = 0,
    this.timesWon = 0,
    this.minutesPlayed = 0,
  });

  LevelAnalytics.unlocked({
    this.unlocked = true,
    this.score = 0,
    this.timesPlayed = 0,
    this.timesFailed = 0,
    this.timesWon = 0,
    this.minutesPlayed = 0,
  });
}

class SongData {
  final String title;
  final String artist;
  final String album;
  final String time;
  final String cover;

  const SongData({
    required this.title,
    required this.artist,
    required this.album,
    required this.time,
    required this.cover,
  });
}

class LevelData {
  final SongData song;
  final LevelScores scores;
  final LevelDifficulty difficulty;
  final LevelAnalytics analytics;

  LevelData({
    required this.song,
    required this.scores,
    required this.difficulty,
    required this.analytics,
  });
}
