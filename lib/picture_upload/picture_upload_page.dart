import 'package:flutter/material.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';
import 'package:pixel_art_puzzle/widgets/multi_bloc_provider.dart';

import '/layout/layout.dart';
import '/picture_upload/picture_upload_helper.dart';
import '/puzzle/puzzle.dart';
import '/theme/theme.dart';
import '../app/size_helper.dart';
import '../widgets/glassmorphic_container.dart';

class PictureUploadPage extends StatelessWidget {
  PictureUploadPage({Key? key}) : super(key: key);

  final PictureUploadHelper _helper = PictureUploadHelper.instance;

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
            smallWidth: 300,
            smallHeight: 500,
            largeWidth: 750,
            largeHeight: 500,
            child: StreamBuilder<PictureUploadState>(
              stream: _helper.state,
              builder: (context, snapshot) {
                if (snapshot.data?.loading == true) {
                  return Center(child: Text(context.l10n.pixelating));
                }

                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32.0),
                      Text(context.l10n.uploadPicture),
                      SizedBox(height: isSmallSize ? 16.0 : 32.0),
                      IconButton(
                        onPressed: _helper.pickImage,
                        icon: Image.asset(
                          'assets/images/up-arrow_12px.png',
                          height: 64,
                          width: 64,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                        ),
                      ),
                      if (snapshot.data?.outputCropped != null && !isSmallSize)
                        Flexible(
                          child: Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: snapshot.data?.inputCropped,
                                ),
                              ),
                              SizedBox(width: isSmallSize ? 8.0 : 32.0),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: snapshot.data?.outputCropped,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      if (snapshot.data?.outputCropped != null && isSmallSize)
                        Flexible(
                          child: Column(
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: snapshot.data?.inputCropped,
                                ),
                              ),
                              SizedBox(height: isSmallSize ? 8.0 : 32.0),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: snapshot.data?.outputCropped,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32.0),
                      if (snapshot.data?.outputCropped != null)
                        PuzzleButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const PuzzlePage(),
                              ),
                            );
                          },
                          child: Text(context.l10n.letsPlay.toUpperCase()),
                        ),
                      SizedBox(height: isSmallSize ? 16.0 : 32.0),
                    ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
