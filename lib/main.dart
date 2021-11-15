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
