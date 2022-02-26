import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/l10n/l10n.dart';
import '/layout/layout.dart';
import '/theme/theme.dart';
import '../../colors/colors.dart';

/// {@template number_of_moves_and_tiles_left}
/// Displays how many moves have been made on the current puzzle
/// and how many puzzle tiles are not in their correct position.
/// {@endtemplate}
class NumberOfMovesAndTilesLeft extends StatelessWidget {
  /// {@macro number_of_moves_and_tiles_left}
  const NumberOfMovesAndTilesLeft({
    Key? key,
    required this.numberOfMoves,
    required this.numberOfTilesLeft,
    this.color,
  }) : super(key: key);

  /// The number of moves to be displayed.
  final int numberOfMoves;

  /// The number of tiles left to be displayed.
  final int numberOfTilesLeft;

  /// The color of texts that display [numberOfMoves] and [numberOfTilesLeft].
  /// Defaults to [PuzzleTheme.defaultColor].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ResponsiveLayoutBuilder(
      small: (context, child) => Center(child: child),
      medium: (context, child) => Center(child: child),
      large: (context, child) => child!,
      child: (currentSize) {
        final bodyTextStyle = currentSize == ResponsiveLayoutSize.small
            ? GoogleFonts.pressStart2p(
                fontSize: 18, color: PuzzleColors.pixel50)
            : GoogleFonts.pressStart2p(
                fontSize: 20, color: PuzzleColors.pixel50);

        return Semantics(
          label: l10n.puzzleNumberOfMovesAndTilesLeftLabelText(
            numberOfMoves.toString(),
            numberOfTilesLeft.toString(),
          ),
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              key: const Key('number_of_moves_and_tiles_left'),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedDefaultTextStyle(
                      style: bodyTextStyle,
                      key: const Key('number_of_moves_and_tiles_left_moves'),
                      duration: PuzzleThemeAnimationDuration.duration,
                      child: Text(numberOfMoves.toString().toUpperCase()),
                    ),
                    AnimatedDefaultTextStyle(
                      style: bodyTextStyle,
                      duration: PuzzleThemeAnimationDuration.duration,
                      child: Text(' ${l10n.puzzleNumberOfMoves.toUpperCase()}'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedDefaultTextStyle(
                      style: bodyTextStyle,
                      key: const Key(
                          'number_of_moves_and_tiles_left_tiles_left'),
                      duration: PuzzleThemeAnimationDuration.duration,
                      child: Text(numberOfTilesLeft.toString().toUpperCase()),
                    ),
                    AnimatedDefaultTextStyle(
                      style: bodyTextStyle,
                      duration: PuzzleThemeAnimationDuration.duration,
                      child: Text(
                          ' ${l10n.puzzleNumberOfTilesLeft.toUpperCase()}'),
                    ),
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
