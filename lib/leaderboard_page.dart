import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';
import 'package:pixel_art_puzzle/models/highscore.dart';
import 'package:pixel_art_puzzle/preferences/preferences.dart';
import 'package:pixel_art_puzzle/typography/text_styles.dart';
import 'package:pixel_art_puzzle/widgets/glassmorphic_container.dart';

import 'app/size_helper.dart';
import 'layout/responsive_layout_builder.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late List<HighScore> highScores;

  final medalAssets = {
    0: 'assets/images/1st-place_12px.png',
    1: 'assets/images/2nd-place_12px.png',
    2: 'assets/images/3rd-place_12px.png',
  };

  @override
  void initState() {
    if (Prefs().highScores.getValue() != '') {
      List maps = jsonDecode(Prefs().highScores.getValue());
      highScores = maps.map((e) => HighScore.fromMap(e)).toList();
    } else {
      highScores = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallSize =
        SizeHelper.getSize(context) == ResponsiveLayoutSize.small;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/pixel_bg.png'),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none),
        ),
        child: PuzzleGlassmorphicContainer(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Center(child: Text(context.l10n.leaderboard)),
                SizedBox(height: isSmallSize ? 16.0 : 32.0),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(highScores.length, (i) {
                        String? medalAsset = medalAssets[i];
                        HighScore highScore = highScores[i];
                        return DefaultTextStyle(
                          style: medalAsset != null
                              ? PuzzleTextStyle.headline4
                              : PuzzleTextStyle.body,
                          child: Padding(
                            padding: isSmallSize
                                ? const EdgeInsets.only(bottom: 8.0)
                                : const EdgeInsets.fromLTRB(32, 0, 32, 16),
                            child: Row(
                              children: [
                                medalAsset != null
                                    ? Image.asset(
                                        medalAsset,
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.none,
                                        width: 42.0,
                                      )
                                    : const SizedBox(width: 42.0),
                                const Gap(8.0),
                                Expanded(child: Text(highScore.username)),
                                isSmallSize
                                    ? Container()
                                    : Expanded(
                                        child: Text(
                                            highScore.moves.toString() +
                                                " " +
                                                context
                                                    .l10n.puzzleNumberOfMoves,
                                            textAlign: TextAlign.end),
                                      ),
                                Expanded(
                                    child: Text(
                                  highScore.score.toString(),
                                  textAlign: TextAlign.end,
                                ))
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
