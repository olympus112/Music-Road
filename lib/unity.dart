import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/gameover.dart';
import 'package:musicroad/pauze.dart';

class UnityPlayer extends StatefulWidget {
  late final int levelIndex;

  UnityPlayer({Key? key, required this.levelIndex}) : super(key: key) {
    // print('Created unity player level:$levelIndex');
    // if (levelIndex == 0) levelIndex = 1 + Random.secure().nextInt(2);
  }

  @override
  State<UnityPlayer> createState() => UnityPlayerState();
}

class UnityPlayerState extends State<UnityPlayer> {
  late final UnityWidgetController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
      onUnityUnloaded: onUnityUnloaded,
      onUnityMessage: (message) => onUnityMessage(context, message),
      onUnityCreated: onUnityCreated,
      onUnitySceneLoaded: onUnitySceneLoaded,
      borderRadius: BorderRadius.zero,
    );
  }

  void onUnityCreated(UnityWidgetController controller) {
    this.controller = controller;
    startLevel(widget.levelIndex);
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
              Navigator.pop(context);
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
              Navigator.pop(context);
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

  void onUnitySceneLoaded(SceneLoaded? scene) {
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
}
