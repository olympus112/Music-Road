import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/utils.dart';

class Tutorial extends StatefulWidget {
  final Color color;

  const Tutorial({Key? key, required this.color}) : super(key: key);

  @override
  State<Tutorial> createState() => TutorialState();
}

class SineTween extends Tween<double> {
  final double offset;
  final double amplitude;

  SineTween({required this.offset, required this.amplitude}) : super(begin: 0, end: 2 * pi);

  @override
  double lerp(double t) {
    return offset + amplitude * (0.5 + 0.5 * sin(super.lerp(t)));
  }
}

class TutorialState extends State<Tutorial> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation opacity;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    opacity = SineTween(offset: 0.3, amplitude: 0.7).animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        controlTypePage(context),
        controlsPage(context),
        jumpPage(context),
        duckPage(context),
        coinsPage(context),
      ],
      color: widget.color,
      doneColor: widget.color,
      nextColor: widget.color,
      skipColor: widget.color,
      dotsDecorator: DotsDecorator(
        activeColor: widget.color,
        color: Colors.black12,
      ),
      showDoneButton: true,
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => Navigator.pop(context),
      showNextButton: true,
      next: const Text('Next', style: TextStyle(fontWeight: FontWeight.w600)),
      showSkipButton: true,
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      onSkip: () => Navigator.pop(context),
    );
  }

  PageViewModel controlTypePage(BuildContext context) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Tutorial',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        ),
      ),
      bodyWidget: Column(
        children: [
          SizedBox(height: Utils.height(context, fraction: 0.2)),
          const Text(
            'Choose your controls!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: Hive.box(Globals.settings).listenable(),
            builder: (context, Box box, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  tapButton(box.get(UserSettingsData.tapControls)),
                  swipeButton(!box.get(UserSettingsData.tapControls)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  PageViewModel controlsPage(BuildContext context) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: ValueListenableBuilder(
          valueListenable: Hive.box(Globals.settings).listenable(),
          builder: (context, Box box, child) {
            return Text(
              box.get(UserSettingsData.tapControls) ? 'Tap to change direction!' : 'Swipe to change direction!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            );
          },
        ),
      ),
      bodyWidget: card('images/tap.png', Icons.touch_app),
    );
  }

  PageViewModel jumpPage(BuildContext context) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Swipe up to jump!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        ),
      ),
      bodyWidget: card(
        'images/jump.png',
        'svg/swipe_up.svg',
      ),
    );
  }

  PageViewModel duckPage(BuildContext context) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Swipe down to duck!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        ),
      ),
      bodyWidget: card(
        'images/duck.png',
        'svg/swipe_down.svg',
      ),
    );
  }

  PageViewModel coinsPage(BuildContext context) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Collect every coin!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        ),
      ),
      bodyWidget: card('images/coins.png', 'images/coin.png'),
    );
  }

  Widget card(String path, dynamic icon) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: Globals.borderRadius,
            side: BorderSide(color: widget.color),
          ),
          child: ClipRRect(
            borderRadius: Globals.borderRadius,
            child: Image.asset(path),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) => icon is IconData
                ? Icon(
                    icon,
                    size: 60,
                    color: Colors.grey.withOpacity(opacity.value),
                  )
                : (icon as String).startsWith('svg')
                    ? SvgPicture.asset(
                        icon,
                        width: 60,
                        color: Colors.grey.withOpacity(opacity.value),
                      )
                    : Opacity(
                        opacity: opacity.value,
                        child: Image.asset(icon, height: 60),
                      ),
          ),
        ),
      ],
    );
  }

  Widget tapButton(bool selected) {
    return button(
      const Icon(Icons.touch_app),
      'Tap',
      selected,
      () => Hive.box(Globals.settings).put(UserSettingsData.tapControls, true),
    );
  }

  Widget swipeButton(bool selected) {
    return button(
      const Icon(Icons.swipe),
      'Swipe',
      selected,
      () => Hive.box(Globals.settings).put(UserSettingsData.tapControls, false),
    );
  }

  Widget button(Widget content, String title, bool selected, VoidCallback onTap) {
    return Expanded(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.4,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: Globals.borderRadius,
                side: selected ? BorderSide(color: widget.color) : BorderSide.none,
              ),
              child: InkWell(
                borderRadius: Globals.borderRadius,
                onTap: onTap,
                child: Center(child: content),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: selected ? widget.color : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
