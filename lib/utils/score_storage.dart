import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorage {
  static const _keyMaxScore = 'max_score';

  static Future<int> getMaxScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMaxScore) ?? 0;
  }

  static Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentMax = prefs.getInt(_keyMaxScore) ?? 0;
    if (score > currentMax) {
      await prefs.setInt(_keyMaxScore, score);
    }
  }
}
