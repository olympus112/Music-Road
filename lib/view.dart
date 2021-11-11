import 'package:flutter/material.dart';
import 'package:musicroad/level.dart';

import 'appdata.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => ViewState();
}

class ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Expanded(
          flex: 1,
          child: Center(
            child: Text(
              'Select level',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Center(
            child: SizedBox(
              height: 600,
              child: PageView.builder(
                controller: PageController(
                  viewportFraction: 0.8,
                ),
                itemCount: AppData.of(context).levels.length,
                itemBuilder: (BuildContext context, int index) {
                  return Level(data: AppData.of(context).levels[index]);
                },
              ),
            ),
          ),
        ),
        const Expanded(
          flex: 2,
          child: Center(
            child: SizedBox.square(
              dimension: 100,
              child: IconButton(
                onPressed: null,
                color: Colors.green,
                iconSize: 80,
                icon: Icon(Icons.play_arrow),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
