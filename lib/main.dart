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
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          side: const BorderSide(color: Colors.white70),
          checkColor: MaterialStateColor.resolveWith((_) => Colors.white70),
        ),
      ),
      home: SafeArea(
        child: MediaQuery.fromWindow(
          child: Scaffold(
            body: AppData(
              builder: (context) => const View(),
            ),
          ),
        ),
      ),
    );
  }
}
