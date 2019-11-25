import 'package:shared_preferences/shared_preferences.dart';

// read
Future<bool> getShowIntroViewsSavedPreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('show_intro_views') ?? true;
}

// write
Future writeShowIntroToPreferences(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('show_intro_views', value);
}
