import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../app/size_helper.dart';
import '../audio_control/widget/audio_control_listener.dart';
import '../colors/colors.dart';
import '../helpers/audio_player.dart';
import '../layout/responsive_layout_builder.dart';
import '../preferences/preferences.dart';

class DifficultyButton extends StatelessWidget {
  final String assetName;
  final Color backgroundColor;
  final int difficultyLevel;
  final int puzzleSize;
  final String label;

  final AudioPlayer _clickAudioPlayer = getAudioPlayer()
    ..setAsset('assets/audio/click.mp3');

  DifficultyButton(
      {Key? key,
      required this.assetName,
      required this.backgroundColor,
      required this.difficultyLevel,
      required this.puzzleSize,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSmallSize =
        SizeHelper.getSize(context) == ResponsiveLayoutSize.small;

    final bool isSelected =
        Prefs().difficultyLevel.getValue() == difficultyLevel;

    return AudioControlListener(
      audioPlayer: _clickAudioPlayer,
      child: GestureDetector(
        onTap: () {
          unawaited(_clickAudioPlayer.play());
          Prefs().difficultyLevel.setValue(difficultyLevel);
          Prefs().puzzleSize.setValue(puzzleSize);
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(isSmallSize ? 4.0 : 16.0),
              padding: EdgeInsets.all(isSmallSize ? 10.0 : 24.0),
              width: isSmallSize ? 64 : 100,
              height: isSmallSize ? 64 : 100,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
              child: Image.asset(
                assetName,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.none,
              ),
            ),
            Container(
              width: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              child: Text(label),
              decoration: BoxDecoration(
                border: Border(
                  bottom: isSelected
                      ? const BorderSide(
                          width: 8.0, color: PuzzleColors.pixelPrimary)
                      : const BorderSide(width: 8.0, color: Colors.transparent),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
