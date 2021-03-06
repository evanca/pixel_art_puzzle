import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pixel_art_puzzle/models/highscore.dart';

import '../preferences/preferences.dart';

class StorageHelper {
  FirebaseDatabase? database;
  DatabaseReference? ref;
  FirebaseAuth auth = FirebaseAuth.instance;

  init() async {
    try {
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

    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }
  }

  saveHighScore(Map map) async {
    try {
      if (ref == null) {
        await init();
      }

      await ref?.push().set(map);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }
  }

  Future<List<HighScore>> retrieveHighScores() async {
    List<HighScore> highScores = [];
    List maps = [];

    try {
      if (ref == null) {
        await init();
      }

      DatabaseEvent event =
          await ref!.once().timeout(const Duration(seconds: 3), onTimeout: () {
        throw Exception();
      });

      DataSnapshot snapshot = event.snapshot;

      if (snapshot.children.isNotEmpty) {
        for (var child in snapshot.children) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(json.decode(json.encode(child.value)));
          maps.add(data);
        }
      }
    } catch (e, s) {
      // Use local storage in case something went wrong:
      log(e.toString());
      log(s.toString());
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
