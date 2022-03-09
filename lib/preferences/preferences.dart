import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '/preferences/preference_keys.dart';
import '../constants.dart';

class Prefs {
  static StreamingSharedPreferences? _prefs;

  factory Prefs() => Prefs._internal();

  Prefs._internal();

  Future<void> init() async {
    _prefs ??= await StreamingSharedPreferences.instance;
  }

  late Preference<String> flag = _prefs!.getString(keyFlag, defaultValue: '');

  late Preference<String> highScores =
      _prefs!.getString(keyHighScores, defaultValue: '');

  late Preference<int> difficultyLevel =
      _prefs!.getInt(keyDifficultyLevel, defaultValue: difficultyLevelMedium);

  late Preference<int> puzzleSize =
      _prefs!.getInt(keyPuzzleSize, defaultValue: 4);

  late Preference<String> username =
      _prefs!.getString(keyUsername, defaultValue: 'User');
}
