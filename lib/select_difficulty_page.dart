import 'package:flutter/material.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';
import 'package:pixel_art_puzzle/picture_upload/picture_upload_page.dart';
import 'package:pixel_art_puzzle/preferences/preferences.dart';
import 'package:pixel_art_puzzle/theme/widgets/puzzle_button.dart';
import 'package:pixel_art_puzzle/widgets/back_button.dart';
import 'package:pixel_art_puzzle/widgets/difficulty_button.dart';
import 'package:pixel_art_puzzle/widgets/glassmorphic_container.dart';
import 'package:pixel_art_puzzle/widgets/multi_bloc_provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'app/size_helper.dart';
import 'colors/colors.dart';
import 'constants.dart';
import 'layout/responsive_layout_builder.dart';

class SelectDifficultyPage extends StatelessWidget {
  const SelectDifficultyPage({Key? key}) : super(key: key);

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(context.l10n.selectDifficulty),
                SizedBox(height: isSmallSize ? 16.0 : 32.0),
                PreferenceBuilder(
                  preference: Prefs().difficultyLevel,
                  builder: (BuildContext context, value) {
                    return Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        DifficultyButton(
                          assetName: 'assets/images/difficulty/easy_12px.png',
                          backgroundColor: PuzzleColors.difficultyEasy,
                          difficultyLevel: difficultyLevelEasy,
                          puzzleSize: 3,
                          label: context.l10n.difficulty0,
                        ),
                        DifficultyButton(
                          assetName: 'assets/images/difficulty/medium_12px.png',
                          backgroundColor: PuzzleColors.difficultyMedium,
                          difficultyLevel: difficultyLevelMedium,
                          puzzleSize: 4,
                          label: context.l10n.difficulty1,
                        ),
                        DifficultyButton(
                          assetName: 'assets/images/difficulty/hard_12px.png',
                          backgroundColor: PuzzleColors.difficultyHard,
                          difficultyLevel: difficultyLevelHard,
                          puzzleSize: 5,
                          label: context.l10n.difficulty2,
                        ),
                        DifficultyButton(
                          assetName: 'assets/images/difficulty/insane_12px.png',
                          backgroundColor: PuzzleColors.difficultyInsane,
                          difficultyLevel: difficultyLevelInsane,
                          puzzleSize: 10,
                          label: context.l10n.difficulty3,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PuzzleBackButton(),
                    PuzzleButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const PictureUploadPage(),
                          ),
                        );
                      },
                      child: Text(context.l10n.globalNext.toUpperCase()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
