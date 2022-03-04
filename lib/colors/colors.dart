import 'package:flutter/widgets.dart';

/// Defines the color palette for the puzzle UI.
abstract class PuzzleColors {
  /// Black
  static const Color black = Color(0xFF000000);

  /// Black 2 (opacity 20%)
  static const Color black2 = Color(0x33000000);

  /// Grey 1
  static const Color grey1 = Color(0xFF4A4A4A);

  /// White
  static const Color white = Color(0xFFFFFFFF);

  /// White 2 (opacity 40%)
  static const Color white2 = Color(0x66FFFFFF);

  /// Super Pink
  static const Color superPink = Color(0xFFC46BAE);

  /// Pixel primary
  static const Color pixelPrimary = Color(0xFFE0607E);

  /// Pixel 90
  static const Color pixel90 = Color(0xFFFCE9E9);

  /// Pixel 50
  static const Color pixel50 = Color(0xFF464D77);

  static const Color difficultyEasy = Color(0xFFC1E8F3);
  static const Color difficultyMedium = Color(0xFFACE0EF);
  static const Color difficultyHard = Color(0xFF96D8EB);
  static const Color difficultyInsane = Color(0xFF81D0E7);
}
