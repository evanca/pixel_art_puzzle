import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_art_puzzle/audio_control/audio_control.dart';
import 'package:pixel_art_puzzle/dashatar/dashatar.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';
import 'package:pixel_art_puzzle/layout/layout.dart';
import 'package:pixel_art_puzzle/models/models.dart';
import 'package:pixel_art_puzzle/puzzle/puzzle.dart';
import 'package:pixel_art_puzzle/theme/theme.dart';
import 'package:pixel_art_puzzle/timer/timer.dart';
import 'package:pixel_art_puzzle/typography/typography.dart';
import 'package:pixel_art_puzzle/widgets/glassmorphic_container.dart';
import 'package:pixel_art_puzzle/widgets/glassmorphic_flex_container.dart';
import 'package:pixel_art_puzzle/widgets/multi_bloc_provider.dart';

import '../../app/size_helper.dart';
import '../../preferences/preferences.dart';

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
            smallWidth: double.infinity,
            smallHeight: 150,
            largeWidth: double.infinity,
            largeHeight: 72,
            child: PuzzleHeader()),
        const PuzzleGlassmorphicFlexContainer(
            child: SingleChildScrollView(child: PuzzleSections())),
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
              children: [
                Image.asset(
                  'assets/images/user_12px.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  width: 48,
                  height: 48,
                ),
                SizedBox(
                  width: padding,
                ),
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
                Image.asset(
                  'assets/images/trophy_12px.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  width: 48,
                  height: 48,
                ),
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
      medium: (context, child) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            PuzzleLogo(),
            PuzzleMenu(),
          ],
        ),
      ),
      large: (context, child) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            PuzzleLogo(),
            PuzzleMenu(),
          ],
        ),
      ),
    );
  }
}

/// {@template puzzle_logo}
/// Displays the logo of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleLogo extends StatelessWidget {
  /// {@macro puzzle_logo}
  const PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return AppFlutterLogo(
      key: puzzleLogoKey,
      isColored: theme.isLogoColored,
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
        child: theme.layoutDelegate.boardBuilder(
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

/// {@template puzzle_menu}
/// Displays the menu of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleMenu extends StatelessWidget {
  /// {@macro puzzle_menu}
  const PuzzleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themes = context.select((ThemeBloc bloc) => bloc.state.themes);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          themes.length,
          (index) => PuzzleMenuItem(
            theme: themes[index],
            themeIndex: index,
          ),
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SizedBox(),
          medium: (_, child) => child!,
          large: (_, child) => child!,
          child: (currentSize) {
            return Row(
              children: [
                const Gap(44),
                AudioControl(
                  key: audioControlKey,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}

/// {@template puzzle_menu_item}
/// Displays the menu item of the [PuzzleMenu].
/// {@endtemplate}
@visibleForTesting
class PuzzleMenuItem extends StatelessWidget {
  /// {@macro puzzle_menu_item}
  const PuzzleMenuItem({
    Key? key,
    required this.theme,
    required this.themeIndex,
  }) : super(key: key);

  /// The theme corresponding to this menu item.
  final PuzzleTheme theme;

  /// The index of [theme] in [ThemeState.themes].
  final int themeIndex;

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final isCurrentTheme = theme == currentTheme;

    return ResponsiveLayoutBuilder(
      small: (_, child) => Column(
        children: [
          Container(
            width: 100,
            height: 40,
            decoration: isCurrentTheme
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: currentTheme.menuUnderlineColor,
                      ),
                    ),
                  )
                : null,
            child: child,
          ),
        ],
      ),
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final leftPadding =
            themeIndex > 0 && currentSize != ResponsiveLayoutSize.small
                ? 40.0
                : 0.0;

        return Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Tooltip(
            message:
                theme != currentTheme ? context.l10n.puzzleChangeTooltip : '',
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                // Ignore if this theme is already selected.
                if (theme == currentTheme) {
                  return;
                }

                // Update the currently selected theme.
                context
                    .read<ThemeBloc>()
                    .add(ThemeChanged(themeIndex: themeIndex));

                // Reset the timer of the currently running puzzle.
                context.read<TimerBloc>().add(const TimerReset());

                // Stop the Dashatar countdown if it has been started.
                context.read<DashatarPuzzleBloc>().add(
                      const DashatarCountdownStopped(),
                    );

                // Initialize the puzzle board for the newly selected theme.
                context.read<PuzzleBloc>().add(
                      const PuzzleInitialized(
                        shufflePuzzle: false,
                      ),
                    );
              },
              child: AnimatedDefaultTextStyle(
                duration: PuzzleThemeAnimationDuration.duration,
                style: PuzzleTextStyle.headline5.copyWith(
                  color: isCurrentTheme
                      ? currentTheme.menuActiveColor
                      : currentTheme.menuInactiveColor,
                ),
                child: Text(theme.name),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The global key of [PuzzleLogo].
///
/// Used to animate the transition of [PuzzleLogo] when changing a theme.
final puzzleLogoKey = GlobalKey(debugLabel: 'puzzle_logo');

/// The global key of [PuzzleName].
///
/// Used to animate the transition of [PuzzleName] when changing a theme.
final puzzleNameKey = GlobalKey(debugLabel: 'puzzle_name');

/// The global key of [PuzzleTitle].
///
/// Used to animate the transition of [PuzzleTitle] when changing a theme.
final puzzleTitleKey = GlobalKey(debugLabel: 'puzzle_title');

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
