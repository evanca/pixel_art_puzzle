import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../audio_control/widget/audio_control_listener.dart';
import '../helpers/audio_player.dart';
import '../leaderboard_page.dart';

class LeaderboardButton extends StatelessWidget {
  LeaderboardButton({Key? key}) : super(key: key);

  final AudioPlayer _clickAudioPlayer = getAudioPlayer()
    ..setAsset('assets/audio/click.wav');

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      audioPlayer: _clickAudioPlayer,
      child: GestureDetector(
        onTap: () {
          unawaited(_clickAudioPlayer.play());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const LeaderboardPage()));
        },
        child: Image.asset(
          'assets/images/trophy_12px.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
          width: 48,
          height: 48,
        ),
      ),
    );
  }
}
