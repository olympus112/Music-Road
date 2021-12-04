import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:musicroad/backend.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/userdata.dart';
import 'package:musicroad/utils.dart';
import 'package:numberpicker/numberpicker.dart';

class SineTween extends Tween<double> {
  final double offset;
  final double amplitude;

  SineTween({required this.offset, required this.amplitude}) : super(begin: 0, end: 2 * pi);

  @override
  double lerp(double t) {
    return offset + amplitude * (0.5 + 0.5 * sin(super.lerp(t)));
  }
}

class Tutorial extends StatefulWidget {
  final GlobalKey<IntroductionScreenState> introKey = GlobalKey<IntroductionScreenState>();

  final Color color;
  final bool questionaire;

  Tutorial({Key? key, required this.color, this.questionaire = false}) : super(key: key);

  @override
  State<Tutorial> createState() => TutorialState();
}

class TutorialState extends State<Tutorial> with SingleTickerProviderStateMixin {
  int age = 22;
  int gamer = 5;
  int techy = 5;
  bool read = false;

  final ScrollController scrollController = ScrollController();
  late final AnimationController controller;
  late final Animation opacity;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    opacity = SineTween(offset: 0.3, amplitude: 0.7).animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: IntroductionScreen(
        key: widget.introKey,
        pages: [
          //controlTypePage(context),
          if (widget.questionaire) questionaireExplanationPage(context),
          if (widget.questionaire) questionairePage(context),
          if (widget.questionaire) thankYouPage(context),
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
        onDone: onDone,
        showNextButton: true,
        next: const Text('Next', style: TextStyle(fontWeight: FontWeight.w600)),
        showSkipButton: !widget.questionaire,
        skip: !widget.questionaire ? const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)) : null,
        onSkip: () => Navigator.pop(context),
      ),
    );
  }

  void onDone() async {
    if (widget.questionaire) {
      if (!read) {
        widget.introKey.currentState?.animateScroll(0);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please accept the terms.',
              style: TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        );
        return;
      }

      final user = Hive.box(Globals.user);
      if (!user.containsKey(UserData.id)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Center(
              child: Text(
                'Creating user, please wait...',
                style: TextStyle(fontSize: 30, color: widget.color),
                textAlign: TextAlign.center,
              ),
            ),
            duration: const Duration(minutes: 1),
            dismissDirection: DismissDirection.none,
          ),
        );

        final id = await Backend.createUser(
          age,
          gamer,
          techy,
          Hive.box(Globals.settings).get(UserSettingsData.tapControls) ? 'tap' : 'swipe',
        );
        user.put(UserData.id, id);

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'Done.',
              style: TextStyle(fontSize: 18, color: widget.color),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }

    Navigator.pop(context);
  }

  PageViewModel questionaireExplanationPage(BuildContext context) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Please read me!',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        ),
      ),
      bodyWidget: Column(
        children: [
          const Text(
            'This game is part of a study: to gather insights on various aspects of the game, we collect and store anonymous data.\n\n'
            'This data contains information such age, technological skill and gaming skill. \n\n'
            'Additionally, we log actions such as play, pauze, replay and statistics such as score, coins and progress. \n\n'
            'Your data does not contain any type of personal information that can be used to identify you and will be deleted after our study.\n\n'
            'It is important that you have an active internet connection during gameplay!'
            'Furthermore, if you want to play without sound, please use the in-game setting instead of the volume buttons of your phone.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: InkWell(
                  child: Text(
                    'By playing this game, you agree that we collect this data.',
                    style: TextStyle(fontSize: 18, color: widget.color),
                  ),
                  onTap: () => setState(() => read = !read),
                ),
              ),
              Expanded(
                flex: 1,
                child: CupertinoSwitch(
                  value: read,
                  onChanged: (value) => setState(() => read = value),
                  activeColor: widget.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PageViewModel questionairePage(BuildContext context) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Questionaire',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        ),
      ),
      bodyWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'How old are you?',
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          NumberPicker(
            value: age,
            minValue: 1,
            maxValue: 99,
            haptics: true,
            axis: Axis.horizontal,
            textStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
            selectedTextStyle: TextStyle(color: widget.color, fontSize: 30),
            onChanged: (value) => setState(() => age = value),
          ),
          const SizedBox(height: 32),
          const Text(
            'How confident are you with technology such as smartphones on a scale from 0 to 10?',
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              Text(
                '0',
                style: TextStyle(fontSize: 18, color: widget.color),
              ),
              Expanded(
                child: CupertinoSlider(
                  value: techy.toDouble(),
                  onChanged: (value) => setState(() => techy = value.toInt()),
                  thumbColor: widget.color,
                  activeColor: Colors.grey.withOpacity(0.3),
                  divisions: 10,
                  min: 0,
                  max: 10,
                ),
              ),
              Text(
                '10',
                style: TextStyle(fontSize: 18, color: widget.color),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'How much do you consider yourself a gamer on a scale from 0 to 10?',
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              Text(
                '0',
                style: TextStyle(fontSize: 18, color: widget.color),
              ),
              Expanded(
                child: CupertinoSlider(
                  value: gamer.toDouble(),
                  onChanged: (value) => setState(() => gamer = value.toInt()),
                  thumbColor: widget.color,
                  activeColor: Colors.grey.withOpacity(0.3),
                  divisions: 10,
                  min: 0,
                  max: 10,
                  //label: gamer.toString(),
                ),
              ),
              Text(
                '10',
                style: TextStyle(fontSize: 18, color: widget.color),
              ),
            ],
          )
        ],
      ),
    );
  }

  PageViewModel thankYouPage(BuildContext context) {
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
        body: 'Thank you for correctly filling in the questionaire!\n\n'
            'We will now show you a short tutorial on how to play the game.');
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
      bodyWidget: ValueListenableBuilder(
        valueListenable: Hive.box(Globals.settings).listenable(),
        builder: (context, Box box, child) {
          return card('images/tap.png', box.get(UserSettingsData.tapControls) ? Icons.touch_app : Icons.swipe);
        },
      ),
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
