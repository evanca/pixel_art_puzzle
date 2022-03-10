import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pixel_art_puzzle/colors/colors.dart';
import 'package:pixel_art_puzzle/theme/theme.dart';
import 'package:pixel_art_puzzle/typography/typography.dart';

import '../../audio_control/widget/audio_control_listener.dart';
import '../../helpers/audio_player.dart';

/// {@template puzzle_button}
/// Displays the puzzle action button.
/// {@endtemplate}
class PuzzleButton extends StatelessWidget {
  /// {@macro puzzle_button}
  PuzzleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  /// The background color of this button.
  /// Defaults to [PuzzleTheme.buttonColor].
  final Color? backgroundColor;

  /// The text color of this button.
  /// Defaults to [PuzzleColors.white].
  final Color? textColor;

  /// Called when this button is tapped.
  final VoidCallback? onPressed;

  /// The label of this button.
  final Widget child;

  final AudioPlayer _clickAudioPlayer = getAudioPlayer()
    ..setAsset('assets/audio/click.mp3');

  @override
  Widget build(BuildContext context) {
    final buttonTextColor = textColor ?? PuzzleColors.white;
    final buttonBackgroundColor = backgroundColor ?? PuzzleColors.pixelPrimary;

    return AudioControlListener(
      audioPlayer: _clickAudioPlayer,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 32),
        width: 145,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              buttonBackgroundColor,
              buttonBackgroundColor.withOpacity(0.7)
            ],
            stops: const [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: AnimatedTextButton(
          duration: PuzzleThemeAnimationDuration.duration,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            textStyle: PuzzleTextStyle.headline5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ).copyWith(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(buttonTextColor),
          ),
          onPressed: () {
            unawaited(_clickAudioPlayer.play());

            if (onPressed != null) {
              onPressed!();
            }
          },
          child: child,
        ),
      ),
    );
  }
}
