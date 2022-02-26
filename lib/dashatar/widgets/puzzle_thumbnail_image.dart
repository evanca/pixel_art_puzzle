import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pixel_art_puzzle/audio_control/audio_control.dart';
import 'package:pixel_art_puzzle/helpers/helpers.dart';
import 'package:pixel_art_puzzle/layout/layout.dart';

import '../../picture_upload/picture_upload_helper.dart';

class PuzzleThumbnailImage extends StatefulWidget {
  const PuzzleThumbnailImage({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  static const _activeThemeNormalSize = 120.0;
  static const _activeThemeSmallSize = 85.0;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<PuzzleThumbnailImage> createState() => _PuzzleThumbnailImageState();
}

class _PuzzleThumbnailImageState extends State<PuzzleThumbnailImage> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          final isSmallSize = currentSize == ResponsiveLayoutSize.small;
          final activeSize = isSmallSize
              ? PuzzleThumbnailImage._activeThemeSmallSize
              : PuzzleThumbnailImage._activeThemeNormalSize;

          return SizedBox(
            key: const Key('dashatar_theme_picker'),
            height: activeSize,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                width: activeSize,
                height: activeSize,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 350),
                child: PictureUploadHelper.instance.outputCropped,
              ),
            ),
          );
        },
      ),
    );
  }
}
