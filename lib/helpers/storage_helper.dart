import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_art_puzzle/models/highscore.dart';

import '../preferences/preferences.dart';

class StorageHelper {
  FirebaseDatabase? database;
  DatabaseReference? ref;

  init() {
    database = FirebaseDatabase.instance;
    ref = FirebaseDatabase.instance.ref(); //database reference object
  }

  saveHighScore(HighScore score) async {
    if (ref == null) {
      init();
    }

    await ref?.push().set(score.toMap());
  }

  Future<List<HighScore>> retrieveHighScores() async {
    List<HighScore> highScores = [];
    List maps = [];

    try {
      if (ref == null) {
        init();
      }

      DatabaseEvent event = await ref!.once();
      DataSnapshot snapshot = event.snapshot;

      for (var child in snapshot.children) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(json.encode(child.value)));
        maps.add(data);
      }
    } catch (e, s) {
      // Use local storage in case something went wrong:
      debugPrint(e.toString());
      debugPrint(s.toString());
      if (Prefs().highScores.getValue() != '') {
        maps = jsonDecode(Prefs().highScores.getValue());
      }
    }

    highScores = maps.map((e) => HighScore.fromMap(e)).toList();
    return highScores;
  }
}
