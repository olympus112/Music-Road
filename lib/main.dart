import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/unity.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/userdata_adapter.dart';
import 'package:musicroad/view.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserLevelDataAdapter());

  await Hive.openBox(Globals.settings);
  await Hive.openBox(Globals.user);
  await Hive.openBox<UserLevelData>(Globals.levels);

  AppData.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          side: const BorderSide(color: Colors.white70),
          checkColor: MaterialStateColor.resolveWith((_) => Colors.white70),
        ),
      ),
      routes: {
        '/': (context) => const View(),
        '/unity': (context) {
          return Builder(
            builder: (context) => UnityPlayer(levelIndex: ModalRoute.of(context)!.settings.arguments as int),
          );
        },
      },
      builder: (context, child) => SafeArea(
        child: MediaQuery.fromWindow(
          child: Scaffold(
            body: child,
          ),
        ),
      ),
    );
  }
}
