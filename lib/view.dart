import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:musicroad/buy.dart';
import 'package:musicroad/statistics.dart';
import 'package:musicroad/unity.dart';
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

  Widget? currentTitle;
  Widget? currentBackground;

  final double topFraction = 4 / 25;
  final double indicatorFraction = 2 / 25;
  final double bottomFraction = 2 / 25;

  @override
  void initState() {
    flipControllers = [
      for (final _ in AppData.of(context).levels) FlipCardController(),
    ];

    currentBackground = getBackground(AppData.of(context));
    currentTitle = getTitle(AppData.of(context), false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = AppData.of(context);
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          background(context, data),
          title(context, data),
          Widgets.coins(context, data),
          level(context, data),
          indicator(context, data),
          Widgets.settings(context, data, () => Widgets.showSettings(context, data)),
        ],
      ),
    );
  }

  Widget getTitle(AppDataState data, bool statistics) {
    return Text(
      statistics
          ? 'Statistics'
          : data.statistics?.unlocked == false
              ? 'Buy level'
              : 'Select level',
      key: ValueKey({data.statistics, statistics}),
      style: TextStyle(
        fontSize: 30,
        color: data.colors.text,
      ),
    );
  }

  Widget getBackground(AppDataState data) {
    return Widgets.blurredBackground(data.song.cover);
  }

  Widget background(BuildContext context, AppDataState data) {
    return AnimatedSwitcher(
      duration: Globals.duration,
      child: currentBackground,
    );
  }

  Widget title(BuildContext context, AppDataState data) {
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

  Widget level(BuildContext context, AppDataState data) {
    return Positioned(
      width: Utils.width(context),
      height: Utils.height(context),
      child: TransformerPageView(
        index: data.currentIndex,
        loop: true,
        itemCount: AppData.of(context).levels.length,
        onPageChanged: (index) => setState(() {
          data.currentIndex = index;
          currentBackground = getBackground(data);
          currentTitle = getTitle(data, flipControllers[index].state?.isFront == false);
        }),
        transformer: PageTransformerBuilder(
          builder: (child, info) {
            return Padding(
              padding: EdgeInsets.only(
                top: Utils.height(context, fraction: topFraction),
                bottom: Utils.height(context, fraction: bottomFraction + indicatorFraction),
              ),
              child: data.statistics == null
                  ? Level(info: info)
                  : FlipCard(
                      controller: flipControllers[info.index],
                      flipOnTouch: false,
                      onFlipDone: (front) => setState(() {
                        currentTitle = getTitle(data, front);
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

  Widget indicator(BuildContext context, AppDataState data) {
    return Positioned(
      width: Utils.width(context),
      height: Utils.height(context, fraction: indicatorFraction),
      bottom: Utils.height(context, fraction: bottomFraction),
      child: Center(
        child: AnimatedSmoothIndicator(
          activeIndex: data.currentIndex,
          count: data.levels.length,
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

  void onPlay(AppDataState data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UnityPlayer(),
      ),
    );
  }

  void onBuy(AppDataState data) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: data.colors.accent),
            borderRadius: Globals.borderRadius,
          ),
          child: BuyLevelDialog(
            data: data,
            onBuy: () {
              setState(() {
                if (data.coins >= data.song.price) {
                  data.coins -= data.song.price;
                  data.statistics?.unlocked = true;

                  currentTitle = getTitle(data, false);
                }
              });
            },
          ),
        );
      },
    );
  }
}
