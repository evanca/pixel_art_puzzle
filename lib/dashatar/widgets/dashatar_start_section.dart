import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_art_puzzle/dashatar/dashatar.dart';
import 'package:pixel_art_puzzle/layout/layout.dart';
import 'package:pixel_art_puzzle/puzzle/puzzle.dart';
import 'package:pixel_art_puzzle/theme/theme.dart';

import '../../app/size_helper.dart';

/// {@template dashatar_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
class DashatarStartSection extends StatelessWidget {
  /// {@macro dashatar_start_section}
  const DashatarStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final status =
        context.select((DashatarPuzzleBloc bloc) => bloc.state.status);

    final isSmallSize =
        SizeHelper.getSize(context) == ResponsiveLayoutSize.small;

    return isSmallSize
        ? Container()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NumberOfMovesAndTilesLeft(
                      key: numberOfMovesAndTilesLeftKey,
                      numberOfMoves: state.numberOfMoves,
                      numberOfTilesLeft: status == DashatarPuzzleStatus.started
                          ? state.numberOfTilesLeft
                          : state.puzzle.tiles.length - 1,
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
