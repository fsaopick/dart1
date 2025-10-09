import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  static const String _themeKey = 'theme_mode';

  Future<bool> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_themeKey, isDark);
  }

  Future<bool?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey);
  }
}