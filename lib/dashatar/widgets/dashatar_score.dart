import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pixel_art_puzzle/dashatar/dashatar.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';
import 'package:pixel_art_puzzle/layout/layout.dart';
import 'package:pixel_art_puzzle/puzzle/puzzle.dart';
import 'package:pixel_art_puzzle/theme/theme.dart';
import 'package:pixel_art_puzzle/theme/themes/themes.dart';
import 'package:pixel_art_puzzle/typography/typography.dart';
import 'package:pixel_art_puzzle/widgets/glassmorphic_container.dart';
import 'package:pixel_art_puzzle/widgets/multi_bloc_provider.dart';

import '../../colors/colors.dart';

/// {@template dashatar_score}
/// Displays the score of the solved Dashatar puzzle.
/// {@endtemplate}
class DashatarScore extends StatelessWidget {
  /// {@macro dashatar_score}
  const DashatarScore({Key? key}) : super(key: key);

  static const _smallImageOffset = Offset(124, 36);
  static const _mediumImageOffset = Offset(215, -47);
  static const _largeImageOffset = Offset(215, -47);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((DashatarThemeBloc bloc) => bloc.state.theme);
    final state = context.watch<PuzzleBloc>().state;
    final l10n = context.l10n;

    return PuzzleMultiBlocProvider(
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          final height =
              currentSize == ResponsiveLayoutSize.small ? 374.0 : 355.0;

          final imageOffset = currentSize == ResponsiveLayoutSize.large
              ? _largeImageOffset
              : (currentSize == ResponsiveLayoutSize.medium
                  ? _mediumImageOffset
                  : _smallImageOffset);

          final imageHeight =
              currentSize == ResponsiveLayoutSize.small ? 374.0 : 437.0;

          final completedTextWidth = currentSize == ResponsiveLayoutSize.small
              ? 160.0
              : double.infinity;

          final wellDoneTextStyle = currentSize == ResponsiveLayoutSize.small
              ? PuzzleTextStyle.headline4Soft
              : PuzzleTextStyle.headline3;

          final timerTextStyle = currentSize == ResponsiveLayoutSize.small
              ? PuzzleTextStyle.headline5
              : PuzzleTextStyle.headline4;

          final timerIconSize = currentSize == ResponsiveLayoutSize.small
              ? const Size(21, 21)
              : const Size(28, 28);

          final timerIconPadding =
              currentSize == ResponsiveLayoutSize.small ? 4.0 : 6.0;

          final numberOfMovesTextStyle =
              currentSize == ResponsiveLayoutSize.small
                  ? PuzzleTextStyle.headline5
                  : PuzzleTextStyle.headline4;

          return ClipRRect(
            key: const Key('dashatar_score'),
            borderRadius: BorderRadius.circular(22),
            child: PuzzleGlassmorphicContainer(
              largeWidth: double.infinity,
              smallWidth: double.infinity,
              largeHeight: height,
              smallHeight: height,
              child: Stack(
                children: [
                  // Positioned(
                  //   left: imageOffset.dx,
                  //   top: imageOffset.dy,
                  //   child: Image.asset(
                  //     theme.successThemeAsset,
                  //     height: imageHeight,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(16),
                        AnimatedDefaultTextStyle(
                          style: PuzzleTextStyle.headline4,
                          duration: PuzzleThemeAnimationDuration.duration,
                          child: Text(
                            '${l10n.dashatarSuccessCompleted} ${l10n.dashatarSuccessWellDone}',
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const Spacer(),
                        const ResponsiveGap(
                          small: 24,
                          medium: 32,
                          large: 32,
                        ),
                        DashatarTimer(
                          textStyle: timerTextStyle,
                          iconSize: timerIconSize,
                          iconPadding: timerIconPadding,
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        const ResponsiveGap(
                          small: 8,
                          medium: 16,
                          large: 16,
                        ),
                        AnimatedDefaultTextStyle(
                          key: const Key('dashatar_score_number_of_moves'),
                          style: PuzzleTextStyle.timerTextStyle
                              .copyWith(color: PuzzleColors.pixel50),
                          duration: PuzzleThemeAnimationDuration.duration,
                          child: Text(
                            l10n.dashatarSuccessNumberOfMoves(
                              state.numberOfMoves.toString(),
                            ),
                          ),
                        ),
                        const Gap(32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/images/trophy_12px.png',
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.none,
                              width: 48,
                              height: 48,
                            ),
                            const Gap(8),
                            Text(
                              context.l10n.leaderboard,
                              style: PuzzleTextStyle.timerTextStyle.copyWith(
                                  color: PuzzleColors.pixelPrimary,
                                  fontSize: 18),
                            )
                          ],
                        ),
                        const Gap(16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
