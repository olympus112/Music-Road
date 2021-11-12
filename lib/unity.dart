import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityPlayer extends StatefulWidget {
  const UnityPlayer({Key? key}) : super(key: key);

  @override
  State<UnityPlayer> createState() => UnityPlayerState();
}

class UnityPlayerState extends State<UnityPlayer> {
  late final UnityWidgetController controller;

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
      onUnityCreated: onUnityCreated,
      borderRadius: BorderRadius.zero,
    );
  }

  void onUnityCreated(UnityWidgetController controller) {
    this.controller = controller;
  }
}
