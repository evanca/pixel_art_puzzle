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
    String highScore = jsonEncode(toMap());
    debugPrint(highScore);

    var currentHighScores = Prefs().highScores.getValue();
    if (currentHighScores != "") {
      currentHighScores = jsonDecode(currentHighScores);
    }

    debugPrint(currentHighScores);
  }
}
