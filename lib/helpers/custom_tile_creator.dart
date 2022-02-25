import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;

import '../preferences/preferences.dart';

class CustomTileCreator {
  static final CustomTileCreator instance =
      CustomTileCreator._privateConstructor();

  CustomTileCreator._privateConstructor();

  List<Image> tileImages = [];

  void splitInputImage({required img.Image image}) {
    tileImages = [];

    final size = Prefs().puzzleSize.getValue();

    int x = 0, y = 0;
    int width = (image.width / size).round();
    int height = (image.height / size).round();

    List<img.Image> parts = [];

    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        parts.add(img.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    tileImages = [];
    for (var imgPart in parts) {
      tileImages.add(Image.memory(img.encodeJpg(imgPart) as Uint8List));
    }

    log('Split images cnt: ${tileImages.length}');
  }
}
