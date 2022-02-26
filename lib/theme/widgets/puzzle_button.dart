import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_art_puzzle/colors/colors.dart';
import 'package:pixel_art_puzzle/theme/theme.dart';
import 'package:pixel_art_puzzle/typography/typography.dart';

/// {@template puzzle_button}
/// Displays the puzzle action button.
/// {@endtemplate}
class PuzzleButton extends StatelessWidget {
  /// {@macro puzzle_button}
  const PuzzleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  /// The background color of this button.
  /// Defaults to [PuzzleTheme.buttonColor].
  final Color? backgroundColor;

  /// The text color of this button.
  /// Defaults to [PuzzleColors.white].
  final Color? textColor;

  /// Called when this button is tapped.
  final VoidCallback? onPressed;

  /// The label of this button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final buttonTextColor = textColor ?? PuzzleColors.white;
    final buttonBackgroundColor = backgroundColor ?? theme.buttonColor;

    return Container(
      width: 145,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PuzzleColors.pixelPrimary,
            PuzzleColors.pixelPrimary.withOpacity(0.7)
          ],
          stops: const [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: AnimatedTextButton(
        duration: PuzzleThemeAnimationDuration.duration,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: PuzzleTextStyle.headline5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ).copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(buttonTextColor),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
