import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:pixel_art_puzzle/helpers/storage_helper.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';
import 'package:pixel_art_puzzle/models/highscore.dart';
import 'package:pixel_art_puzzle/typography/text_styles.dart';
import 'package:pixel_art_puzzle/widgets/back_button.dart';
import 'package:pixel_art_puzzle/widgets/glassmorphic_container.dart';
import 'package:pixel_art_puzzle/widgets/multi_bloc_provider.dart';

import 'app/size_helper.dart';
import 'layout/responsive_layout_builder.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final medalAssets = {
    0: 'assets/images/1st-place_12px.png',
    1: 'assets/images/2nd-place_12px.png',
    2: 'assets/images/3rd-place_12px.png',
  };

  @override
  Widget build(BuildContext context) {
    final isSmallSize =
        SizeHelper.getSize(context) == ResponsiveLayoutSize.small;

    return PuzzleMultiBlocProvider(
      child: Scaffold(
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
                      child: FutureBuilder<List<HighScore>>(
                          future: StorageHelper().retrieveHighScores(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ScrollConfiguration(
                                behavior:
                                    ScrollConfiguration.of(context).copyWith(
                                  dragDevices: {
                                    PointerDeviceKind.touch,
                                    PointerDeviceKind.mouse,
                                  },
                                ),
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children:
                                      List.generate(snapshot.data!.length, (i) {
                                    String? medalAsset = medalAssets[i];
                                    HighScore highScore = snapshot.data![i];
                                    return DefaultTextStyle(
                                      style: medalAsset != null
                                          ? PuzzleTextStyle.headline4
                                          : PuzzleTextStyle.body,
                                      child: Padding(
                                        padding: isSmallSize
                                            ? const EdgeInsets.only(bottom: 8.0)
                                            : const EdgeInsets.fromLTRB(
                                                32, 0, 32, 16),
                                        child: Row(
                                          children: [
                                            medalAsset != null
                                                ? Image.asset(
                                                    medalAsset,
                                                    fit: BoxFit.contain,
                                                    filterQuality:
                                                        FilterQuality.none,
                                                    width: 42.0,
                                                  )
                                                : const SizedBox(width: 42.0),
                                            const Gap(8.0),
                                            Expanded(
                                                child:
                                                    Text(highScore.username)),
                                            isSmallSize
                                                ? Container()
                                                : Expanded(
                                                    child: Text(
                                                        highScore.moves
                                                                .toString() +
                                                            " " +
                                                            context.l10n
                                                                .puzzleNumberOfMoves,
                                                        textAlign:
                                                            TextAlign.end),
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
                              );
                            }

                            return Center(
                                child: Lottie.asset(
                                    'assets/lf30_editor_cjc2qppz.json',
                                    height: 200,
                                    width: 200));
                          })),
                  PuzzleBackButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
