import 'package:flutter/cupertino.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../layout/responsive_layout_builder.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
        child: child!,
      ),
      medium: (_, child) => Padding(
        padding: const EdgeInsets.fromLTRB(64, 128, 64, 128),
        child: child!,
      ),
      large: (_, child) => Padding(
        padding: const EdgeInsets.fromLTRB(128, 256, 128, 256),
        child: child!,
      ),
      child: (currentSize) => GlassmorphicFlexContainer(
        borderRadius: 20,
        blur: 10,
        alignment: Alignment.center,
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
  }
}
