import 'package:flutter/material.dart';

import 'globals.dart';

class Coins extends StatelessWidget {
  final String prefix;
  final int coins;
  final Color color;
  final double size;
  final EdgeInsets padding;

  const Coins({
    Key? key,
    required this.coins,
    this.prefix = '',
    this.color = Colors.white,
    this.size = 20,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefix.isNotEmpty)
            Text(
              prefix,
              style: TextStyle(color: color, fontSize: size),
            ),
          if (prefix.isNotEmpty) const SizedBox(width: 8),
          Image.asset(
            Globals.coinPath,
            filterQuality: FilterQuality.medium,
            height: size,
          ),
          const SizedBox(width: 8),
          Text(
            coins.toString(),
            style: TextStyle(color: color, fontSize: size),
          )
        ],
      ),
    );
  }
}
