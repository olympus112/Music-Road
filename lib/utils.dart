import 'package:flutter/material.dart';

class Utils {
  static double width(BuildContext context, {double fraction = 1}) => MediaQuery.of(context).size.width * fraction;
  static double height(BuildContext context, {double fraction = 1}) => MediaQuery.of(context).size.height * fraction;
}
