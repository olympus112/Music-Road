import 'package:flutter/material.dart';

class Utils {
  static double width(BuildContext context, {double fraction = 1}) {
    final mediaQuery = MediaQuery.of(context);

    return (mediaQuery.size.width - mediaQuery.padding.left - mediaQuery.padding.right) * fraction;
  }

  static double height(BuildContext context, {double fraction = 1}) {
    final mediaQuery = MediaQuery.of(context);

    return (mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom) * fraction;
  }
}
