import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/coins.dart';
import 'package:musicroad/tutorial.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/widgets.dart';

import 'globals.dart';

class SettingsDialog extends StatelessWidget {
  final int index;
  final double heightFraction;

  const SettingsDialog({Key? key, required this.index, this.heightFraction = 0.7}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Globals.levelSideMargin),
      child: Material(
        elevation: 4,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppData.levelData[index].colors.accent),
          borderRadius: Globals.borderRadius,
        ),
        child: ClipRRect(
          borderRadius: Globals.borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              background(),
              content(context),
              close(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget background() {
    return Widgets.blurredBackground(index);
  }

  Widget content(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Globals.settings).listenable(),
      builder: (context, Box box, child) {
        return Positioned.fill(
          bottom: 100,
          child: Padding(
            padding: const EdgeInsets.all(Globals.levelContentPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(color: AppData.levelData[index].colors.text, fontSize: 40),
                    ),
                  ),
                  Divider(
                    color: AppData.levelData[index].colors.text,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  VolumeSlider(
                    index: index,
                    title: 'Level volume',
                    value: box.get(UserSettingsData.levelVolume),
                    onChanged: (value) => box.put(UserSettingsData.levelVolume, value),
                  ),
                  VolumeSlider(
                    index: index,
                    title: 'FX volume',
                    value: box.get(UserSettingsData.fxVolume),
                    onChanged: (value) => box.put(UserSettingsData.fxVolume, value),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Controls',
                    style: TextStyle(
                      color: AppData.levelData[index].colors.text,
                      fontSize: Globals.fontSize,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Widgets.button(
                            Icons.touch_app,
                            AppData.levelData[index].colors.accent,
                            () => box.put(UserSettingsData.tapControls, true),
                            box.get(UserSettingsData.tapControls) ? Colors.white : Colors.white54,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap',
                            style: TextStyle(
                              color: box.get(UserSettingsData.tapControls) ? Colors.white : Colors.white54,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Widgets.button(
                            Icons.swipe,
                            AppData.levelData[index].colors.accent,
                            () => box.put(UserSettingsData.tapControls, false),
                            box.get(UserSettingsData.tapControls) ? Colors.white54 : Colors.white,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Swipe',
                            style: TextStyle(
                              color: box.get(UserSettingsData.tapControls) ? Colors.white54 : Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => showTutorial(context, AppData.levelData[index].colors.accent),
                      child: Text(
                        'Show tutorial',
                        style: TextStyle(
                          color: AppData.levelData[index].colors.text,
                          fontSize: 20,
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith(
                          (states) => RoundedRectangleBorder(
                            side: BorderSide(color: AppData.levelData[index].colors.accent),
                            borderRadius: Globals.borderRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...debug(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showTutorial(BuildContext context, [Color color = const Color(0xff9481f0)]) {
    showDialog(
      context: context,
      builder: (context) {
        return Tutorial(color: color);
      },
    );
  }

  Widget close(BuildContext context) {
    return Positioned(
      bottom: Globals.levelContentPadding * 2,
      left: 0,
      right: 0,
      child: Widgets.button(Icons.close, AppData.levelData[index].colors.accent, () => Navigator.pop(context)),
    );
  }

  List<Widget> debug() {
    return [
      const SizedBox(height: 100),
      const SizedBox(height: 16),
      Text(
        'Debug',
        style: TextStyle(color: AppData.levelData[index].colors.text, fontSize: 40),
      ),
      Divider(
        color: AppData.levelData[index].colors.text,
        thickness: 1,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              final user = Hive.box(Globals.user);
              user.put(UserData.coins, user.get(UserData.coins) - 50);
            },
            child: const Coins(coins: 50, prefix: '-'),
          ),
          TextButton(
            onPressed: () {
              final user = Hive.box(Globals.user);
              user.put(UserData.coins, user.get(UserData.coins) + 50);
            },
            child: const Coins(coins: 50, prefix: '+'),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Hive.box<UserLevelData>(Globals.levels).getAt(index)
                ?..unlocked = false
                ..save();
            },
            child: Text('Lock', style: TextStyle(color: AppData.levelData[index].colors.text)),
          ),
          TextButton(
            onPressed: () {
              Hive.box<UserLevelData>(Globals.levels).getAt(index)
                ?..unlocked = true
                ..save();
            },
            child: Text('Unlock', style: TextStyle(color: AppData.levelData[index].colors.text)),
          ),
          TextButton(
            onPressed: () {
              Hive.box<UserLevelData>(Globals.levels).getAt(index)
                ?..score = 0
                ..save();
            },
            child: Text('Reset score', style: TextStyle(color: AppData.levelData[index].colors.text)),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Hive.box(Globals.settings).putAll(AppData.defaultUserSettingsData);
            },
            child: Text('Reset settings', style: TextStyle(color: AppData.levelData[index].colors.text)),
          ),
          TextButton(
            onPressed: () {
              for (int i = 1; i < AppData.defaultUserLevelData.length + 1; i++) Hive.box<UserLevelData>(Globals.levels).putAt(index, AppData.defaultUserLevelData[i]);
            },
            child: Text('Reset leveldata', style: TextStyle(color: AppData.levelData[index].colors.text)),
          ),
        ],
      ),
    ];
  }
}

class VolumeSlider extends StatelessWidget {
  final String title;
  final double value;
  final int index;
  final void Function(double) onChanged;

  const VolumeSlider({Key? key, required this.title, required this.index, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppData.levelData[index].colors.text,
              fontSize: Globals.fontSize,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  activeColor: AppData.levelData[index].colors.accent,
                  inactiveColor: AppData.levelData[index].colors.accent.withOpacity(0.4),
                  thumbColor: AppData.levelData[index].colors.text,
                  onChanged: onChanged,
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(color: AppData.levelData[index].colors.text, fontSize: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
