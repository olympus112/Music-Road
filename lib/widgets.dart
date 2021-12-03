import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/coins.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/settings.dart';
import 'package:musicroad/userdata.dart';

class Widgets {
  static Widget coins() {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Globals.user).listenable(),
      builder: (condtext, Box box, child) {
        return Positioned(
          right: Globals.viewContentPadding,
          top: Globals.viewContentPadding,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Coins(coins: box.get(UserData.coins), size: 25),
          ),
        );
      },
    );
  }

  static Widget settings(BuildContext context, int index) {
    return Positioned(
      left: Globals.viewContentPadding,
      top: Globals.viewContentPadding,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox.square(
          dimension: 30 + 8,
          child: RawMaterialButton(
            elevation: 0,
            onPressed: () => Widgets.showSettings(context, index),
            shape: const CircleBorder(),
            child: Icon(
              Icons.settings,
              size: 30,
              color: AppData.levelData[index].colors.text,
            ),
          ),
        ),
      ),
    );
  }

  static Widget blurredBackground(int index, [double sigma = 20]) {
    String cover = AppData.levelData[index].song.cover;
    return Container(
      key: ValueKey(cover),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(cover),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  static Widget button(IconData icon, Color color, VoidCallback onPressed, [Color background = Colors.white70]) {
    return SizedBox.square(
      dimension: 60,
      child: RawMaterialButton(
        shape: CircleBorder(
          side: BorderSide(color: color),
        ),
        child: Icon(
          icon,
          color: background,
          size: 35,
        ),
        onPressed: onPressed,
      ),
    );
  }

  static void showSettings(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return SettingsDialog(index: index);
      },
    );
  }
}
