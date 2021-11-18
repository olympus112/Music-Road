import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/utils.dart';

import 'coins.dart';
import 'globals.dart';

class BuyLevelDialog extends StatelessWidget {
  final AppDataState data;
  final void Function() onBuy;
  final double heightFraction;

  const BuyLevelDialog({Key? key, required this.data, required this.onBuy, this.heightFraction = 0.5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Utils.height(context, fraction: heightFraction),
      child: Material(
        elevation: 4,
        color: Colors.black26,
        borderRadius: Globals.borderRadius,
        child: ClipRRect(
          borderRadius: Globals.borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              background(context, data),
              content(context, data),
            ],
          ),
        ),
      ),
    );
  }

  Widget background(BuildContext context, AppDataState data) {
    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Colors.black54,
          BlendMode.darken,
        ),
        child: Image.asset(
          data.currentLevel.song.cover,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget content(BuildContext context, AppDataState data) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(Globals.levelContentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                'Buy',
                style: TextStyle(color: data.colors.text, fontSize: 40),
              ),
            ),
            Divider(
              color: data.colors.text,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            Text(
              data.currentLevel.song.title,
              style: TextStyle(
                fontSize: 45,
                color: data.colors.text,
              ),
            ),
            Text(
              data.currentLevel.song.artist,
              style: TextStyle(
                fontSize: 20,
                color: data.currentLevel.colors.text,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.currentLevel.song.album,
                  style: TextStyle(
                    fontSize: 18,
                    color: data.currentLevel.colors.text,
                  ),
                ),
                Text(
                  data.currentLevel.song.time,
                  style: TextStyle(
                    fontSize: 18,
                    color: data.currentLevel.colors.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              height: 16,
              color: data.colors.text,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onBuy();
                    Navigator.pop(context);
                  },
                  child: Coins(
                    coins: data.currentLevel.song.price,
                    prefix: 'Buy for',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
