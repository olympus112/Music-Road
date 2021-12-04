import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/gameover.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/pauze.dart';
import 'package:musicroad/tutorial.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/view.dart';

class UnityPlayer extends StatefulWidget {
  const UnityPlayer({Key? key}) : super(key: key);

  @override
  State<UnityPlayer> createState() => UnityPlayerState();

  static UnityPlayerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<UnityPlayerState>();
    assert(state != null);

    return state!;
  }
}

class UnityPlayerState extends State<UnityPlayer> {
  late final UnityWidgetController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
      onUnityUnloaded: onUnityUnloaded,
      onUnityMessage: (message) => onUnityMessage(context, message),
      onUnityCreated: (controller) => onUnityCreated(context, controller),
      onUnitySceneLoaded: (scene) => onUnitySceneLoaded(context, scene),
      borderRadius: BorderRadius.zero,
    );
  }

  void onUnityCreated(BuildContext context, UnityWidgetController controller) {
    this.controller = controller;
    showMenu(context);
  }

  void onUnityMessage(BuildContext context, dynamic message) {
    final json = jsonDecode(message as String);
    final action = json['action'];

    print('message received: $json');

    if (action == 'pauze') {
      onPauze(json);
    } else {
      if (action == 'stop') onStop(json);
    }
  }

  void onUnitySceneLoaded(BuildContext context, SceneLoaded? scene) {}
  void onUnityUnloaded() {}

  void onPauze(json) {
    // Get parameters
    int unityIndex = Hive.box(Globals.user).get(UserData.lastPlayed);
    double percentage = json['percentage'];
    int coins = json['coins'];
    int score = calculateScore(percentage, coins);

    // Show pauze
    showPauze(
      unityIndex + 1,
      score,
      coins,
      percentage,
    );
  }

  void onStop(json) {
    // Get parameters
    bool won = json['won'];
    int coins = json['coins'];
    double percentage = json['percentage'];
    int score = calculateScore(percentage, coins);

    // Get data for dialog
    final user = Hive.box(Globals.user);
    user.put(UserData.coins, user.get(UserData.coins) + coins);
    final lastPlayed = user.get(UserData.lastPlayed);

    // Show gameover
    showGameOver(
      lastPlayed + 1,
      won ? 'Level finished!' : 'Game over',
      score,
      coins,
      percentage,
    );

    // Update statistics
    final level = Hive.box<UserLevelData>(Globals.levels).getAt(lastPlayed + 1)!;
    level.score = max(score, level.score);
    level.timesPlayed += 1;
    level.timesLost += won ? 0 : 1;
    level.timesWon += won ? 1 : 0;
    level.secondsPlayed += calculateSeconds(AppData.levelData[lastPlayed + 1].song.time);
    level.save();
  }

  void unityStartLevel(int index) {
    // API
    final box = Hive.box(Globals.settings);
    final json = jsonEncode({
      'index': index,
      'sound': box.get(UserSettingsData.levelVolume) ? '1' : '0',
      'tap': box.get(UserSettingsData.tapControls) ? '1' : '0',
    });

    controller.postMessage('GameManager', 'flutterStartGame', json);
  }

  void unityResumeLevel() {
    // API
    controller.postMessage('GameManager', 'flutterResumeGame', '');
  }

  void unityReplayLevel(int index) {
    // API
    unityStartLevel(index);
  }

  void showMenu(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black,
      context: context,
      builder: (context) => const View(),
    );

    final settings = Hive.box(Globals.settings);
    if (settings.get(UserSettingsData.showTutorial)) {
      showTutorial();
      settings.put(UserSettingsData.showTutorial, false);
    }
  }

  void showTutorial() {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black,
      context: context,
      builder: (context) => const Tutorial(
        color: Color(0xff9481f0),
      ),
    );
  }

  void showGameOver(int flutterIndex, String title, int score, int coins, double percentage) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black87,
      context: context,
      builder: (context) {
        return GameOverDialog(
          index: flutterIndex,
          title: title,
          score: score,
          coins: coins,
          percentage: percentage,
          onMenu: () {
            Navigator.pop(context);
            showMenu(context);
          },
          onReplay: () {
            Navigator.pop(context);
            unityReplayLevel(flutterIndex - 1);
          },
        );
      },
    );
  }

  void showPauze(int flutterIndex, int score, int coins, double percentage) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black87,
      context: context,
      builder: (context) {
        return PauzeDialog(
          index: flutterIndex,
          percentage: percentage,
          score: score,
          onMenu: () {
            Navigator.pop(context);
            showMenu(context);
          },
          onReplay: () {
            Navigator.pop(context);
            unityReplayLevel(flutterIndex - 1);
          },
          onResume: () {
            Navigator.pop(context);
            unityResumeLevel();
          },
        );
      },
    );
  }

  int calculateScore(double percentage, int coins) {
    return (percentage * 1000 + coins * 10).round();
  }

  int calculateSeconds(String time) {
    final parts = time.split(':');
    return 60 * int.parse(parts[0]) + int.parse(parts[1]);
  }
}
