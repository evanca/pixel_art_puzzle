import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pixel_art_puzzle/audio_control/audio_control.dart';
import 'package:pixel_art_puzzle/dashatar/dashatar.dart';
import 'package:pixel_art_puzzle/helpers/helpers.dart';
import 'package:pixel_art_puzzle/layout/layout.dart';

import '../../colors/colors.dart';
import '../../confetti_animation/confetti_widget.dart';

/// {@template dashatar_share_dialog}
/// Displays a Dashatar share dialog with a score of the completed puzzle
/// and an option to share the score using Twitter or Facebook.
/// {@endtemplate}
class DashatarShareDialog extends StatefulWidget {
  /// {@macro dashatar_share_dialog}
  const DashatarShareDialog({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<DashatarShareDialog> createState() => _DashatarShareDialogState();
}

class _DashatarShareDialogState extends State<DashatarShareDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AudioPlayer _successAudioPlayer;
  late final AudioPlayer _clickAudioPlayer;

  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 10));

  @override
  void initState() {
    super.initState();

    _successAudioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/success.mp3');
    unawaited(_successAudioPlayer.play());

    _clickAudioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/click.mp3');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    Future.delayed(
      const Duration(milliseconds: 140),
      _controller.forward,
    );

    _confettiController.play();
  }

  @override
  void dispose() {
    _successAudioPlayer.dispose();
    _clickAudioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      key: const Key('dashatar_share_dialog_success_audio_player'),
      audioPlayer: _successAudioPlayer,
      child: AudioControlListener(
        key: const Key('dashatar_share_dialog_click_audio_player'),
        audioPlayer: _clickAudioPlayer,
        child: ResponsiveLayoutBuilder(
          small: (_, child) => child!,
          medium: (_, child) => child!,
          large: (_, child) => child!,
          child: (currentSize) {
            const padding = EdgeInsets.fromLTRB(16, 64, 16, 64);

            final closeIconOffset = currentSize == ResponsiveLayoutSize.small
                ? const Offset(16, 32)
                : const Offset(16, 16);

            final crossAxisAlignment = currentSize == ResponsiveLayoutSize.large
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center;

            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/pixel_bg.png'),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.none),
              ),
              child: Stack(
                key: const Key('dashatar_share_dialog'),
                children: [
                  SingleChildScrollView(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: Padding(
                            padding: padding,
                            child: DashatarShareDialogAnimatedBuilder(
                              animation: _controller,
                              builder: (context, child, animation) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: crossAxisAlignment,
                                  children: [
                                    const DashatarScore(),
                                    const ResponsiveGap(
                                      small: 40,
                                      medium: 40,
                                      large: 80,
                                    ),
                                    DashatarShareYourScore(
                                      animation: animation,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        emissionFrequency: 0.1,
                        canvas: Size.fromRadius(
                            MediaQuery.of(context).size.height * .35),
                        colors: const [
                          PuzzleColors.pixelPrimary,
                          PuzzleColors.pixel90,
                          PuzzleColors.difficultyInsane,
                          PuzzleColors.white,
                          PuzzleColors.superPink,
                          PuzzleColors.iconYellow
                        ]),
                  ),
                  Positioned(
                    right: closeIconOffset.dx,
                    top: closeIconOffset.dy,
                    child: GestureDetector(
                      onTap: () {
                        unawaited(_clickAudioPlayer.play());
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        'assets/images/close_12px.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                        width: 36,
                        height: 36,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
