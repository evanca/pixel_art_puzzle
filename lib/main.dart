// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pixel_art_puzzle/app/app.dart';
import 'package:pixel_art_puzzle/bootstrap.dart';
import 'package:pixel_art_puzzle/preferences/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions options = const FirebaseOptions(
      apiKey: "AIzaSyCVoo-4HZGMmy8G4Ns2N4X_DjNEHqPJD6k",
      authDomain: "pixel-art-puzzle-a1e13.firebaseapp.com",
      databaseURL: "https://pixel-art-puzzle-a1e13-default-rtdb.firebaseio.com",
      projectId: "pixel-art-puzzle-a1e13",
      storageBucket: "pixel-art-puzzle-a1e13.appspot.com",
      messagingSenderId: "972766593370",
      appId: "1:972766593370:web:820a4aa4d0ef32d49bf363",
      measurementId: "G-6ZFRTLVNYS");

  await Firebase.initializeApp(
    options: options,
  );
  await Prefs().init();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    bootstrap(() => const App());
  });
}
