import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pixel_art_puzzle/l10n/l10n.dart';
import 'package:pixel_art_puzzle/pixabay_images/pixabay_helper.dart';

import '../app/size_helper.dart';
import '../layout/responsive_layout_builder.dart';
import '../picture_upload/picture_upload_helper.dart';

class PixabayView extends StatefulWidget {
  final int pictureCount;

  const PixabayView({Key? key, required this.pictureCount}) : super(key: key);

  @override
  State<PixabayView> createState() => _PixabayViewState();
}

class _PixabayViewState extends State<PixabayView> {
  final PixabayHelper _pixabayHelper = PixabayHelper.instance;
  final PictureUploadHelper _pictureUploadHelper = PictureUploadHelper.instance;

  @override
  void initState() {
    _pixabayHelper.loadPictures(widget.pictureCount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallSize =
        SizeHelper.getSize(context) == ResponsiveLayoutSize.small;

    return StreamBuilder<PixabayState>(
        stream: _pixabayHelper.state,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.images.isNotEmpty) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.choosePicture,
                    textAlign: TextAlign.center,
                  ),
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: isSmallSize ? 1 : 2,
                      child: GridView.count(
                        padding: EdgeInsets.all(isSmallSize ? 16.0 : 32.0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        crossAxisCount: isSmallSize ? 2 : 4,
                        children: List.generate(
                            snapshot.data!.images.length,
                            (i) => GestureDetector(
                                  onTap: () {
                                    _pictureUploadHelper.setPixabayImage(
                                        snapshot.data!.images[i]);
                                  },
                                  child: snapshot.data!.widgets[i],
                                )),
                      ),
                    ),
                  ),
                ]);
          } else if (snapshot.hasData &&
              snapshot.data!.images.isEmpty &&
              snapshot.data!.loading == false) {
            return Container(); // Couldn't fetch pictures, nothing to show
          }
          return Center(
              child: Lottie.asset('assets/lf30_editor_cjc2qppz.json',
                  height: 200, width: 200));
        });
  }
}
