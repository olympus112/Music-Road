import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:musicroad/globals.dart';
import 'package:musicroad/userdata.dart';

class Backend {
  static const String key = 'super-secret-api-key-music-road';
  static const String host = 'boiling-reaches-86392.herokuapp.com';

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<int> createUser(int age, int gamer, int techy, String control) async {
    final parameters = {
      'key': key,
      'age': age.toString(),
      'gamer': gamer.toString(),
      'techy': techy.toString(),
      'control': control,
    };
    final url = Uri.https(host, '/api/users', parameters);
    var response = await http.post(url);

    print('create user: $url');
    print(response.body);

    return int.tryParse(response.body) ?? -1;
  }

  static Future<int> createGame(int unityIndex, bool random, bool sound) async {
    if (Hive.box(Globals.settings).get(UserSettingsData.debug)) return -1;

    final user = Hive.box(Globals.user);
    if (!user.containsKey(UserData.id)) {
      print('ERROR: This user has no user id');
      return -1;
    }

    final parameters = {
      'key': key,
      'user_id': user.get(UserData.id).toString(),
      'level': (unityIndex + 1).toString(),
      'random': random.toString(),
      'sound': sound.toString(),
    };
    final url = Uri.https(host, '/api/analytics/game_runs', parameters);
    final response = await http.post(url);

    print('create game: $url');
    print(response.body);

    return int.tryParse(response.body) ?? -1;
  }

  static Future<void> endGame(int id, double percentage, int score, int coins) async {
    if (Hive.box(Globals.settings).get(UserSettingsData.debug)) return;

    final procent = (percentage * 100).toInt();
    final parameters = {
      'key': key,
      'percentage': procent.toString(),
      'score': score.toString(),
      'coins': coins.toString(),
    };
    final url = Uri.https(host, '/api/analytics/game_runs/$id', parameters);
    final response = await http.put(url);

    print('end ${response.statusCode}: $url');
  }

  static Future<void> pauseGame(int id, double percentage, ActionOrigin origin) async {
    if (Hive.box(Globals.settings).get(UserSettingsData.debug)) return;

    final procent = (percentage * 100).toInt();

    final parameters = {
      'key': key,
      'action_type': 'pause',
      'origin': origin == ActionOrigin.pauze ? 'pause_status' : 'game_over_status',
      'percentage': procent.toString(),
    };
    final url = Uri.https(host, '/api/analytics/game_runs/$id/actions', parameters);
    final response = await http.post(url);

    print('pause ${response.statusCode}: $url');
  }

  static Future<void> replayGame(int id, double percentage, ActionOrigin origin) async {
    if (Hive.box(Globals.settings).get(UserSettingsData.debug)) return;

    final procent = (percentage * 100).toInt();

    final parameters = {
      'key': key,
      'action_type': 'replay',
      'origin': origin == ActionOrigin.pauze ? 'pause_status' : 'game_over_status',
      'percentage': procent.toString(),
    };
    final url = Uri.https(host, '/api/analytics/game_runs/$id/actions', parameters);
    final response = await http.post(url);

    print('replay ${response.statusCode}: $url');
  }

  static Future<void> menuGame(int id, double percentage, ActionOrigin origin) async {
    if (Hive.box(Globals.settings).get(UserSettingsData.debug)) return;

    final procent = (percentage * 100).toInt();

    final parameters = {
      'key': key,
      'action_type': 'menu',
      'origin': origin == ActionOrigin.pauze ? 'pause_status' : 'game_over_status',
      'percentage': procent.toString(),
    };
    final url = Uri.https(host, '/api/analytics/game_runs/$id/actions', parameters);
    final response = await http.post(url);

    print('menu ${response.statusCode}: $url');
  }

  static Future<void> resumeGame(int id, double percentage) async {
    if (Hive.box(Globals.settings).get(UserSettingsData.debug)) return;

    final procent = (percentage * 100).toInt();

    final parameters = {
      'key': key,
      'action_type': 'resume',
      'origin': 'pause_status',
      'percentage': procent.toString(),
    };
    final url = Uri.https(host, '/api/analytics/game_runs/$id/actions', parameters);
    final response = await http.post(url);

    print('resume ${response.statusCode}: $url');
  }

  static Future<void> review(int level, int satisfied, int difficulty) async {
    if (Hive.box(Globals.settings).get(UserSettingsData.debug)) return;

    final user = Hive.box(Globals.user);
    final id = user.get(UserData.id);
    final parameters = {
      'key': key,
      'satisfiability': satisfied.toString(),
      'difficulty': difficulty.toString(),
      'level': level.toString(),
    };
    final url = Uri.https(host, '/api/users/$id/reviews', parameters);
    final response = await http.post(url);

    print('review ${response.statusCode}: $url');
  }
}

enum ActionOrigin {
  pauze,
  gameover,
}
