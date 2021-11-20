import 'package:flutter/material.dart';
import 'package:musicroad/appdata.dart';
import 'package:musicroad/widgets.dart';

import 'globals.dart';

class SettingsDialog extends StatefulWidget {
  final AppDataState data;
  final double heightFraction;

  const SettingsDialog({Key? key, required this.data, this.heightFraction = 0.7}) : super(key: key);

  @override
  State<SettingsDialog> createState() => SettingsDialogState();
}

class SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Globals.levelSideMargin),
      child: Material(
        elevation: 4,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: widget.data.colors.accent),
          borderRadius: Globals.borderRadius,
        ),
        child: ClipRRect(
          borderRadius: Globals.borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              background(context, widget.data),
              content(context, widget.data),
              close(context, widget.data),
            ],
          ),
        ),
      ),
    );
  }

  Widget background(BuildContext context, AppDataState data) {
    return Widgets.blurredBackground(data.song.cover);
  }

  Widget content(BuildContext context, AppDataState data) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(Globals.levelContentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Settings',
                style: TextStyle(color: data.colors.text, fontSize: 40),
              ),
            ),
            Divider(
              color: data.colors.text,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            VolumeSlider(
              title: 'Level volume',
              data: data,
              value: data.levelVolume,
              onChanged: (value) {
                setState(() {
                  data.levelVolume = value;
                });
              },
            ),
            VolumeSlider(
              title: 'FX volume',
              data: data,
              value: data.fxVolume,
              onChanged: (value) {
                setState(() {
                  data.fxVolume = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              secondary: Text(
                'Show tutorial',
                style: TextStyle(color: data.colors.text, fontSize: Globals.fontSize),
              ),
              activeColor: data.colors.accent.withOpacity(0.3),
              controlAffinity: ListTileControlAffinity.leading,
              value: data.showTutorial,
              onChanged: (value) {
                setState(() {
                  data.showTutorial = value ?? false;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget close(BuildContext context, AppDataState data) {
    return Positioned(
      bottom: Globals.levelContentPadding * 2,
      left: 0,
      right: 0,
      child: Widgets.button(context, data, Icons.close, data.colors.accent, () => Navigator.pop(context)),
    );
  }
}

class VolumeSlider extends StatelessWidget {
  final String title;
  final double value;
  final AppDataState data;
  final void Function(double) onChanged;

  const VolumeSlider({Key? key, required this.title, required this.data, required this.value, required this.onChanged}) : super(key: key);

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
              color: data.colors.text,
              fontSize: Globals.fontSize,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  activeColor: data.colors.accent,
                  inactiveColor: data.colors.accent.withOpacity(0.4),
                  thumbColor: data.colors.text,
                  onChanged: onChanged,
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(color: data.colors.text, fontSize: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
