import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:rxdart/rxdart.dart';

import '../helpers/custom_tile_creator.dart';

class PictureUploadState {
  bool loading = false;
  Image? inputCropped;
  Image? outputCropped;
}

class PictureUploadHelper {
  static final PictureUploadHelper instance =
      PictureUploadHelper._privateConstructor();

  img.Image? decodedInput;

  PictureUploadState _currentState = PictureUploadState();
  final BehaviorSubject<PictureUploadState> _state = BehaviorSubject();

  Stream<PictureUploadState> get state => _state.stream;

  PictureUploadHelper._privateConstructor();

  Image get outputCropped => _currentState.outputCropped!;

  Future<void> pickImage() async {
    _currentState.loading = true;
    _state.add(_currentState);

    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List inputBytes;
      try {
        inputBytes = result.files.first.bytes!;
      } catch (e) {
        final file = File(result.files.single.path!);
        inputBytes = await file.readAsBytes();
      }

      decodedInput = img.Image.from(
        img.decodeImage(inputBytes)!,
      );

      cropSquare(decodedInput!);
      cropSquareAndPixelate(decodedInput!);
    }

    _currentState.loading = false;
    _state.add(_currentState);
  }

  void cropSquareAndPixelate(img.Image src) {
    final cropped = img.copyResizeCropSquare(src, 500);
    img.contrast(cropped, 125);
    img.quantize(cropped, numberOfColors: 64);

    final pixelatedImage = img.pixelate(cropped, 10);

    _currentState.outputCropped =
        Image.memory(img.encodeJpg(pixelatedImage) as Uint8List);

    CustomTileCreator.instance.splitInputImage(image: pixelatedImage);
  }

  void cropSquare(img.Image src) {
    final cropped = img.copyResizeCropSquare(src, 500);
    _currentState.inputCropped =
        Image.memory(img.encodeJpg(cropped) as Uint8List);
  }

  void setPixabayImage(img.Image pixabayImage) {
    _currentState.outputCropped = null;
    _currentState.loading = true;
    _state.add(_currentState);

    decodedInput = pixabayImage;

    cropSquare(decodedInput!);
    cropSquareAndPixelate(decodedInput!);

    _currentState.loading = false;
    _state.add(_currentState);
  }

  void clearState() {
    _currentState = PictureUploadState();
    _state.add(_currentState);
  }

  Future<void> dispose() async {
    _state.close();
  }
}
