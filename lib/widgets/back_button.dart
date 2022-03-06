import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../audio_control/widget/audio_control_listener.dart';
import '../helpers/audio_player.dart';

class PuzzleBackButton extends StatelessWidget {
  PuzzleBackButton({Key? key}) : super(key: key);

  final AudioPlayer _clickAudioPlayer = getAudioPlayer()
    ..setAsset('assets/audio/click.wav');

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      audioPlayer: _clickAudioPlayer,
      child: GestureDetector(
        onTap: () {
          unawaited(_clickAudioPlayer.play());
          Navigator.of(context).maybePop();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            'assets/images/back_12px.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.none,
            width: 36,
            height: 36,
          ),
        ),
      ),
    );
  }
}
