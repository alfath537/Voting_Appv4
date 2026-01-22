import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static Future<bool> hasVoted(String movie) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('voted_$movie') ?? false;
  }

  static Future<void> setVoted(String movie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voted_$movie', true);
  }
}
