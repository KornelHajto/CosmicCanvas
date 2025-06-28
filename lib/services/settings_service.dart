import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String keyDefaultToToday = 'default_to_today';
  static const String keyLastViewedDate = 'last_viewed_date';
  static const String keyShowCopyright = 'show_copyright';
  static const String keyShowDescription = 'show_description';

  Future<bool> getDefaultToToday() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDefaultToToday) ?? true;
  }

  Future<void> setDefaultToToday(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDefaultToToday, value);
  }

  Future<String?> getLastViewedDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyLastViewedDate);
  }

  Future<void> setLastViewedDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLastViewedDate, date);
  }

  Future<bool> getShowCopyright() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyShowCopyright) ?? true;
  }

  Future<void> setShowCopyright(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyShowCopyright, value);
  }

  Future<bool> getShowDescription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyShowDescription) ?? true;
  }

  Future<void> setShowDescription(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyShowDescription, value);
  }
}
