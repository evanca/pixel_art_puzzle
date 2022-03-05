import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:pixel_art_puzzle/constants.dart';
import 'package:rxdart/rxdart.dart';

import 'custom_pixabay_provider.dart';

class PixabayState {
  bool loading = false;
  List<img.Image> images = [];
  List<Image> widgets = [];
}

class PixabayHelper {
  static final PixabayHelper instance = PixabayHelper._privateConstructor();

  PixabayState _currentState = PixabayState();
  final BehaviorSubject<PixabayState> _state = BehaviorSubject();

  Stream<PixabayState> get state => _state.stream;

  PixabayHelper._privateConstructor();

  CustomPixabayProvider api = CustomPixabayProvider(apiKey: pixabayKey);

  get hasImages => _currentState.images.isNotEmpty;

  Future<bool> loadPictures(int cnt) async {
    _currentState.loading = true;
    _currentState.images = [];
    _state.add(_currentState);

    int pageNumber = Random().nextInt(50) + 1;

    PixabayResponse? res;

    try {
      res = await api.requestImages(
          page: pageNumber, resultsPerPage: cnt, category: Category.nature);
    } catch (e) {
      debugPrint('Could not fetch images');
    }

    if (res != null) {
      for (var f in res.hits!) {
        final bytes = await api.downloadMedia(f, Resolution.tiny);
        _currentState.images.add(img.Image.from(
          img.decodeImage(bytes.toBytes())!,
        ));
        _currentState.widgets.add(Image.memory(bytes.toBytes(),
            height: 500, width: 500, fit: BoxFit.cover));
        _state.add(_currentState);
      }
    }

    _currentState.loading = false;
    _state.add(_currentState);
    return _currentState.images.isNotEmpty;
  }

  void clearState() {
    _currentState = PixabayState();
    _state.add(_currentState);
  }

  Future<void> dispose() async {
    _state.close();
  }
}
