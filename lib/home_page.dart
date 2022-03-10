import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_art_puzzle/app/size_helper.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';
import 'package:pixel_art_puzzle/widgets/multi_bloc_provider.dart';

import 'colors/colors.dart';
import 'layout/responsive_layout_builder.dart';
import 'preferences/preferences.dart';
import 'select_difficulty_page.dart';
import 'theme/widgets/puzzle_button.dart';
import 'widgets/glassmorphic_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSmallSize =
        SizeHelper.getSize(context) == ResponsiveLayoutSize.small;

    return PuzzleMultiBlocProvider(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/pixel_bg.png"),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none),
          ),
          child: PuzzleGlassmorphicContainer(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(
                children: const [
                  Opacity(
                    opacity: 0,
                    // This hack allows to preload emoji font for web
                    child: Text('😺'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(context.l10n.enterPlayerName),
              SizedBox(height: isSmallSize ? 16.0 : 32.0),
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: isSmallSize ? 3 : 2,
                    child: TextField(
                      style: GoogleFonts.pressStart2p(),
                      cursorColor: PuzzleColors.white,
                      decoration: InputDecoration(
                          hintStyle: GoogleFonts.pressStart2p(
                              fontSize: isSmallSize ? 14 : 22),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: PuzzleColors.pixel90,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: PuzzleColors.white,
                            ),
                          ),
                          hintText: Prefs().username.getValue()),
                      onChanged: (text) {
                        if (text.isNotEmpty) {
                          Prefs().username.setValue(text);
                        }
                      },
                    ),
                  ),
                  const Spacer()
                ],
              ),
              const SizedBox(height: 32.0),
              PuzzleButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const SelectDifficultyPage(),
                    ),
                  );
                },
                child: Text(context.l10n.globalNext.toUpperCase()),
              ),
              const SizedBox(height: 32.0),
            ]),
          ),
        ),
      ),
    );
  }
}
