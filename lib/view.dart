import 'package:flutter/material.dart';
import 'package:musicroad/unity.dart';
import 'package:musicroad/utils.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'appdata.dart';
import 'level.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => ViewState();
}

class ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Utils.height(context),
      child: Column(
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
            flex: 9,
            child: Center(
              child: SizedBox(
                height: 600,
                child: TransformerPageView(
                  loop: true,
                  viewportFraction: 0.8,
                  itemCount: AppData.of(context).levels.length,
                  transformer: PageTransformerBuilder(
                    builder: (child, info) {
                      return Level(info: info);
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox.square(
                dimension: 100,
                child: IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UnityPlayer())),
                  color: Colors.green,
                  iconSize: 80,
                  icon: const Icon(Icons.play_arrow),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
