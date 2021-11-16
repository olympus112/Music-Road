import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:musicroad/statistics.dart';
import 'package:musicroad/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'appdata.dart';
import 'globals.dart';
import 'level.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => ViewState();
}

class ViewState extends State<View> {
  late final FlipCardController flipController;

  Widget? currentTitle;
  Widget? currentBackground;
  Widget? currentButton;

  final double topFraction = 3 / 25;
  final double indicatorFraction = 1 / 25;
  final double bottomFraction = 4 / 25;

  @override
  void initState() {
    flipController = FlipCardController();

    currentBackground = getBackground(AppData.of(context));
    currentButton = getButton(AppData.of(context));
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
          top(context, data),
          coins(context, data),
          card(context, data),
          indicator(context, data),
          bottom(context, data),
          settings(context, data),
        ],
      ),
    );
  }

  Widget getTitle(AppDataState data, bool statistics) {
    return Text(
      statistics
          ? 'Statistics'
          : data.analytics.unlocked
              ? 'Select level'
              : 'Buy level',
      key: ValueKey({data.analytics, statistics}),
      style: TextStyle(
        fontSize: 30,
        color: data.colors.text,
      ),
    );
  }

  Widget getBackground(AppDataState data) {
    return Container(
      key: ValueKey(data.song),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(data.song.cover), fit: BoxFit.cover),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget getButton(AppDataState data) {
    return Padding(
      key: ValueKey(data.song),
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 8),
      child: RawMaterialButton(
        elevation: 0,
        onPressed: () => data.analytics.unlocked ? onPlay(data) : onBuy(data),
        shape: const CircleBorder(),
        child: data.analytics.unlocked
            ? Icon(
                Icons.play_arrow,
                size: 70,
                color: data.colors.play,
              )
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: data.colors.play),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        Globals.coinPath,
                        filterQuality: FilterQuality.medium,
                        height: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${data.song.price}',
                        style: TextStyle(fontSize: 20, color: data.colors.text),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget background(BuildContext context, AppDataState data) {
    return AnimatedSwitcher(
      duration: Globals.duration,
      child: currentBackground,
    );
  }

  Widget coins(BuildContext context, AppDataState data) {
    return Positioned(
      right: 0,
      top: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Globals.coinPath,
              filterQuality: FilterQuality.medium,
              height: 20,
            ),
            const SizedBox(width: 8),
            Text(
              data.coins.toString(),
              style: TextStyle(color: data.colors.text, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  Widget settings(BuildContext context, AppDataState data) {
    return Positioned(
      left: 0,
      top: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox.square(
          dimension: 24,
          child: RawMaterialButton(
            elevation: 0,
            onPressed: () => onSettings(data),
            shape: const CircleBorder(),
            child: Icon(
              Icons.settings,
              color: data.colors.text,
            ),
          ),
        ),
      ),
    );
  }

  Widget top(BuildContext context, AppDataState data) {
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

  Widget card(BuildContext context, AppDataState data) {
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
          currentButton = getButton(data);
          currentTitle = getTitle(data, false);
        }),
        transformer: PageTransformerBuilder(
          builder: (child, info) {
            return Padding(
              padding: EdgeInsets.only(
                top: Utils.height(context, fraction: topFraction),
                bottom: Utils.height(context, fraction: bottomFraction + indicatorFraction),
              ),
              child: data.currentIndex == 0
                  ? Level(info: info)
                  : FlipCard(
                      controller: flipController,
                      onFlip: () => setState(() {
                        currentTitle = getTitle(data, flipController.state?.isFront == true);
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

  Widget bottom(BuildContext context, AppDataState data) {
    return Positioned(
      bottom: 0,
      width: Utils.width(context),
      height: Utils.height(context, fraction: bottomFraction),
      child: Center(
        child: AnimatedSwitcher(
          duration: Globals.duration,
          child: currentButton,
        ),
      ),
    );
  }

  void onPlay(AppDataState data) {
    // Launch unity
  }

  void onBuy(AppDataState data) {
    setState(() {
      if (data.coins >= data.song.price) {
        data.coins -= data.song.price;
        data.analytics.unlocked = true;

        currentButton = getButton(data);
        currentTitle = getTitle(data, false);
      }
    });
  }

  void onSettings(AppDataState data) {}
}
