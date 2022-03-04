import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../preferences/preferences.dart';

class HighScore {
  final String username;
  final int difficulty;
  final int moves;
  final int secondsElapsed;
  final int score;

  int calculateScore() {
    final score =
        ((1 / secondsElapsed * (1 / moves)) * 10000 * (difficulty + 1));
    return score.round();
  }

  HighScore(
      {required this.username,
      required this.difficulty,
      required this.moves,
      required this.secondsElapsed,
      this.score = 0});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'difficulty': difficulty,
      'moves': moves,
      'secondsElapsed': secondsElapsed,
      'score': calculateScore()
    };
  }

  factory HighScore.fromMap(Map<String, dynamic> map) {
    return HighScore(
        username: map['username'] as String,
        difficulty: map['difficulty'] as int,
        moves: map['moves'] as int,
        secondsElapsed: map['secondsElapsed'] as int,
        score: map['score'] as int);
  }

  save() {
    var initialHighScores = Prefs().highScores.getValue();
    List currentHighScores = [];

    if (initialHighScores == "") {
      // Create and save first high score:
      var highScores = [];
      highScores.add(toMap());
      Prefs().highScores.setValue(jsonEncode(highScores));
    }
    if (initialHighScores != "") {
      currentHighScores = jsonDecode(Prefs().highScores.getValue());
      currentHighScores.add(toMap());
      currentHighScores.sort((a, b) => (b["score"]).compareTo(a["score"]));
      // Keep 10 records max:
      currentHighScores = currentHighScores.take(10).toList();
      Prefs().highScores.setValue(jsonEncode(currentHighScores));
    }

    currentHighScores = jsonDecode(Prefs().highScores.getValue());
    debugPrint(currentHighScores.toString());
  }
}
