import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/gameover.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/pauze.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/view.dart';

class UnityPlayer extends StatefulWidget {
  final int levelIndex;

  const UnityPlayer({Key? key, required this.levelIndex}) : super(key: key);

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
    print('Unity created');
    this.controller = controller;
    showMenu(context);
  }

  void onUnityMessage(BuildContext context, dynamic message) {
    final json = jsonDecode(message as String);
    final action = json['action'];

    print('message received: $json');
    if (action == 'pauze') {
      showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black87,
        context: context,
        builder: (context) {
          return PauzeDialog(
            index: widget.levelIndex,
            level: AppData.levelData[widget.levelIndex].song.title,
            score: (json['score'] as double).round(),
            percentage: json['percentage'] as double,
            onMenu: () {
              Navigator.pop(context);
              showMenu(context);
            },
            onReplay: () {
              Navigator.pop(context);
              replayLevel(widget.levelIndex);
            },
            onResume: () {
              Navigator.pop(context);
              resumeLevel();
            },
          );
        },
      );
    } else if (action == 'stop') {
      final level = Hive.box<UserLevelData>(Globals.levels).getAt(1)!;
      level.score = max((json['score'] as double).round(), level.score);
      level.timesPlayed += 1;
      level.timesLost += json['percentage'] != 1.0 ? 1 : 0;
      level.timesWon += json['percentage'] == 1.0 ? 1 : 0;
      level.save();

      final user = Hive.box(Globals.user);
      user.put(UserData.coins, user.get(UserData.coins) + json['coins'] as int);

      showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black87,
        context: context,
        builder: (context) {
          return GameOverDialog(
            index: widget.levelIndex,
            title: json['percentage'] == 1.0 ? 'Level finished!' : 'Game over',
            score: (json['score'] as double).round(),
            coins: json['coins'] as int,
            percentage: json['percentage'] as double,
            onMenu: () {
              Navigator.pop(context);
              showMenu(context);
            },
            onReplay: () {
              Navigator.pop(context);
              replayLevel(widget.levelIndex);
            },
          );
        },
      );
    }
  }

  void onUnitySceneLoaded(BuildContext context, SceneLoaded? scene) {
    print('Loaded: ${scene?.name}, ${scene?.buildIndex}, ${scene?.isValid}');
  }

  void onUnityUnloaded() {
    print('Unloaded');
  }

  void startLevel(int index) {
    print('Started level: $index');
    controller.postMessage('GameManager', 'startGame', index.toString());
  }

  void resumeLevel() {
    print('Resumed level');
    controller.postMessage('GameManager', 'resumeGame', '');
  }

  void replayLevel(int index) {
    print('Replay level');
    controller.postMessage('GameManager', 'restartGame', index.toString());
  }

  void showMenu(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black,
      useSafeArea: true,
      context: context,
      builder: (context) => const View(),
    );
  }
}
