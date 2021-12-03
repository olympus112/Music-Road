import 'package:flutter/material.dart';

class Utils {
  static double width(BuildContext context, {double fraction = 1}) {
    final mediaQuery = MediaQuery.of(context);

    return mediaQuery.size.width * fraction;
  }

  static double height(BuildContext context, {double fraction = 1}) {
    final mediaQuery = MediaQuery.of(context);

    return mediaQuery.size.height * fraction;
  }
}
