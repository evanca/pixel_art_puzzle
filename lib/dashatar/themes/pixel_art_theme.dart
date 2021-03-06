import 'package:flutter/material.dart';
import 'package:pixel_art_puzzle/colors/colors.dart';
import 'package:pixel_art_puzzle/dashatar/dashatar.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';

/// {@template pixel_art_theme}
/// The pixel art puzzle theme.
/// {@endtemplate}
class PixelArtTheme extends DashatarTheme {
  /// {@macro pixel_art_theme}
  const PixelArtTheme() : super();

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.dashatarGreenDashLabelText;

  @override
  Color get backgroundColor => PuzzleColors.pixelPrimary;

  @override
  Color get defaultColor => PuzzleColors.pixel90;

  @override
  Color get buttonColor => PuzzleColors.pixel50;

  @override
  Color get menuInactiveColor => PuzzleColors.pixel50;

  @override
  Color get countdownColor => PuzzleColors.pixel50;

  @override
  String get themeAsset => 'assets/images/dashatar/gallery/green.png';

  @override
  String get successThemeAsset => 'assets/images/dashatar/success/green.png';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/mute_12px.png';

  @override
  String get dashAssetsDirectory => 'assets/images/dashatar/green';
}
