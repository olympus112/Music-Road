import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/coins.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/settings.dart';

class Widgets {
  static Widget coins(BuildContext context, AppDataState data) {
    return Positioned(
      right: Globals.viewContentPadding,
      top: Globals.viewContentPadding,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Coins(coins: data.coins),
      ),
    );
  }

  static Widget settings(BuildContext context, AppDataState data, VoidCallback onPressed) {
    return Positioned(
      left: Globals.viewContentPadding,
      top: Globals.viewContentPadding,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox.square(
          dimension: 24,
          child: RawMaterialButton(
            elevation: 0,
            onPressed: onPressed,
            shape: const CircleBorder(),
            child: Icon(
              Icons.settings,
              color: data.colors.text,
            ),
          ),
        ),
      ),
    );
  }

  static Widget blurredBackground(String cover, [double sigma = 20]) {
    return Container(
      key: ValueKey(cover),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(cover), fit: BoxFit.cover),
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

  static Widget button(BuildContext context, AppDataState data, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox.square(
      dimension: 60,
      child: RawMaterialButton(
        shape: CircleBorder(
          side: BorderSide(color: color),
        ),
        child: Icon(
          icon,
          color: Colors.white70,
          size: 35,
        ),
        onPressed: onPressed,
      ),
    );
  }

  static void showSettings(BuildContext context, AppDataState data) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return SettingsDialog(data: data);
      },
    );
  }
}
