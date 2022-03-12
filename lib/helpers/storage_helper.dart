import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_art_puzzle/models/highscore.dart';

import '../preferences/preferences.dart';

class StorageHelper {
  FirebaseDatabase? database;
  DatabaseReference? ref;
  FirebaseAuth auth = FirebaseAuth.instance;

  init() async {
    auth.userChanges().listen((User? user) {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('User is signed in!');
      }
    });

    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();

    database = FirebaseDatabase.instance;
    ref = FirebaseDatabase.instance.ref(); //database reference object
  }

  saveHighScore(Map map) async {
    if (ref == null) {
      await init();
    }

    await ref?.push().set(map);
  }

  Future<List<HighScore>> retrieveHighScores() async {
    List<HighScore> highScores = [];
    List maps = [];

    try {
      if (ref == null) {
        await init();
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

    maps.sort((a, b) => (b["score"]).compareTo(a["score"]));
    // Keep 10 records max:
    maps = maps.take(10).toList();

    highScores = maps.map((e) => HighScore.fromMap(e)).toList();
    return highScores;
  }
}
