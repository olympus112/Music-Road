import 'package:flutter/material.dart';

class Globals {
  // Global
  static const double levelContentPadding = 15;
  static const double levelSideMargin = 50;
  static const double viewContentPadding = 5;
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(25));

  // Font
  static const double fontSize = 24;

  // Animation
  static const Duration duration = Duration(milliseconds: 500);

  // Stars
  static const Color starColor = Colors.yellow;
  static const IconData fullStarIcon = Icons.star;
  static const IconData emptyStarIcon = Icons.star_border;
  static const double starSize = 24;

  // Medals
  static const Color noMedalColor = Colors.white24;
  static const IconData noMedalIcon = Icons.circle;
  // https://www.flaticon.com/free-icon/medal_2583344?related_id=2583344&origin=search
  static const String goldMedalPath = 'images/gold.png';
  // https://www.flaticon.com/free-icon/medal_2583319?related_id=2583319&origin=search
  static const String silverMedalPath = 'images/silver.png';
  // https://www.flaticon.com/free-icon/medal_2583434?related_id=2583434&origin=search
  static const String bronzeMedalPath = 'images/bronze.png';
  static const double medalSize = 40;

  // Info
  static const Color infoColor = Colors.white70;
  static const IconData infoIcon = Icons.info;
  static const double infoSize = 24;

  // Coins
  static const String coinPath = 'images/coin.png';

  // Boxes
  static const String settings = 'settings';
  static const String user = 'user';
  static const String levels = 'levels';
}
