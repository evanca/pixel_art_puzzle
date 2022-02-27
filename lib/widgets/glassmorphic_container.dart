import 'package:flutter/cupertino.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../layout/responsive_layout_builder.dart';

class PuzzleGlassmorphicContainer extends StatelessWidget {
  const PuzzleGlassmorphicContainer(
      {Key? key,
      this.smallWidth = 300,
      this.smallHeight = 500,
      this.largeWidth = 750,
      this.largeHeight = 600,
      required this.child})
      : super(key: key);

  final double smallWidth;
  final double smallHeight;
  final double largeWidth;
  final double largeHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          final isSmallSize = currentSize == ResponsiveLayoutSize.small;

          return Center(
            child: GlassmorphicContainer(
              margin: const EdgeInsets.all(16),
              width: isSmallSize ? smallWidth : largeWidth,
              height: isSmallSize ? smallHeight : largeHeight,
              borderRadius: 20,
              blur: 10,
              alignment: Alignment.bottomCenter,
              border: 1,
              linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFffffff).withOpacity(0.1),
                    const Color(0xFFFFFFFF).withOpacity(0.05),
                  ],
                  stops: const [
                    0.1,
                    1,
                  ]),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFffffff).withOpacity(0.5),
                  const Color(0xFFFFFFFF).withOpacity(0.5),
                ],
              ),
              child: child,
            ),
          );
        });
  }
}
