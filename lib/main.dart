import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/unity.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/userdata_adapter.dart';

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
  static GlobalKey<UnityPlayerState> unity = GlobalKey<UnityPlayerState>();

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
      initialRoute: '/',
      routes: {
        '/': (context) => UnityPlayer(key: unity),
      },
      builder: (context, child) => Scaffold(
        body: child,
      ),
    );
  }
}
