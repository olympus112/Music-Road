import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/view.dart';

void main() {
  runApp(const MRApp());
}

class MRApp extends StatelessWidget {
  const MRApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: AppData(
            builder: (context) => const View(),
          ),
        ),
      ),
    );
  }
}

/*
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  late final UnityWidgetController controller;
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Unity"),
        ),
        body: UnityWidget(
          borderRadius: BorderRadius.zero,
          onUnityCreated: onUnityCreated,
        ),
      ),
    );
  }

  void onUnityCreated(UnityWidgetController controller) => this.controller = controller;
  void setRotationSpeed(String speed) => controller.postMessage("Cube", "SetRotationSpeed", speed);
}
*/
