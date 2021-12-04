import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/backend.dart';
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

  Future<void> unityStartLevel(int unityIndex, [bool random = false]) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Loading level...', textAlign: TextAlign.center)));

    final settings = Hive.box(Globals.settings);
    final user = Hive.box(Globals.user);

    final id = await Backend.createGame(unityIndex, random, settings.get(UserSettingsData.levelVolume));
    user.put(UserData.game, id);

    ScaffoldMessenger.of(context).clearSnackBars();

    final json = jsonEncode({
      'index': unityIndex.toString(),
      'sound': settings.get(UserSettingsData.levelVolume) ? '1' : '0',
      'tap': settings.get(UserSettingsData.tapControls) ? '1' : '0',
    });

    controller.postMessage('GameManager', 'flutterStartGame', json);
  }

  void unityResumeLevel() {
    controller.postMessage('GameManager', 'flutterResumeGame', '');
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
      builder: (context) => Tutorial(
        color: const Color(0xff9481f0),
        questionaire: true,
      ),
    );
  }

  void showGameOver(int flutterIndex, String title, int score, int coins, double percentage) {
    final id = Hive.box(Globals.user).get(UserData.game);
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
            Backend.menuGame(id, percentage, ActionOrigin.gameover).then((_) => Backend.endGame(id, percentage, score, coins));
            showMenu(context);
          },
          onReplay: () {
            Navigator.pop(context);
            Backend.replayGame(id, percentage, ActionOrigin.gameover).then((_) => Backend.endGame(id, percentage, score, coins));
            unityStartLevel(flutterIndex - 1);
          },
        );
      },
    );
  }

  void showPauze(int flutterIndex, int score, int coins, double percentage) {
    final id = Hive.box(Globals.user).get(UserData.game);
    Backend.pauseGame(id, percentage, ActionOrigin.pauze);

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
            Backend.menuGame(id, percentage, ActionOrigin.pauze).then((value) => Backend.endGame(id, percentage, score, coins)).then((_) => Backend.endGame(id, percentage, score, coins));
            showMenu(context);
          },
          onReplay: () {
            Navigator.pop(context);
            Backend.replayGame(id, percentage, ActionOrigin.pauze).then((_) => Backend.endGame(id, percentage, score, coins));
            unityStartLevel(flutterIndex - 1);
          },
          onResume: () {
            Navigator.pop(context);
            Backend.resumeGame(id, percentage);
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
