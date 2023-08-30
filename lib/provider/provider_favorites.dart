import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluter_tuto/models/model_favorite.dart';

class FavoritesProvider with ChangeNotifier {
  List<Favorite> _favorites = [];

  List<Favorite> get favorites => [..._favorites];

  void addFavorite(Favorite favorite) async {
    _favorites.insert(0, favorite);
    notifyListeners();
    await _saveToPrefs();
  }

  void removeFavorite(Favorite favorite) {
    _favorites.removeWhere((fav) =>
        fav.sourceName == favorite.sourceName &&
        fav.destinationName == favorite.destinationName &&
        fav.sourceX == favorite.sourceX &&
        fav.sourceY == favorite.sourceY &&
        fav.destinationX == favorite.destinationX &&
        fav.destinationY == favorite.destinationY
    );
    notifyListeners();
    _saveToPrefs();
  }

  void toggleFavoriteStatus(Favorite favorite) {
    final existingIndex = _favorites.indexWhere((fav) =>
    fav.sourceName == favorite.sourceName &&
        fav.destinationName == favorite.destinationName &&
        fav.sourceX == favorite.sourceX &&
        fav.sourceY == favorite.sourceY &&
        fav.destinationX == favorite.destinationX &&
        fav.destinationY == favorite.destinationY
    );

    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
    } else {
      _favorites.add(favorite);
    }
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(
      _favorites.map((f) => {
        'sourceName': f.sourceName,
        'destinationName': f.destinationName,
        'sourceX': f.sourceX,
        'sourceY': f.sourceY,
        'destinationX': f.destinationX,
        'destinationY': f.destinationY,
      }).toList(),
    );
    await prefs.setString('favorites', jsonData);
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('favorites')) return;

    final jsonData = prefs.getString('favorites');
    if (jsonData == null) return;

    final data = json.decode(jsonData) as List<dynamic>;
    _favorites = data.map((item) => Favorite(
      sourceName: item['sourceName'],
      destinationName: item['destinationName'],
      sourceX: item['sourceX'],
      sourceY: item['sourceY'],
      destinationX: item['destinationX'],
      destinationY: item['destinationY'],
    )).toList();

    notifyListeners();
  }
}
