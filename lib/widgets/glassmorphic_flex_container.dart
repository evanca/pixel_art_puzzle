import 'package:flutter/cupertino.dart';
import 'package:glassmorphism/glassmorphism.dart';

class PuzzleGlassmorphicFlexContainer extends StatelessWidget {
  const PuzzleGlassmorphicFlexContainer(
      {Key? key, required this.child, this.flex = 1})
      : super(key: key);

  final Widget child;
  final int flex;

  @override
  Widget build(BuildContext context) {
    const padding = 16.0;

    return GlassmorphicFlexContainer(
      flex: flex,
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(padding),
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
    );
  }
}
