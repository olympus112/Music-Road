import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/buy.dart';
import 'package:musicroad/main.dart';
import 'package:musicroad/statistics.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'appdata.dart';
import 'globals.dart';
import 'level.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => ViewState();

  static ViewState of(BuildContext context) {
    final state = context.findAncestorStateOfType<ViewState>();
    assert(state != null);

    return state!;
  }
}

class ViewState extends State<View> {
  late final List<FlipCardController> flipControllers;

  late int currentIndex;
  late Widget currentTitle;
  late Widget currentBackground;

  final double topFraction = 4 / 25;
  final double indicatorFraction = 2 / 25;
  final double bottomFraction = 2 / 25;

  @override
  void initState() {
    flipControllers = [
      for (final _ in AppData.levelData) FlipCardController(),
    ];

    currentIndex = Hive.box(Globals.user).get(UserData.lastPlayed) + 1;
    currentTitle = getTitle(false);
    currentBackground = getBackground();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: Colors.black,
        child: Stack(
          children: [
            background(),
            content(context),
            arrows(),
            Widgets.coins(),
            Widgets.settings(context, currentIndex, true),
          ],
        ),
      ),
    );
  }

  Widget arrows() {
    const double iconSize = 30;
    const double iconPadding = (Globals.levelSideMargin - iconSize) / 2;
    return Positioned.fill(
      left: iconPadding,
      right: iconPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.chevron_left,
            color: Colors.white54,
            size: iconSize,
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white54,
            size: iconSize,
          ),
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    return Column(
      children: [
        Expanded(child: title(context), flex: 4),
        Expanded(child: level(context), flex: 17),
        Expanded(child: indicator(context), flex: 2),
        const Expanded(child: SizedBox(), flex: 2),
      ],
    );
  }

  Widget getTitle(bool statistics) {
    bool locked = Hive.box<UserLevelData>(Globals.levels).getAt(currentIndex)?.unlocked == false;
    return Text(
      statistics
          ? 'Statistics'
          : locked
              ? 'Buy level'
              : 'Select level',
      key: ValueKey({locked, statistics, currentIndex}),
      style: TextStyle(
        fontSize: 30,
        color: AppData.levelData[currentIndex].colors.text,
      ),
    );
  }

  Widget getBackground() {
    return Widgets.blurredBackground(currentIndex);
  }

  Widget background() {
    return AnimatedSwitcher(
      duration: Globals.duration,
      child: currentBackground,
    );
  }

  Widget title(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: Globals.duration,
        child: currentTitle,
      ),
    );
  }

  Widget level(BuildContext context) {
    return TransformerPageView(
      index: currentIndex,
      loop: true,
      itemCount: AppData.levelData.length,
      onPageChanged: (index) => setState(() {
        currentIndex = index;
        currentBackground = getBackground();
        currentTitle = getTitle(flipControllers[index].state?.isFront == false);
      }),
      transformer: PageTransformerBuilder(
        builder: (child, info) {
          return AppData.levelData[info.index].percentages == null
              ? Level(info: info)
              : FlipCard(
                  controller: flipControllers[info.index],
                  flipOnTouch: false,
                  onFlipDone: (front) => setState(() {
                    currentTitle = getTitle(front);
                  }),
                  front: Level(info: info),
                  back: Statistics(info: info),
                );
        },
      ),
    );
  }

  Widget indicator(BuildContext context) {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: currentIndex,
        count: AppData.levelData.length,
        effect: const ScrollingDotsEffect(
          dotWidth: 8,
          dotHeight: 8,
          activeDotColor: Colors.white70,
          dotColor: Colors.white30,
        ),
        onDotClicked: (index) {},
      ),
    );
  }

  void onPlay(int flutterIndex) {
    // Convert to unity index
    bool random = flutterIndex == 0;
    int unityIndex = flutterIndex - 1;
    if (random) {
      final boughtLevels = [];
      final levels = Hive.box<UserLevelData>(Globals.levels);
      for (int i = 1; i < AppData.levelData.length; i++) if (levels.getAt(i)!.unlocked) boughtLevels.add(i - 1);

      unityIndex = boughtLevels[Random(DateTime.now().millisecondsSinceEpoch).nextInt(boughtLevels.length)];
    }

    Hive.box(Globals.user).put(UserData.lastPlayed, unityIndex);

    Navigator.of(context).pop();
    App.unity.currentState!.unityStartLevel(unityIndex, random);
  }

  void onBuy() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppData.levelData[currentIndex].colors.accent),
            borderRadius: Globals.borderRadius,
          ),
          child: BuyLevelDialog(
            index: currentIndex,
            onBuy: () {
              final level = Hive.box<UserLevelData>(Globals.levels).getAt(currentIndex)!;
              final user = Hive.box(Globals.user);
              final coins = user.get(UserData.coins);
              final price = AppData.levelData[currentIndex].song.price;

              if (coins >= price) {
                user.put(UserData.coins, coins - price);

                level.unlocked = true;
                level.save();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.black54,
                    content: Text(
                      'Insufficient coins',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppData.levelData[currentIndex].colors.accent),
                    ),
                  ),
                );
              }

              currentTitle = getTitle(false);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
