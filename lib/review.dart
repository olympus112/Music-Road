import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:musicroad/backend.dart';
import 'package:musicroad/globals.dart';
import 'package:musicroad/userdata.dart';

class Review extends StatefulWidget {
  final Color color;

  const Review({Key? key, required this.color}) : super(key: key);

  @override
  ReviewState createState() => ReviewState();
}

class ReviewState extends State<Review> {
  int satisfied = 5;
  int difficulty = 5;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: IntroductionScreen(
        pages: [
          reviewPage(context),
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
        showSkipButton: false,
      ),
    );
  }

  void onDone() {
    final level = Hive.box(Globals.user).get(UserData.lastPlayed) + 1;
    Backend.review(level, satisfied, difficulty);

    Navigator.pop(context);
  }

  PageViewModel reviewPage(BuildContext context) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Please review this level!',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      bodyWidget: Column(
        children: [
          const Text(
            'How much do you like the music in this level on a scale from 0 to 10?',
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
                  value: satisfied.toDouble(),
                  onChanged: (value) => setState(() => satisfied = value.toInt()),
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
            'How difficult do you experience this level on a scale from 0 to 10?',
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
                  value: difficulty.toDouble(),
                  onChanged: (value) => setState(() => difficulty = value.toInt()),
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
        ],
      ),
    );
  }
}
