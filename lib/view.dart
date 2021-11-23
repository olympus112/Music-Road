import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicroad/buy.dart';
import 'package:musicroad/statistics.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/utils.dart';
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

    currentIndex = 1;
    currentTitle = getTitle(false);
    currentBackground = getBackground();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          background(),
          title(context),
          Widgets.coins(),
          level(context),
          indicator(context),
          Widgets.settings(context, currentIndex),
        ],
      ),
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
    return Positioned(
      top: 0,
      width: Utils.width(context),
      height: Utils.height(context, fraction: topFraction),
      child: Center(
        child: AnimatedSwitcher(
          duration: Globals.duration,
          child: currentTitle,
        ),
      ),
    );
  }

  Widget level(BuildContext context) {
    return Positioned(
      width: Utils.width(context),
      height: Utils.height(context),
      child: TransformerPageView(
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
            return Padding(
              padding: EdgeInsets.only(
                top: Utils.height(context, fraction: topFraction),
                bottom: Utils.height(context, fraction: bottomFraction + indicatorFraction),
              ),
              child: AppData.levelData[info.index].scores == null
                  ? Level(info: info)
                  : FlipCard(
                      controller: flipControllers[info.index],
                      flipOnTouch: false,
                      onFlipDone: (front) => setState(() {
                        currentTitle = getTitle(front);
                      }),
                      front: Level(info: info),
                      back: Statistics(info: info),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget indicator(BuildContext context) {
    return Positioned(
      width: Utils.width(context),
      height: Utils.height(context, fraction: indicatorFraction),
      bottom: Utils.height(context, fraction: bottomFraction),
      child: Center(
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
      ),
    );
  }

  void onPlay(int index) {
    print('Trying to play $index');
    Navigator.of(context).pushNamed('/unity', arguments: index);
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
