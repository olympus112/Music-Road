import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/utils.dart';

import 'coins.dart';
import 'globals.dart';

class BuyLevelDialog extends StatelessWidget {
  final int index;
  final double heightFraction;
  final VoidCallback onBuy;

  const BuyLevelDialog({Key? key, required this.index, required this.onBuy, this.heightFraction = 0.5}) : super(key: key);

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
              background(),
              content(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget background() {
    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Colors.black54,
          BlendMode.darken,
        ),
        child: Image.asset(
          AppData.levelData[index].song.cover,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
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
                style: TextStyle(color: AppData.levelData[index].colors.text, fontSize: 40),
              ),
            ),
            Divider(
              color: AppData.levelData[index].colors.text,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            Text(
              AppData.levelData[index].song.title,
              style: TextStyle(
                fontSize: 45,
                color: AppData.levelData[index].colors.text,
              ),
            ),
            Text(
              AppData.levelData[index].song.artist,
              style: TextStyle(
                fontSize: 20,
                color: AppData.levelData[index].colors.text,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppData.levelData[index].song.album,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppData.levelData[index].colors.text,
                  ),
                ),
                Text(
                  AppData.levelData[index].song.time,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppData.levelData[index].colors.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              height: 16,
              color: AppData.levelData[index].colors.text,
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
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith(
                      (states) => const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.red),
                        borderRadius: Globals.borderRadius,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onBuy,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                        side: BorderSide(color: AppData.levelData[index].colors.accent),
                        borderRadius: Globals.borderRadius,
                      ),
                    ),
                  ),
                  child: Coins(
                    coins: AppData.levelData[index].song.price,
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
