import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PuzzleBackButton extends StatelessWidget {
  const PuzzleBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).maybePop();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          'assets/images/back_12px.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
          width: 36,
          height: 36,
        ),
      ),
    );
  }
}
