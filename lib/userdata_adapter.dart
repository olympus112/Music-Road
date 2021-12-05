import 'package:hive/hive.dart';
import 'package:musicroad/userdata.dart';

class UserLevelDataAdapter extends TypeAdapter<UserLevelData> {
  @override
  final int typeId = 0;

  @override
  UserLevelData read(BinaryReader reader) {
    final unlocked = reader.read();
    final progress = reader.read();
    final score = reader.read();
    final timesPlayed = reader.read();
    final timesLost = reader.read();
    final timesWon = reader.read();
    final secondsPlayed = reader.read();
    final totalCoins = reader.read();

    return UserLevelData(
      unlocked: unlocked ?? false,
      progress: progress ?? 0.0,
      score: score ?? 0,
      timesPlayed: timesPlayed ?? 0,
      timesLost: timesLost ?? 0,
      timesWon: timesWon ?? 0,
      secondsPlayed: secondsPlayed ?? 0,
      totalCoins: totalCoins ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, UserLevelData obj) {
    writer
      ..write(obj.unlocked)
      ..write(obj.progress)
      ..write(obj.score)
      ..write(obj.timesPlayed)
      ..write(obj.timesLost)
      ..write(obj.timesWon)
      ..write(obj.secondsPlayed)
      ..write(obj.totalCoins);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserLevelDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
