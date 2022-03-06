import 'package:flutter/material.dart';

import '../leaderboard_page.dart';

class LeaderboardButton extends StatelessWidget {
  const LeaderboardButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const LeaderboardPage()));
      },
      child: Image.asset(
        'assets/images/trophy_12px.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
        width: 48,
        height: 48,
      ),
    );
  }
}
