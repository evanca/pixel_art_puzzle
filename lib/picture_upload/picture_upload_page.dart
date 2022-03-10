import 'package:flutter/material.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';
import 'package:pixel_art_puzzle/pixabay_images/pixabay_view.dart';
import 'package:pixel_art_puzzle/widgets/multi_bloc_provider.dart';

import '/layout/layout.dart';
import '/picture_upload/picture_upload_helper.dart';
import '/puzzle/puzzle.dart';
import '/theme/theme.dart';
import '../app/size_helper.dart';
import '../pixabay_images/pixabay_helper.dart';
import '../widgets/back_button.dart';
import '../widgets/glassmorphic_container.dart';

class PictureUploadPage extends StatefulWidget {
  const PictureUploadPage({Key? key}) : super(key: key);

  @override
  State<PictureUploadPage> createState() => _PictureUploadPageState();
}

class _PictureUploadPageState extends State<PictureUploadPage> {
  final PictureUploadHelper _pictureUploadHelper = PictureUploadHelper.instance;
  final PixabayHelper _pixabayHelper = PixabayHelper.instance;

  @override
  void dispose() {
    _pictureUploadHelper.clearState();
    _pixabayHelper.clearState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallSize =
        SizeHelper.getSize(context) == ResponsiveLayoutSize.small;

    return PuzzleMultiBlocProvider(
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/pixel_bg.png'),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.none),
            ),
            child: PuzzleGlassmorphicContainer(
              child: StreamBuilder<PictureUploadState>(
                stream: _pictureUploadHelper.state,
                builder: (context, snapshot) {
                  if (snapshot.data?.loading == true) {
                    return Center(child: Text(context.l10n.pixelating));
                  }

                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (snapshot.data?.outputCropped == null)
                          Expanded(
                            flex: 3,
                            child: PixabayView(
                              pictureCount: isSmallSize ? 4 : 8,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(context.l10n.uploadPicture),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(isSmallSize ? 16.0 : 32.0),
                          onPressed: _pictureUploadHelper.pickImage,
                          icon: Image.asset(
                            'assets/images/up-arrow_12px.png',
                            height: 64,
                            width: 64,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none,
                          ),
                        ),
                        if (snapshot.data?.outputCropped != null &&
                            !isSmallSize)
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                        if (snapshot.data?.outputCropped != null)
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
                                            const PuzzlePage(),
                                      ),
                                    );
                                  },
                                  child:
                                      Text(context.l10n.letsPlay.toUpperCase()),
                                )
                              ]),
                      ]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
