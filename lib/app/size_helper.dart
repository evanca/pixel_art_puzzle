import 'package:flutter/cupertino.dart';

import '../layout/breakpoints.dart';
import '../layout/responsive_layout_builder.dart';

class SizeHelper {
  static ResponsiveLayoutSize getSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= PuzzleBreakpoints.small) {
      return ResponsiveLayoutSize.small;
    }
    if (screenWidth <= PuzzleBreakpoints.medium) {
      return ResponsiveLayoutSize.medium;
    }
    if (screenWidth <= PuzzleBreakpoints.large) {
      return ResponsiveLayoutSize.large;
    }

    return ResponsiveLayoutSize.large;
  }
}
