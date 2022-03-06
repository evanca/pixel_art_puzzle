import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_art_puzzle/audio_control/audio_control.dart';
import 'package:pixel_art_puzzle/dashatar/dashatar.dart';
import 'package:pixel_art_puzzle/layout/layout.dart';
import 'package:pixel_art_puzzle/models/models.dart';
import 'package:pixel_art_puzzle/puzzle/puzzle.dart';
import 'package:pixel_art_puzzle/theme/theme.dart';
import 'package:pixel_art_puzzle/timer/timer.dart';
import 'package:pixel_art_puzzle/widgets/glassmorphic_container.dart';
import 'package:pixel_art_puzzle/widgets/glassmorphic_flex_container.dart';
import 'package:pixel_art_puzzle/widgets/multi_bloc_provider.dart';

import '../../app/size_helper.dart';
import '../../preferences/preferences.dart';
import '../../widgets/back_button.dart';
import '../../widgets/leaderboard_button.dart';

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PuzzleMultiBlocProvider(child: PuzzleView());
  }
}

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const shufflePuzzle = false;

    return Scaffold(
      body: AnimatedContainer(
        duration: PuzzleThemeAnimationDuration.backgroundColorChange,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/pixel_bg.png'),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none),
        ),
        child: BlocListener<DashatarThemeBloc, DashatarThemeState>(
          listener: (context, state) {
            final dashatarTheme = context.read<DashatarThemeBloc>().state.theme;
            context.read<ThemeBloc>().add(ThemeUpdated(theme: dashatarTheme));
          },
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => TimerBloc(
                  ticker: const Ticker(),
                ),
              ),
              BlocProvider(
                create: (context) => PuzzleBloc(Prefs().puzzleSize.getValue())
                  ..add(
                    const PuzzleInitialized(
                      shufflePuzzle: shufflePuzzle,
                    ),
                  ),
              ),
            ],
            child: const _Puzzle(
              key: Key('puzzle_view_puzzle'),
            ),
          ),
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSmallSize =
        SizeHelper.getSize(context) == ResponsiveLayoutSize.small;

    return Column(
      children: [
        if (isSmallSize)
          const SizedBox(
            height: 32,
          ),
        const PuzzleGlassmorphicContainer(
            hasPadding: false,
            smallWidth: double.infinity,
            smallHeight: 150,
            largeWidth: double.infinity,
            largeHeight: 72,
            child: PuzzleHeader()),
        PuzzleGlassmorphicFlexContainer(
            child: Center(
          child: ListView(
            shrinkWrap: true,
            children: const [PuzzleSections()],
          ),
        )),
      ],
    );
  }
}

/// {@template puzzle_header}
/// Displays the header of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleHeader extends StatelessWidget {
  /// {@macro puzzle_header}
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSmallSize =
        SizeHelper.getSize(context) == ResponsiveLayoutSize.small;

    final padding = isSmallSize ? 8.0 : 16.0;

    return ResponsiveLayoutBuilder(
      small: (context, child) => Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: padding,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/user_12px.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  width: 48,
                  height: 48,
                ),
                const Gap(16),
                Expanded(
                  child: Text(
                    Prefs().username.getValue(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.pressStart2p(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const DashatarTimer(mainAxisAlignment: MainAxisAlignment.start),
                const Spacer(),
                LeaderboardButton(),
                SizedBox(
                  width: padding,
                ),
                AudioControl(key: audioControlKey),
              ],
            ),
            SizedBox(
              height: padding,
            ),
          ],
        ),
      ),
      medium: (context, child) => Center(
        child: Row(
          children: [
            Gap(padding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/user_12px.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  width: 42,
                  height: 42,
                ),
                Gap(padding),
                Text(
                  Prefs().username.getValue(),
                  style: GoogleFonts.pressStart2p(fontSize: 20),
                ),
              ],
            ),
            const Spacer(),
            const DashatarTimer(),
            const Spacer(),
            LeaderboardButton(),
            Gap(padding),
            AudioControl(key: audioControlKey),
            Gap(padding),
          ],
        ),
      ),
      large: (context, child) => Center(
        child: Row(
          children: [
            Gap(padding),
            Image.asset(
              'assets/images/user_12px.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
              width: 42,
              height: 42,
            ),
            Gap(padding),
            Text(
              Prefs().username.getValue(),
              style: GoogleFonts.pressStart2p(fontSize: 20),
            ),
            const Spacer(),
            const DashatarTimer(),
            const Spacer(),
            LeaderboardButton(),
            Gap(padding),
            AudioControl(key: audioControlKey),
            Gap(padding),
          ],
        ),
      ),
    );
  }
}

/// {@template puzzle_sections}
/// Displays start and end sections of the puzzle.
/// {@endtemplate}
class PuzzleSections extends StatelessWidget {
  /// {@macro puzzle_sections}
  const PuzzleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return ResponsiveLayoutBuilder(
      small: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          const PuzzleBoard(),
          theme.layoutDelegate.endSectionBuilder(state, context),
        ],
      ),
      medium: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: theme.layoutDelegate.startSectionBuilder(state),
          ),
          const Expanded(flex: 2, child: PuzzleBoard()),
          Expanded(
            child: theme.layoutDelegate.endSectionBuilder(state, context),
          ),
        ],
      ),
      large: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: theme.layoutDelegate.startSectionBuilder(state),
          ),
          const PuzzleBoard(),
          Expanded(
            child: theme.layoutDelegate.endSectionBuilder(state, context),
          ),
        ],
      ),
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return PuzzleKeyboardHandler(
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
            context.read<TimerBloc>().add(const TimerStopped());
          }
        },
        child: Column(
          children: [
            theme.layoutDelegate.boardBuilder(
              size,
              puzzle.tiles
                  .map(
                    (tile) => _PuzzleTile(
                      key: Key('puzzle_tile_${tile.value.toString()}'),
                      tile: tile,
                    ),
                  )
                  .toList(),
            ),
            const Gap(32),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              PuzzleBackButton(),
              const DashatarPuzzleActionButton()
            ])
          ],
        ),
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder()
        : theme.layoutDelegate.tileBuilder(tile, state);
  }
}

/// The global key of [NumberOfMovesAndTilesLeft].
///
/// Used to animate the transition of [NumberOfMovesAndTilesLeft]
/// when changing a theme.
final numberOfMovesAndTilesLeftKey =
    GlobalKey(debugLabel: 'number_of_moves_and_tiles_left');

/// The global key of [AudioControl].
///
/// Used to animate the transition of [AudioControl]
/// when changing a theme.
final audioControlKey = GlobalKey(debugLabel: 'audio_control');
