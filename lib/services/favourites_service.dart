import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/apod_data.dart';

class FavouritesService {
  static const _key = 'favourite_apods';

  Future<List<ApodData>> getFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_key) ?? [];
    return favs.map((e) => ApodData.fromJson(jsonDecode(e))).toList();
  }

  Future<void> addFavourite(ApodData apod) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_key) ?? [];
    if (!favs.any((e) => jsonDecode(e)['date'] == apod.date)) {
      favs.add(jsonEncode(apod.toJson()));
      await prefs.setStringList(_key, favs);
    }
  }

  Future<void> removeFavourite(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_key) ?? [];
    favs.removeWhere((e) => jsonDecode(e)['date'] == date);
    await prefs.setStringList(_key, favs);
  }

  Future<bool> isFavourite(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_key) ?? [];
    return favs.any((e) => jsonDecode(e)['date'] == date);
  }
}
