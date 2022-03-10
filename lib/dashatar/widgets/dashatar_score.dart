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

import '../../colors/colors.dart';
import '../../leaderboard_page.dart';
import '../../widgets/leaderboard_button.dart';

/// {@template dashatar_score}
/// Displays the score of the solved Dashatar puzzle.
/// {@endtemplate}
class DashatarScore extends StatelessWidget {
  /// {@macro dashatar_score}
  const DashatarScore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PuzzleBloc>().state;
    final l10n = context.l10n;

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final height =
            currentSize == ResponsiveLayoutSize.small ? 374.0 : 400.0;

        final timerTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline5
            : PuzzleTextStyle.headline4;

        final timerIconSize = currentSize == ResponsiveLayoutSize.small
            ? const Size(21, 21)
            : const Size(28, 28);

        final timerIconPadding =
            currentSize == ResponsiveLayoutSize.small ? 4.0 : 6.0;

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Spacer(),
                    AnimatedDefaultTextStyle(
                      style: PuzzleTextStyle.headline4,
                      duration: PuzzleThemeAnimationDuration.duration,
                      child: Text(
                        l10n.dashatarSuccessCompleted,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      style: PuzzleTextStyle.headline4,
                      duration: PuzzleThemeAnimationDuration.duration,
                      child: Text(
                        l10n.dashatarSuccessWellDone,
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
                      mainAxisAlignment: MainAxisAlignment.end,
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LeaderboardPage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LeaderboardButton(),
                          const Gap(8),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                context.l10n.leaderboard,
                                style: PuzzleTextStyle.timerTextStyle.copyWith(
                                    color: PuzzleColors.pixelPrimary,
                                    fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(16),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
