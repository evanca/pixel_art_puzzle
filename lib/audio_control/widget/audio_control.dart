import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_art_puzzle/audio_control/audio_control.dart';
import 'package:pixel_art_puzzle/layout/layout.dart';
import 'package:pixel_art_puzzle/theme/theme.dart';

/// {@template audio_control}
/// Displays and allows to update the current audio status of the puzzle.
/// {@endtemplate}
class AudioControl extends StatelessWidget {
  /// {@macro audio_control}
  const AudioControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final audioMuted =
        context.select((AudioControlBloc bloc) => bloc.state.muted);
    final audioAsset =
        audioMuted ? theme.audioControlOffAsset : theme.audioControlOnAsset;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<AudioControlBloc>().add(AudioToggled()),
        child: AnimatedSwitcher(
          duration: PuzzleThemeAnimationDuration.backgroundColorChange,
          child: ResponsiveLayoutBuilder(
              key: Key(audioAsset),
              small: (_, child) => child!,
              medium: (_, child) => child!,
              large: (_, child) => child!,
              child: (currentSize) {
                return Image.asset(
                  audioAsset,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  width: 48,
                  height: 48,
                );
              }),
        ),
      ),
    );
  }
}
