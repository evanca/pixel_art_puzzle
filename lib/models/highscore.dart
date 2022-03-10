import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pixel_art_puzzle/helpers/storage_helper.dart';

import '../preferences/preferences.dart';

List emojis = ["😺", "😸", "😹", "😻"];

class HighScore {
  final String username;
  final int difficulty;
  final int moves;
  final int secondsElapsed;
  int? score;
  String? flag;

  int calculateScore() {
    final score =
        ((1 / secondsElapsed * (1 / moves)) * 10000 * (difficulty + 1));
    return score.round();
  }

  Future<String?> setFlag() async {
    if (Prefs().flag.getValue().isNotEmpty) {
      String flag = Prefs().flag.getValue();
      log("Flag already saved: $flag");
      return flag;
    } else {
      try {
        final response = await http.get(Uri.parse(('http://ip-api.com/json')));

        if (response.statusCode == 200) {
          String countryCode = json.decode(response.body)['countryCode'];

          // Convert country code to emoji:
          String flag = countryCode.toUpperCase().replaceAllMapped(
              RegExp(r'[A-Z]'),
              (match) =>
                  String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
          Prefs().flag.setValue(flag);
          return flag;
        }
      } catch (e) {
        log(e.toString());
        return flag!;
      }
    }
    return null;
  }

  HighScore(
      {required this.username,
      required this.difficulty,
      required this.moves,
      required this.secondsElapsed,
      this.score,
      this.flag}) {
    score ??= calculateScore();
    emojis.shuffle();
    flag ??= emojis[0];
  }

  Future<Map<String, dynamic>> toMap() async {
    flag = await setFlag() ?? flag;

    return {
      'username': username,
      'difficulty': difficulty,
      'moves': moves,
      'secondsElapsed': secondsElapsed,
      'score': score,
      'flag': flag
    };
  }

  factory HighScore.fromMap(Map<String, dynamic> map) {
    return HighScore(
        username: map['username'] as String,
        difficulty: map['difficulty'] as int,
        moves: map['moves'] as int,
        secondsElapsed: map['secondsElapsed'] as int,
        score: map['score'] as int,
        flag: map['flag'] as String);
  }

  save() async {
    var initialHighScores = Prefs().highScores.getValue();
    List currentHighScores = [];

    Map map = await toMap();

    StorageHelper().saveHighScore(map);

    // Save locally in case something goes wrong with Realtime Database:
    if (initialHighScores == "") {
      // Create and save first high score:
      var highScores = [];
      highScores.add(map);
      Prefs().highScores.setValue(jsonEncode(highScores));
    }
    if (initialHighScores != "") {
      currentHighScores = jsonDecode(Prefs().highScores.getValue());
      currentHighScores.add(map);
      currentHighScores.sort((a, b) => (b["score"]).compareTo(a["score"]));
      // Keep 10 records max:
      currentHighScores = currentHighScores.take(10).toList();
      Prefs().highScores.setValue(jsonEncode(currentHighScores));
    }
  }
}
